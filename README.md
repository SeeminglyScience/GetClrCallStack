<h1 align="center">GetClrCallStack</h1>

<p align="center">
    <sub>
       Get the call stack of every thread in the target process.
    </sub>
    <br /><br />
    <a title="Commits" href="https://github.com/SeeminglyScience/GetClrCallStack/commits/master">
        <img alt="Build Status" src="https://github.com/SeeminglyScience/GetClrCallStack/workflows/build/badge.svg" />
    </a>
    <a title="GetClrCallStack on PowerShell Gallery" href="https://www.powershellgallery.com/packages/GetClrCallStack">
        <img alt="PowerShell Gallery Version (including pre-releases)" src="https://img.shields.io/powershellgallery/v/GetClrCallStack?include_prereleases&label=gallery">
    </a>
    <a title="LICENSE" href="https://github.com/SeeminglyScience/GetClrCallStack/blob/main/LICENSE">
        <img alt="GitHub" src="https://img.shields.io/github/license/SeeminglyScience/GetClrCallStack">
    </a>
</p>

Just one command that makes it easier for folks to report the status of a process when it appears non-responsive.

**This is not intended to be a supported product and is purely to assist with troubleshooting.**

## Installation

### Gallery

```powershell
Install-Module GetClrCallStack -Scope CurrentUser
```

### PowerShellGet v3

```powershell
Install-PSResource GetClrCallStack
```

### Source

```powershell
git clone 'https://github.com/SeeminglyScience/GetClrCallStack.git'
Set-Location ./GetClrCallStack
./build.ps1
```

## Usage
```powershell
Get-ClrCallStack 3423
```

```powershell
# Technically you can pipe multiple processes, but the output doesn't really account for it.
Get-Process pwsh |
    Where-Object Id -ne $PID |
    Select-Object -First 1 |
    Get-ClrCallStack
```

## Example Output

```raw
    Thread: ConsoleHost main thread

IL     Method
--     ------
0x000  System.Threading.WaitHandle.WaitOneCore(IntPtr, Int32)
0x04C  System.Threading.WaitHandle.WaitOneNoCheck(Int32)
0x01B  System.Management.Automation.Runspaces.PipelineBase.Invoke(System.Collections.IEnumerable)
0x000  System.Management.Automation.Runspaces.Pipeline.Invoke()
0x12C  System.Management.Automation.PowerShell+Worker.ConstructPipelineAndDoWork(System.Management.Automation.Runspaces.Runspace, Boolean)
0x094  System.Management.Automation.PowerShell+Worker.CreateRunspaceIfNeededAndDoWork(System.Management.Automation.Runspaces.Runspace, Boolean)
0x0D8  System.Management.Automation.PowerShell.CoreInvokeHelper[[System.__Canon, System.Private.CoreLib],[System.__Canon,
       System.Private.CoreLib]](System.Management.Automation.PSDataCollection`1<System.__Canon>, System.Management.Automation.PSDataCollection`1<System.__Canon>,
       System.Management.Automation.PSInvocationSettings)
0x1AE  System.Management.Automation.PowerShell.CoreInvoke[[System.__Canon, System.Private.CoreLib],[System.__Canon,
       System.Private.CoreLib]](System.Management.Automation.PSDataCollection`1<System.__Canon>, System.Management.Automation.PSDataCollection`1<System.__Canon>,
       System.Management.Automation.PSInvocationSettings)
0x043  System.Management.Automation.PowerShell.CoreInvoke[[System.__Canon, System.Private.CoreLib]](System.Collections.IEnumerable,
       System.Management.Automation.PSDataCollection`1<System.__Canon>, System.Management.Automation.PSInvocationSettings)
