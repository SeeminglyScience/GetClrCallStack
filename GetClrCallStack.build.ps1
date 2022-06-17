#requires -Version 5.1

[CmdletBinding()]
param(
    [ValidateSet('Debug', 'Release')]
    [string] $Configuration = 'Debug',

    [switch] $GenerateCodeCoverage,

    [switch] $Force
)

$moduleName = 'GetClrCallStack'
$testModuleManifestSplat = @{
    ErrorAction   = 'Ignore'
    WarningAction = 'Ignore'
    Path          = "$PSScriptRoot\module\$moduleName.psd1"
}

$manifest = Test-ModuleManifest @testModuleManifestSplat

$script:Settings = @{
    Name          = $moduleName
    Manifest      = $manifest
    Version       = $manifest.Version
    ShouldTest    = $true
}

$script:Folders  = @{
    PowerShell = "$PSScriptRoot\module"
    CSharp     = "$PSScriptRoot\src"
    Build      = '{0}\src\{1}\bin\{2}' -f $PSScriptRoot, $moduleName, $Configuration
    Release    = '{0}\Release\{1}\{2}' -f $PSScriptRoot, $moduleName, $manifest.Version
    Docs       = "$PSScriptRoot\docs"
    Test       = "$PSScriptRoot\test"
    Results    = "$PSScriptRoot\testresults"
}

$script:Discovery = @{
    HasDocs       = Test-Path ('{0}\{1}\*.md' -f $Folders.Docs, $PSCulture)
    HasTests      = Test-Path ('{0}\*.Tests.ps1' -f $Folders.Test)
    IsUnix        = $PSVersionTable.PSEdition -eq "Core" -and -not $IsWindows
}

$tools = "$PSScriptRoot\tools"
$script:GetDotNet = Get-Command $tools\GetDotNet.ps1
$script:AssertModule = Get-Command $tools\AssertRequiredModule.ps1

task AssertDotNet {
    $script:dotnet = & $GetDotNet -Unix:$Discovery.IsUnix
}

task AssertRequiredModules {
    & $AssertModule InvokeBuild 5.8.4 -Force:$Force.IsPresent
}

task AssertDevDependencies -Jobs AssertDotNet, AssertRequiredModules

task Clean {
    if ($PSScriptRoot -and (Test-Path $PSScriptRoot\Release)) {
        Remove-Item $PSScriptRoot\Release -Recurse
    }

    $null = New-Item $Folders.Release -ItemType Directory
    if (Test-Path $Folders.Results) {
        Remove-Item $Folders.Results -Recurse
    }

    $null = New-Item $Folders.Results -ItemType Directory
    & $dotnet clean --verbosity quiet -nologo
}

task BuildDll {
    & $dotnet publish --configuration $Configuration --framework netstandard2.0 --verbosity quiet -nologo
}

task CopyToRelease  {
    $release = $Folders.Release
    $bin = '{0}\netstandard2.0\publish\*' -f $Folders.Build

    $null = New-Item $release -Force -ItemType Directory
    Copy-Item -Path $bin -Destination $release -Force
}

task DoInstall {
    $sourcePath  = '{0}\*' -f $Folders.Release
    $installBase = $Home
    if ($profile) { $installBase = $profile | Split-Path }
    $installPath = '{0}\Modules\{1}\{2}' -f $installBase, $Settings.Name, $Settings.Version

    if (-not (Test-Path $installPath)) {
        $null = New-Item $installPath -ItemType Directory
    }

    Copy-Item -Path $sourcePath -Destination $installPath -Force -Recurse
}

task DoPublish {
    if ($Configuration -eq 'Debug') {
        throw 'Configuration must not be Debug to publish!'
    }

    if ($env:GALLERY_API_KEY) {
        $apiKey = $env:GALLERY_API_KEY
    } else {
        $userProfile = [Environment]::GetFolderPath([Environment+SpecialFolder]::UserProfile)
        if (Test-Path $userProfile/.PSGallery/apikey.xml) {
            $apiKey = (Import-Clixml $userProfile/.PSGallery/apikey.xml).GetNetworkCredential().Password
        }
    }

    if (-not $apiKey) {
        throw 'Could not find PSGallery API key!'
    }

    Publish-Module -Name $Folders.Release -NuGetApiKey $apiKey -Force:$Force.IsPresent
}

task Build -Jobs AssertDevDependencies, Clean, BuildDll, CopyToRelease

task Test -Jobs Build

task PreRelease -Jobs Test

task Install -Jobs PreRelease, DoInstall

task Publish -Jobs PreRelease, DoPublish

task . Build
