## Introduction

The Contacts API v1 you REST API with JSON as the respons format

employee and group contacts

It is a server-to-server API and it is only accepting requests from registered consumers. The API is authenticated and all requests and responses are using the https protocol.

.



## Registration
Before you can use the API, you need to contact kominteamet@malmo.se to discuss the purpose of the usage of the data and the estimated traffic. Provide the IP-address for your test and production servers, the systems common name and the email address to the system manager ("systemförvaltare").

## Restrictions

### Caching

## Authentication


## Exception handling


## Resources

~~~
GET /api/v1/employees/search?term=jesbyl
~~~

~~~
GET /api/v1/employees/:username
~~~

~~~
GET /api/v1/employees/:id
~~~

~~~
GET /api/v1/group_contacts/search?q=gr
~~~

~~~
GET /api/v1/group_contacts/:id
~~~

## Profile Pictures for Employees
To get a profile pictures for an employee, use the employees `:username` as documented in the [Avatar Service](Avatar-Service) API.


