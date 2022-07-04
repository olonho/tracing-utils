syscall:::entry
/ pid == $target /
{
    if (probefunc == "open" || probefunc == "open_nocancel" || 
        probefunc == "access" || probefunc == "stat64") {
        printf("%s %s\n", probefunc, copyinstr(arg0));
    } else if (probefunc == "openat") {
        printf("%s %s\n", probefunc, copyinstr(arg1));
    } else {
        printf("%s\n", probefunc);
    }
}
