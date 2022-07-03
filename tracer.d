string gTarget;     /* the name of the target executable */

dtrace:::BEGIN
{
    gTarget = "simpleui";
    gTargetPID = -1;
}

/*
 * Capture target launch (success)
 */
proc:::exec-success
/ gTarget == execname /
{
    gTargetPID = pid;
    printf("started %s\n", execname);
    system("sudo dtrace -qws child-ui.d -p %d", pid);
}


syscall::*exit:entry
/ pid == gTargetPID /
{
    gTargetPID = -1;        /* invalidate target pid */
}

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

