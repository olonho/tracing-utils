dtrace:::BEGIN
{
    self->tracing = 0;
    self->indent = 0;
}

objc$target:*CALayer*:-_display*:entry
{
    self->tracing++;
}

objc$target:*CALayer*:-_display*:return
{
    self->tracing--;
    if (self->tracing == 0) {
        self->indent--;
         method = (string)&probefunc[1];
        type = probefunc[0];
        printf("%*s%s %c[%s %s]\n", self->indent, "", "<-", type, probemod, method);
    }
}

objc$target:NS*::entry
/ self->tracing != 0/
{
    method = (string)&probefunc[1];
    type = probefunc[0];
    printf("%*s%s %c[%s %s]\n", self->indent, "", "->", type, probemod, method);
    self->indent++;
}

objc$target:NS*::return
/ self->tracing != 0/
{
    self->indent--;
    method = (string)&probefunc[1];
    type = probefunc[0];
    printf("%*s%s %c[%s %s]\n", self->indent, "", "<-", type, probemod, method);
}

objc$target:CA*::entry
/ self->tracing != 0/
{
    method = (string)&probefunc[1];
    type = probefunc[0];
    printf("%*s%s %c[%s %s]\n", self->indent, "", "->", type, probemod, method);
    self->indent++;
}

objc$target:CA*::return
/ self->tracing != 0/
{   
    method = (string)&probefunc[1];
    type = probefunc[0];
    self->indent--;
    printf("%*s%s %c[%s %s]\n", self->indent, "", "<-", type, probemod, method);
}

objc$target:CF*::entry
/ self->tracing != 0/
{
    method = (string)&probefunc[1];
    type = probefunc[0];
    printf("%*s%s %c[%s %s]\n", self->indent, "", "->", type, probemod, method);
    self->indent++;
}

objc$target:CF*::return
/ self->tracing != 0/
{
    method = (string)&probefunc[1];
    type = probefunc[0];
    self->indent--;
    printf("%*s%s %c[%s %s]\n", self->indent, "", "<-", type, probemod, method);
}

objc$target:*UI*::entry
/ self->tracing != 0/
{
    method = (string)&probefunc[1];
    type = probefunc[0];
    printf("%*s%s %c[%s %s]\n", self->indent, "", "->", type, probemod, method);
    self->indent++;
}

objc$target:*UI*::return
/ self->tracing != 0/
{
    method = (string)&probefunc[1];
    type = probefunc[0];
    self->indent--;
    printf("%*s%s %c[%s %s]\n", self->indent, "", "<-", type, probemod, method);
}


syscall:::entry
/ self->tracing != 0/
{
    printf("SYSCALL %*s%s\n", self->indent, "", probefunc);
}