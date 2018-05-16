Introduction
====

The project is going to build the docker image that installed the jasperserver-ce 6.x.

Revamp
------

After a lot if studies, the jasper-server is not easy to install thru WAR and startalone script.


Installation
----

1. Download the latest version of [JasperServer Community Edition](https://community.jaspersoft.com/) to your local computer;

2. Unzip the downloaded file to resources folder. Then rename the first level folder to "jasperreports-server-cp-bin";

3. Open the terminal and point to the repositiory folder;

4. Build the image by using the following commands:

      docker build -t jasperserver-ce:latest -t jasperserver-ce:6 .

5. The image should be builded successfully and tagged as "jasperserver-ce:latest" and "jasperserver-ce:6";

