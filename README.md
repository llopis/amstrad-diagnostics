# amstrad-diagnostics
Diagnostic Tests for the Amstrad CPC

Right now it does three things:
* Quick check to identify ROMs on the Amstrad CPC. Only looks for lower ROM and ROMs in range 0-15. Only has a few ROMs that it identifies.
* Upper RAM test (64K).
* Detect CRTC model.

![image](/images/screenshot.png)

# TODO
* Integrate with lower RAM test.
* Create binary to load as lower ROM.
* Detect Plus range.
* Different IC numbers if detecting CRTC 4?

# Credits

Project created and maintained by Noel Llopis. Some code by other contributors: Brendan Alford, Gérald Vincent, Kevin Thacker, Rhino.