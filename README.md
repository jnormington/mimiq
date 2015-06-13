##Mimiq

As a QA Tester I am always testing with third party integration services such as;
 - postcode services
 - analytic services
 - sms sending/receiving services
 - file/bucket storage mechanisms

The problem is not all web applications rescue the common scenarios adequately or another
layer in the application expires else where - this app allows you to mimic these scenarios
by altering the configuration of the application under test to point to this web application

Generally playing with the firewall, denying outgoing connections as well as altering
code directly on the server to watch the outcome worked well - but I have recently found this
not to be a great way so this trys to make it a little easier.


###What does it do

This application trys to build certain path scenarios to test on applications that have
third party integrations - for which you can alter the configuration url for the AUT
(Application under Test) - as we can't ask third party services to provide these for testing.

It tries to provide the following;

 - timeout (configurable by param)
 - returning (custom|generic) json/xml
 - 404'ing
 - 500'ing
 - GET request - with different configurable responses
 - POST request - with different configurable responses


###Who is it for

 Anyone that has to test these integrations. It will be most useful for QA Testers that
 need to test how the user journey is handled and if any delays exist for the user with timeouts -
 which this app tries to mimic - just by pointing your web application configuration url to your new build.

###What it includes

  - Basic rails web application
  - Ansible script for basic web server setup and deployment to digital ocean
