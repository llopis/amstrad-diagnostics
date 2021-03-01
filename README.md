# amstrad-diagnostics
Diagnostic Tests for the Amstrad CPC

This test is intended to be run from the low ROM of the Amstrad CPC at startup. It performs the following tests:
* Lower 64KB RAM test.
* Upper 64KB RAM test.
* [Dandanator build only] Check the low system ROM is valid.
* Check that upper system ROMs are valid.
* Detect CRTC model.

![image](/images/TestSuccessful.png)

When the test is first launched, it starts by verifying that the lower 64KB of RAM are working correctly. If any faults are detected, the test stops with a screen like this. The numbers indicate the data bits, and the ones in red are faulty and the ones in green are working correctly. A faulty bit indicates a faulty IC.
![image](/images/LowerRAMFailure.png)

Then, if it detects the upper 64KB of RAM, it runs some tests to verify that memory is working correctly. Otherwise, it shows the error and points to the faulty ICs (on a CPC 6218).
![image](/images/UpperRAMFailure.png)

Finally it does some checks on the system ROMs to make sure they match known ROMs and they're not corrupted. It also detects the CRTC type.

# Support and Development
Come join the Discord server https://discord.gg/ETcCh6J﻿ and look for the amstrad-diagnostics channel.


# Credits

Project created and maintained by Noel Llopis. Many people contributed code and ideas to this project: Brendan Alford, Gérald Vincent, Kevin Thacker, Rhino, KaosOverride, Spirax.