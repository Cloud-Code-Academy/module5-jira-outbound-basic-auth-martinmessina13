HttpRequest request = new HttpRequest();
request.setEndpoint('callout:JiraAPI/issue/createmeta');
request.setMethod('GET');
Http http = new Http();
HttpResponse response = http.send(request);
System.debug('response body: ' + response.getBody());