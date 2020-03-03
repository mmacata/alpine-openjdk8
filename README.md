### openjdk8 Package for alpine

to be able to use version openjdk8-8.232.09-r0 because openjdk8-8.242 breaks snappy installation (see below).

https://gitlab.alpinelinux.org/alpine/aports/blob/04ec13ca9caa9a436001be92e674f230b9894894/community/openjdk8


__Log output with openjdk8-8.242:__
```
/ # /usr/local/snap/bin/snappy-conf /usr/bin/python3
/usr/local/snap/bin/../platform/lib/nbexec: WARNING: environment variable DISPLAY is not set
Configuring SNAP-Python interface...
java.lang.ExceptionInInitializerError
	at java.lang.management.ManagementFactory.getOperatingSystemMXBean(ManagementFactory.java:374)
	at org.esa.snap.python.PyBridge.getTotalPhysicalMemory(PyBridge.java:259)
	at org.esa.snap.python.PyBridge.getDefaultJvmHeapSpace(PyBridge.java:247)
	at org.esa.snap.python.PyBridge.configureJpy(PyBridge.java:203)
	at org.esa.snap.python.PyBridge.installPythonModule(PyBridge.java:149)
	at org.esa.snap.rcp.cli.SnapArgsProcessor.processPython(SnapArgsProcessor.java:103)
	at org.esa.snap.rcp.cli.SnapArgsProcessor.process(SnapArgsProcessor.java:49)
	at org.netbeans.modules.sendopts.DefaultProcessor.process(DefaultProcessor.java:202)
	at org.netbeans.spi.sendopts.Option$1.process(Option.java:387)
	at org.netbeans.api.sendopts.CommandLine.process(CommandLine.java:317)
	at org.netbeans.modules.sendopts.HandlerImpl.execute(HandlerImpl.java:62)
	at org.netbeans.modules.sendopts.Handler.cli(Handler.java:69)
	at org.netbeans.CLIHandler.notifyHandlers(CLIHandler.java:234)
	at org.netbeans.core.startup.CLICoreBridge.cli(CLICoreBridge.java:82)
	at org.netbeans.CLIHandler.notifyHandlers(CLIHandler.java:234)
	at org.netbeans.CLIHandler$1.exec(CLIHandler.java:268)
	at org.netbeans.CLIHandler.finishInitialization(CLIHandler.java:447)
	at org.netbeans.MainImpl.finishInitialization(MainImpl.java:256)
	at org.netbeans.Main.finishInitialization(Main.java:92)
	at org.netbeans.core.startup.Main.start(Main.java:316)
	at org.netbeans.core.startup.TopThreadGroup.run(TopThreadGroup.java:123)
	at java.lang.Thread.run(Thread.java:748)
Caused by: java.lang.NullPointerException
	at java.lang.ClassLoader.loadLibrary(ClassLoader.java:1847)
	at java.lang.Runtime.loadLibrary0(Runtime.java:871)
	at java.lang.System.loadLibrary(System.java:1124)
	at sun.management.ManagementFactoryHelper$4.run(ManagementFactoryHelper.java:451)
	at sun.management.ManagementFactoryHelper$4.run(ManagementFactoryHelper.java:449)
	at java.security.AccessController.doPrivileged(Native Method)
	at sun.management.ManagementFactoryHelper.<clinit>(ManagementFactoryHelper.java:448)
	... 22 more
Python configuration internal error: null
/ # java -version
openjdk version "1.8.0_242"
OpenJDK Runtime Environment (IcedTea 3.15.0) (Alpine 8.242.08-r0)
OpenJDK 64-Bit Server VM (build 25.242-b08, mixed mode)
```

__Log output with openjdk8-8.232:__
```
/ # /usr/local/snap/bin/snappy-conf /usr/bin/python3
/usr/local/snap/bin/../platform/lib/nbexec: WARNING: environment variable DISPLAY is not set
Configuring SNAP-Python interface...
Done. The SNAP-Python interface is located in '/root/.snap/snap-python/snappy'
When using SNAP from Python, either do: sys.path.append('/root/.snap/snap-python')
or copy the 'snappy' module into your Python's 'site-packages' directory.
/ # java -version
openjdk version "1.8.0_232"
OpenJDK Runtime Environment (IcedTea 3.14.0) (Alpine 8.232.09-r0)
OpenJDK 64-Bit Server VM (build 25.232-b09, mixed mode)
```
