/* 
 * This DTrace script just traces all Objective-C methods in target,
 * can be very heavy in perf, so use with care. Better provide more
 * specific probes after initial analysis.
 */
unsigned long long indention;

objc$target:_UI*::entry
{
    method = (string)&probefunc[1];
    type = probefunc[0];
    class = probemod;
    printf("%*s%s %c[%s %s]\n", indention, "", "->", type, class, method);
    indention++;
}

objc$target:_UI*::return
{
    indention--;
    method = (string)&probefunc[1];
    type = probefunc[0];
    class = probemod;
    printf("%*s%s %c[%s %s]\n", indention, "", "<-", type, class, method);
}