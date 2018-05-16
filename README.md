Introduction
====

The project is going to build the docker image that installed the jasperserver-ce 7.x.

Supporting Version
----

The existing building script was tested on JasperServer Community Edition v7.1.0. 

Installation
----

1. Download the latest Linux installer version of [JasperServer Community Edition](https://community.jaspersoft.com/) to your local computer; 

2. Move the downloaded version to resources folder. Then rename it as "TIB_js-jrs-cp_7.1.0_linux_x86_64.run";

3. Open the terminal and point to the repositiory folder;

4. Build the image by using the following commands:

      docker build -t jasperserver-ce:latest -t jasperserver-ce:7  .

5. The image should be builded successfully and tagged as "jasperserver-ce:latest" and "jasperserver-ce:7";

Installer Arguments
----

The installer arguments used during installation can be refer to scripts/TIB_js-jrs-cp_7.1.0_linux_x86_64.run.arguments.README.
