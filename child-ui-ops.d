dtrace:::BEGIN
{
    self->tracing = 0;
    self->indent = 0;
}

objc$target::*commit*:entry
{
    self->tracing++;
}

objc$target::*commit*:return
{
    self->tracing--;
    if (self->tracing == 0) {
        self->indent--;
        printf("%*s%s [%s - %s]\n", self->indent, "", "<-", probemod, probefunc);
    }
}


objc$target:*CA*::entry
/ self->tracing != 0/
{
    self->indent++;
    printf("%*s%s [%s - %s]\n", self->indent, "", "->", probemod, probefunc);

}

objc$target:*CA*::return
/ self->tracing != 0/
{
    printf("%*s%s [%s - %s]\n", self->indent, "", "<-", probemod, probefunc);
    self->indent--;
}

objc$target:*NS*::entry
/ self->tracing != 0/
{
    self->indent++;
    printf("%*s%s [%s - %s]\n", self->indent, "", "->", probemod, probefunc);
}

objc$target:*NS*::return
/ self->tracing != 0/
{
    printf("%*s%s [%s - %s]\n", self->indent, "", "<-", probemod, probefunc);
    self->indent--;
}

objc$target:*CF*::entry
/ self->tracing != 0/
{
    self->indent++;
    printf("%*s%s [%s - %s]\n", self->indent, "", "->", probemod, probefunc);
}

objc$target:*CF*::return
/ self->tracing != 0/
{
    printf("%*s%s [%s - %s]\n", self->indent, "", "<-", probemod, probefunc);
    self->indent--;
}

objc$target:*Cocoa*::entry
/ self->tracing != 0/
{
    self->indent++;
    printf("%*s%s [%s - %s]\n", self->indent, "", "->", probemod, probefunc);
}

objc$target:*Cocoa*::return
/ self->tracing != 0/
{
    printf("%*s%s [%s - %s]\n", self->indent, "", "<-", probemod, probefunc);
    self->indent--;
}


syscall:::entry
/ self->tracing != 0/
{
    printf("%*s%s\n", self->indent, "", probefunc);
}