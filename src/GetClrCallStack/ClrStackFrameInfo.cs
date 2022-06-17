namespace GetClrCallStack;

public sealed record ClrStackFrameInfo(
    string ThreadName,
    int ManagedThreadId,
    string Method,
    int ILOffset,
    string FrameName);
