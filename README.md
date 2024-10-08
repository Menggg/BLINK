BLINK: A Package for Next Level of Genome-Wide Association Studies with Both Individuals and Markers in Millions
----

Inspired by our recently developed FarmCPU method, we continue our practice on modeling and software engineering. One of the outcomes is BLINK written in C by Meng Huang. Both real and simulated data analyses demonstrated that BLINK improves statistical power further and deliver a remarkable computing speed. Now, a dataset with half million markers and half million individuals can be analyzed within an hour, compared with days by using FarmCPU. Questions and comments can be made at BLINK forum (https://groups.google.com/forum/#!forum/blink). The executable program of BLINK, help documents, demonstration data, and tutorials are freely available here.

The latest executable file of BLINK beta version can always be found at https://github.com/Oliver-111/blink

You can find the R version here: https://github.com/YaoZhou89/BLINK

Publication and citation can be found here: https://academic.oup.com/gigascience/article/8/2/giy154/5238723

The license notice
----
This program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.

This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License for more details.

OpenCL package instalation on Linux (For parallel computing)
----
OpenCL package isn't pre-installed on most Linux OS. Please DONOT download and install AMDSDK-3.0 installation package, we recommend AMDAPPSDK-2.8 from https://community.amd.com/thread/230764.
Unzip this folder and use Install-AMD-APP.sh to install OpenCL. After successfully installed OpenCL, please put BLINK execuatble file and four kernel files into same folder.

If you just want to use single thread computing function of BLINK, please just download single thread version (blink_linux) and use it without any environment setting.

Sometimes, you may need to give the root right to BLINK executable file using command
```
chmod 777 blink_linux
```
