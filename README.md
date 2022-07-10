# Useful DTrace scripts

Based on StackOverflow crawling, thanks to all people who posted
answers.

Run startup tracker as as
```console
sudo dtrace -qws tracer.d
```

Run render tracker as
```console
sudo dtrace -qws tracer-running.d -p `pgrep simpleui`
```

Refer rather interesting [paper](https://papers.put.as/papers/macosx/2009/Debugging-Cocoa-with-DTrace.pdf) on related matter.

Note that SIP must be disabled for DTrace to work.