0x00B  System.Management.Automation.PowerShell.Invoke(System.Collections.IEnumerable, System.Management.Automation.PSInvocationSettings)
0x000  System.Management.Automation.PowerShell.Invoke()
0x06B  Microsoft.PowerShell.ConsoleHostUserInterface.TryInvokeUserDefinedReadLine(System.String ByRef)
0x037  Microsoft.PowerShell.ConsoleHostUserInterface.ReadLineWithTabCompletion(Microsoft.PowerShell.Executor)
0x098  Microsoft.PowerShell.ConsoleHost+InputLoop.Run(Boolean)
0x034  Microsoft.PowerShell.ConsoleHost+InputLoop.RunNewInputLoop(Microsoft.PowerShell.ConsoleHost, Boolean)
0x040  Microsoft.PowerShell.ConsoleHost.EnterNestedPrompt()
0x03E  Microsoft.PowerShell.ConsoleHost.DoRunspaceLoop(System.String, Boolean, System.Collections.ObjectModel.Collection`1<System.Management.Automation.Runspaces.CommandParameter>, Boolean,
       System.String)
0x13D  Microsoft.PowerShell.ConsoleHost.Run(Microsoft.PowerShell.CommandLineParameterParser, Boolean)
0x2B1  Microsoft.PowerShell.ConsoleHost.Start(System.String, System.String)
0x03E  Microsoft.PowerShell.UnmanagedPSEntry.Start(System.String[], Int32)
0x000  Microsoft.PowerShell.ManagedPSEntry.Main(System.String[])

    Thread: .NET ThreadPool Worker

IL     Method
--     ------
0x000  Interop+Kernel32.<GetQueuedCompletionStatus>g____PInvoke__|50_0(IntPtr, Int32*, UIntPtr*, IntPtr*, Int32)
0x000  Interop+Kernel32.<GetQueuedCompletionStatus>g____PInvoke__|50_0(IntPtr, Int32*, UIntPtr*, IntPtr*, Int32)
0x000  System.Threading.LowLevelLifoSemaphore.WaitForSignal(Int32)
0x000  System.Threading.LowLevelLifoSemaphore.Wait(Int32, Boolean)
0x0AE  System.Threading.PortableThreadPool+WorkerThread.WorkerThreadStart()
0x000  <Native Transition>

    Thread: .NET ThreadPool Gate

IL     Method
--     ------
0x000  System.Threading.WaitHandle.WaitOneCore(IntPtr, Int32)
0x000  System.Threading.WaitHandle.WaitOneNoCheck(Int32)
0x05D  System.Threading.PortableThreadPool+GateThread.GateThreadStart()
0x000  <Native Transition>

    Thread: .NET Long Running Task

IL     Method
--     ------
0x000  System.Threading.WaitHandle.WaitOneCore(IntPtr, Int32)
0x000  System.Threading.WaitHandle.WaitOneNoCheck(Int32)
0x000  System.Threading.WaitHandle.WaitOne(System.TimeSpan)
0x026  Microsoft.ApplicationInsights.Channel.InMemoryTransmitter.Runner()
0x040  System.Threading.ExecutionContext.RunInternal(System.Threading.ExecutionContext, System.Threading.ContextCallback, System.Object)
0x096  System.Threading.Tasks.Task.ExecuteWithThreadLocal(System.Threading.Tasks.Task ByRef, System.Threading.Thread)
0x000  <Native Transition>

    Thread: DefaultAggregationPeriodCycle

IL     Method
--     ------
0x000  System.Threading.Thread.SleepInternal(Int32)
0x01A  System.Threading.Thread.Sleep(Int32)
0x000  System.Threading.Thread.Sleep(System.TimeSpan)
0x013  Microsoft.ApplicationInsights.Metrics.DefaultAggregationPeriodCycle.Run()
0x040  System.Threading.ExecutionContext.RunInternal(System.Threading.ExecutionContext, System.Threading.ContextCallback, System.Object)
0x000  <Native Transition>

    Thread: IPC Listener Thread

IL     Method
--     ------
0x000  System.Threading.Monitor.ObjWait(Int32, System.Object)
0x106  System.Threading.ManualResetEventSlim.Wait(Int32, System.Threading.CancellationToken)
0x034  System.Threading.Tasks.Task.SpinThenBlockingWait(Int32, System.Threading.CancellationToken)
0x07C  System.Threading.Tasks.Task.InternalWaitCore(Int32, System.Threading.CancellationToken)
0x008  System.Runtime.CompilerServices.TaskAwaiter.HandleNonSuccessAndDebuggerNotification(System.Threading.Tasks.Task)
0x027  System.IO.Pipes.NamedPipeServerStream.WaitForConnection()
0x000  System.Management.Automation.Remoting.RemoteSessionNamedPipeServer.WaitForConnection()
0x077  System.Management.Automation.Remoting.RemoteSessionNamedPipeServer.ProcessListeningThread(System.Object)
0x040  System.Threading.ExecutionContext.RunInternal(System.Threading.ExecutionContext, System.Threading.ContextCallback, System.Object)
0x000  <Native Transition>

    Thread: .NET ThreadPool Worker

IL     Method
--     ------
0x000  Interop+Kernel32.<GetQueuedCompletionStatus>g____PInvoke__|50_0(IntPtr, Int32*, UIntPtr*, IntPtr*, Int32)
0x000  Interop+Kernel32.<GetQueuedCompletionStatus>g____PInvoke__|50_0(IntPtr, Int32*, UIntPtr*, IntPtr*, Int32)
0x000  System.Threading.LowLevelLifoSemaphore.WaitForSignal(Int32)
0x000  System.Threading.LowLevelLifoSemaphore.Wait(Int32, Boolean)
0x0AE  System.Threading.PortableThreadPool+WorkerThread.WorkerThreadStart()
0x000  <Native Transition>

    Thread: Pipeline Execution Thread

IL     Method
--     ------
0x000  System.Threading.WaitHandle.WaitMultipleIgnoringSyncContext(IntPtr*, Int32, Boolean, Int32)
0x000  System.Threading.WaitHandle.WaitMultiple(System.ReadOnlySpan`1<System.Threading.WaitHandle>, Boolean, Int32)
0x000  System.Threading.WaitHandle.WaitAny(System.Threading.WaitHandle[], Int32)
0x012  Microsoft.PowerShell.PSConsoleReadLine.ReadKey()
0x04C  Microsoft.PowerShell.PSConsoleReadLine.InputLoop()
0x0AC  Microsoft.PowerShell.PSConsoleReadLine.ReadLine(System.Management.Automation.Runspaces.Runspace, System.Management.Automation.EngineIntrinsics, System.Threading.CancellationToken,
       System.Nullable`1<Boolean>)
0x000  Microsoft.PowerShell.PSConsoleReadLine.ReadLine(System.Management.Automation.Runspaces.Runspace, System.Management.Automation.EngineIntrinsics, System.Nullable`1<Boolean>)
0x000  DynamicClass.CallSite.Target(System.Runtime.CompilerServices.Closure, System.Runtime.CompilerServices.CallSite, System.Type, System.Object, System.Object, System.Object)
0x136  System.Dynamic.UpdateDelegates.UpdateAndExecute4[[System.__Canon, System.Private.CoreLib],[System.__Canon, System.Private.CoreLib],[System.__Canon,
       System.Private.CoreLib],[System.__Canon, System.Private.CoreLib],[System.__Canon, System.Private.CoreLib]](System.Runtime.CompilerServices.CallSite, System.__Canon, System.__Canon,
       System.__Canon, System.__Canon)
