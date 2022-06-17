using System.Management.Automation;
using Microsoft.Diagnostics.Runtime;

namespace GetClrCallStack;

[Cmdlet(VerbsCommon.Get, "ClrCallStack")]
public sealed class GetClrCallStackCommand : PSCmdlet
{
    private const string UnnamedThreadName = "<Unnamed Thread>";

    private const string UnmanagedMethodName = "<Native Transition>";

    private const string UnknownMethodName = "<Unknown>";

    [Parameter(ValueFromPipelineByPropertyName = true, Mandatory = true, Position = 0)]
    [ValidateRange(0, int.MaxValue)]
    public int Id { get; set; }

    protected override void ProcessRecord()
    {
        using DataTarget dataTarget = DataTarget.AttachToProcess(Id, suspend: true);
        using ClrRuntime runtime = dataTarget.ClrVersions[0].CreateRuntime();

        Dictionary<int, string> threadNames = new();
        string? nameFieldName = null;
        string? managedIdFieldName = null;
        foreach (ClrObject obj in runtime.Heap.EnumerateObjects())
        {
            if (obj.Type?.Name is "System.Threading.Thread")
            {
                if (nameFieldName is null || managedIdFieldName is null)
                {
                    if (obj.Type?.GetFieldByName("_name") is null)
                    {
                        nameFieldName = "m_Name";
                        managedIdFieldName = "m_ManagedThreadId";
                    }
                    else
                    {
                        nameFieldName = "_name";
                        managedIdFieldName = "_managedThreadId";
                    }
                }

                threadNames.Add(
                    obj.ReadField<int>(managedIdFieldName),
                    obj.ReadStringField(nameFieldName) ?? UnnamedThreadName);
            }
        }

        ClrStackFrameInfo? pendingUnnamed = null;
        bool hasWrittenNamed = false;
        foreach (ClrThread thread in runtime.Threads)
        {
            if (pendingUnnamed is not null && hasWrittenNamed)
            {
                WriteObject(pendingUnnamed, enumerateCollection: false);
            }

            pendingUnnamed = null;
            hasWrittenNamed = false;
            string threadName = threadNames.TryGetValue(thread.ManagedThreadId, out string name)
                ? name
                : UnnamedThreadName;

            int threadId = thread.ManagedThreadId;

            foreach (ClrStackFrame frame in thread.EnumerateStackTrace(includeContext: false))
            {
                string frameName = frame.FrameName ?? string.Empty;
                string? methodName = frame.Method?.ToString();
                string defaultName = frame.Kind switch
                {
                    ClrStackFrameKind.Runtime => UnmanagedMethodName,
                    ClrStackFrameKind.Unknown => UnknownMethodName,
                    _ => string.Empty,
                };

                int ilOffset = frame.Method?.GetILOffset(frame.InstructionPointer) ?? 0;
                if (methodName is null or "")
                {
                    pendingUnnamed = new ClrStackFrameInfo(
                        threadName,
                        threadId,
                        methodName ?? defaultName,
                        ilOffset,
                        frameName);

                    continue;
                }

                if (pendingUnnamed is not null)
                {
                    WriteObject(pendingUnnamed, enumerateCollection: false);
                    pendingUnnamed = null;
                }

                hasWrittenNamed = true;
                WriteObject(
                    new ClrStackFrameInfo(
                        threadName,
                        threadId,
                        methodName,
                        ilOffset,
                        frameName),
                    enumerateCollection: false);
            }
        }
    }
}
