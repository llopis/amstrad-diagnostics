# amstrad-diagnostics
Diagnostic Tests for the Amstrad CPC

Right now it does two things:
Quick check to identify ROMs on the Amstrad CPC. Only looks for lower ROM and ROMs in range 0-15. Only has a few ROMs that it identifies.
Upper RAM test (64K).

Right now it assumes the system started up fine and uses the firmware functions. It needs to be extended to be independent of that and run from ROM. It also needs to incorporate an initial lower RAM test.


![image](/images/screenshot.png)