0x000
0x000  System.Management.Automation.Interpreter.DynamicInstruction`5[[System.__Canon, System.Private.CoreLib],[System.__Canon, System.Private.CoreLib],[System.__Canon,
       System.Private.CoreLib],[System.__Canon, System.Private.CoreLib],[System.__Canon, System.Private.CoreLib]].Run(System.Management.Automation.Interpreter.InterpretedFrame)
0x043  System.Management.Automation.Interpreter.EnterTryCatchFinallyInstruction.Run(System.Management.Automation.Interpreter.InterpretedFrame)
0x043  System.Management.Automation.Interpreter.EnterTryCatchFinallyInstruction.Run(System.Management.Automation.Interpreter.InterpretedFrame)
0x015  System.Management.Automation.Interpreter.Interpreter.Run(System.Management.Automation.Interpreter.InterpretedFrame)
0x03E  System.Management.Automation.Interpreter.LightLambda.RunVoid1[[System.__Canon, System.Private.CoreLib]](System.__Canon)
0x240  System.Management.Automation.DlrScriptCommandProcessor.RunClause(System.Action`1<System.Management.Automation.Language.FunctionContext>, System.Object, System.Object)
0x094  System.Management.Automation.DlrScriptCommandProcessor.Complete()
0x055  System.Management.Automation.CommandProcessorBase.DoComplete()
0x03B  System.Management.Automation.Internal.PipelineProcessor.DoCompleteCore(System.Management.Automation.CommandProcessorBase)
0x08D  System.Management.Automation.Internal.PipelineProcessor.SynchronousExecuteEnumerate(System.Object)
0x2C1  System.Management.Automation.Runspaces.LocalPipeline.InvokeHelper()
0x09B  System.Management.Automation.Runspaces.LocalPipeline.InvokeThreadProc()
0x025  System.Management.Automation.Runspaces.LocalPipeline.InvokeThreadProcImpersonate()
0x016  System.Management.Automation.Runspaces.PipelineThread.WorkerProc()
0x040  System.Threading.ExecutionContext.RunInternal(System.Threading.ExecutionContext, System.Threading.ContextCallback, System.Object)
0x000  <Native Transition>

    Thread: PSReadLine ReadKey Thread

IL     Method
--     ------
0x000  <Native Transition>
0x01F  Interop+Kernel32.ReadConsoleInput(IntPtr, InputRecord ByRef, Int32, Int32 ByRef)
0x071  System.ConsolePal.ReadKey(Boolean)
0x000  Microsoft.PowerShell.Internal.VirtualTerminal.ReadKey()
0x0C0  Microsoft.PowerShell.PSConsoleReadLine.ReadOneOrMoreKeys()
0x01D  Microsoft.PowerShell.PSConsoleReadLine.ReadKeyThreadProc()
0x040  System.Threading.ExecutionContext.RunInternal(System.Threading.ExecutionContext, System.Threading.ContextCallback, System.Object)
0x000  <Native Transition>

    Thread: .NET ThreadPool Worker

IL     Method
--     ------
0x000  Interop+Kernel32.<GetQueuedCompletionStatus>g____PInvoke__|50_0(IntPtr, Int32*, UIntPtr*, IntPtr*, Int32)
0x000  Interop+Kernel32.<GetQueuedCompletionStatus>g____PInvoke__|50_0(IntPtr, Int32*, UIntPtr*, IntPtr*, Int32)
0x000  System.Threading.LowLevelLifoSemaphore.WaitForSignal(Int32)
0x000  System.Threading.LowLevelLifoSemaphore.Wait(Int32, Boolean)
0x0AE  System.Threading.PortableThreadPool+WorkerThread.WorkerThreadStart()
0x000  <Native Transition>
```
