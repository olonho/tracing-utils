string gTarget;     /* the name of the target executable */

dtrace:::BEGIN
{
    gTarget = "simpleui";
    gTargetPID = -1;
}

syscall::exec*:return
/ pid == $pid /
{
    // Slow things down a bit.
    //chill(100000000);
}

/*
 * Capture target launch (success)
 */
proc:::exec-success
/ gTarget == execname /
{
    gTargetPID = pid;
    printf("started %s\n", execname);
}

/* Exact syscall name here is not too important, it must be one of few firstr syscall executed */
syscall::workq_kernreturn:entry
/ pid == gTargetPID && traced == 0 /
{
    printf("Will start tracing from %s\n", probefunc);
    traced = 1;
    system("sudo dtrace -qws child-ui-ops.d -p %d", pid);
}

syscall::*exit:entry
/ pid == gTargetPID /
{
    gTargetPID = -1;        /* invalidate target pid */
}

/*
// Demo of how we could track syscalls in children, if needed.
syscall::open*:entry
/ ((pid == gTargetPID) || progenyof(gTargetPID)) /
{
    self->arg0 = arg0;
    self->arg1 = arg1;
}

syscall::open*:return
/ ((pid == gTargetPID) || progenyof(gTargetPID)) /
{
    this->op_kind = ((self->arg1 & O_ACCMODE) == O_RDONLY) ? "READ" : "WRITE";
    this->path0 = self->arg0 ? copyinstr(self->arg0) : "<nil>";

    //printf("open for %s: <%s> #%d\n", this->op_kind, this->path0, arg0);
}
*/
