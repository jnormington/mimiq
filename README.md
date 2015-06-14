##Mimiq

As a QA Tester I am always testing with third party integration services such as;
 - postcode services
 - analytic services
 - sms sending/receiving services
 - file/bucket storage mechanisms

The problem is not all web applications rescue the common scenarios adequately or another 
layer in the application/webserver expires before hand - this app allows you to **mimic** these scenarios.

This application trys to build certain path scenarios to test on applications that have 
third party integrations - for which you can point your configuration url to this one for the AUT 
(Application under Test) - as we can't ask third party services to provide these for testing


It tries to provide the following;

 - timeout (configurable by param)
 - 404'ing (although easily replicatable with external service)
 - 500'ing
 - GET request - with different configurable responses
 - POST request - with different configurable responses

### What is a configurable response

 You can configure a response with the following attributes 
  - **request_by** - this makes the response unique by requesting this specific url
  - **response_type** (this allows the following responses)
  	- generic 404/500 (doesn't use content - just put hypen `-` in the content)
  	- 422 Unprocessable (possible to replicate with API - but still good to test)
  	- 200 (XML or JSON response - the content isn't validated in any way)
  - **wait time** (this is the time it waits before responding - good for testing timeouts with analytics)
  - **request_type** (this is whether you are posting or doing a GET request for the response)
  - **content** (this is the content returned)

###Example
 - When a response for *GET request* with the request_by set to *test* - then you can hit the application with the below url `http://localhost:3000/scenario/get/test` you get the content in the response, as below is shown.

```sh
$ curl -D- http://localhost/scenario/get/test; echo

HTTP/1.1 200 OK
X-Frame-Options: SAMEORIGIN
X-Xss-Protection: 1; mode=block
X-Content-Type-Options: nosniff
Content-Type: application/json; charset=utf-8
Etag: W/"195bc37dd38929786ad8ba5d0aea71d3"
Cache-Control: max-age=0, private, must-revalidate
X-Request-Id: 4e080c83-e112-44c1-99f2-19ee86c2cd26
X-Runtime: 0.004928
Server: WEBrick/1.3.1 (Ruby/2.2.2/2015-04-13)
Date: Sun, 14 Jun 2015 18:20:16 GMT
Content-Length: 14
Connection: Keep-Alive

{blank: 'yes'}  <--- RESPONSE HERE
 
```

- When a response for *POST request* with the request_by set to a postcode *AA11CU* - then you can hit the application with the below url with a post request `http://localhost:3000/scenario/post/test` and you get the content in the response, as below is shown.

As shown below the application doesn't care what is posted to the server be nothing to something it just responds based on your custom response you have built.

```sh
$ wget --post-data='' http://localhost:3000/scenario/post/AA11CU -O- -v

--2015-06-14 19:51:12--  http://localhost:3000/scenario/post/AA11CU
Resolving localhost... ::1, 127.0.0.1
Connecting to localhost|::1|:3000... connected.
HTTP request sent, awaiting response... 302 Found
Location: http://localhost:3000/scenario/get/AA11CU?response_id=4 [following]
--2015-06-14 19:51:12--  http://localhost:3000/scenario/get/AA11CU?response_id=4
Reusing existing connection to [localhost]:3000.
HTTP request sent, awaiting response... 200 OK
Length: 144 [application/xml]
Saving to: 'STDOUT'

<-- RESPONSE BELOW THIS LINE -->

<xml>
  <postcodes>
    <postcode>
      <borough>nowhere</borough>
      <address>1 sadroad</road>
    <postcode>
  </postcodes>
</xml>
```



###Who is it for

 Anyone that has to test these integrations. It will be most useful for QA Testers that 
 need to test 
  - how the user is treated under certain scenarios 
  - how the application handles delayed responses - which this app can help **mimic**
  - testing scrapers for external parties that send files for validation

###Whats it included
  - Basic rails web application
  - Ansible script for basic web server setup and deployment to digital ocean
