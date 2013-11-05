## Introduction

The Contacts API is a read-only REST API to get contact information to employees and to group contacts in the City of Malmö. It is a server-to-server API is authenticated and is only accepting requests from registered applications. The information can only be used in applications goverened by the City of Malmö.

## Registration
Before you can use the API, you need to contact kominteamet@malmo.se to discuss the purpose of the usage of the data and the estimated traffic. Provide the IP-address for your test and production servers, the systems common name and the email address to the system manager ("systemförvaltaren").

## Authentication
You will get an `app_token` and an `app_secret` when you register the consuming application. Those parameters must be passed with each request. The consuming applications IP address, on the server's or a development machine, is also used along with the authentication parameters. Contact kominteamet@malmo.se if you need to change the IP address.


## Caching
You are responsible for caching requests in the consuming application. The caching policy depends on the traffic the application will create and the need for fresh data. Please contact kominteamet@malmo.se to discuss a appropriate policy.

## Exception Handling
You must handle exceptions in the consuming application for responses. This includes both HTTP response codes as well as timeouts from the API server.

A request for a contact that has been removed will return:
```
HTTP/1.1 404 Not Found
```
```json
{
  "message": "404 Not Found"
}
```

Authentication failures will return:
```
HTTP/1.1 401 Unauthorized
```
```json
{
  "message": "401 Unauthorized. Your app_token, app_secret or ip address is not correct"
}
```

## Resources
All API access is over HTTPS and accessed from the base address:

```
GET https://webapps06.malmo.se/dashboard
```

All data is received as JSON.

### Search employees
Case insensitive search for `first_name`, `last_name`, `first_name last_name` or `email`. `q` matches start of one of the fields.

Example:
```
GET /api/v1/employees/search?q=jes
```

Response:
```
HTTP/1.1 200 OK
```
```json
[
  {
    "catalog_id": "jesbyl",
    "id": 111,
    "first_name": "Jesper",
    "last_name": "Bylund",
    "title": "Enhetschef",
    "email": "jesper.bylund@malmo.se",
    "company": "102 Stadskontoret",
    "department": "Kommunikationsavdelningen"
  },
  {
    "catalog_id": "asajes",
    "id": 50,
    "first_name": "\u00c5sa",
    "last_name": "Jespersson",
    "title": "Processchef",
    "email": "asa.jespersson@malmo.se",
    "company": "040 Fritidsf\u00f6rvaltningen",
    "department": null
  },
  ...
]
```

### Get a Single Employee
Get the record for a single employee by the unique `:id` or the `:catalog_id` that is an unique identifier within the organization's systems.

```
GET /api/v1/employees/:id
GET /api/v1/employees/:catalog_id
```

Examples:
```
GET /api/v1/employees/111
GET /api/v1/employees/jesbyl
```

Response:
```
HTTP/1.1 200 OK
```
```json
{
  "catalog_id": "jesbyl",
  "id": 111,
  "first_name": "Jesper",
  "last_name": "Bylund",
  "title": "Enhetschef",
  "email": "jesper.bylund@malmo.se",
  "phone": "040-342091",
  "cell_phone": null,
  "company": "102 Stadskontoret",
  "department": "Kommunikationsavdelningen",
  "address": "August Palms plats 1",
  "room": "6069",
  "roles": [
    "Stadskontoret",
    "Kommunikationsarbete"
  ],
  "skills": [
    "responsiv design",
    "webb",
    "webbutveckling",
    "malmo.se",
    "v\u00e5rt malm\u00f6",
    "personalavin",
    "Intran\u00e4t",
    "Komin",
    "CSS3",
    "media queries",
    "HTML5",
    "web full-stack management"
  ],
  "languages": [
    "svenska",
    "engelska"
  ],
  "created_at": "2012-05-02T11:44:16+02:00",
  "updated_at": "2013-10-30T10:47:36+01:00"
}
```


### Profile Pictures for Employees
To get a profile pictures for an employee, use the employee's `:catalog_id` as documented in the [Avatar Service](Avatar-Service) API.


### Search Group Contacts
Case insensitive search for `name`. The `q` value matches the start of one of the field.

Example:
```
GET /api/v1/group_contacts/search?q=Individ-%20&%20familjeomsorgen
```

Response:
```
HTTP/1.1 200 OK
```
```json
[
  {
    "id": 16,
    "name": "Individ- & familjeomsorgen Centrum"
  },
  {
    "id": 23,
    "name": "Individ- & familjeomsorgen Roseng\u00e5rd"
  },
  ...
]
```


### Get a Single Contact
Get the record for a single contact by the unique `:id`.

```
GET /api/v1/group_contacts/:id
```

Example:
```
GET /api/v1/group_contacts/23
```

Response:
```
HTTP/1.1 200 OK
```
```json
{
  "id": 23,
  "name": "Individ- & familjeomsorgen Roseng\u00e5rd",
  "email": "iofrosengard@malmo.se",
  "phone": "040-34 33 69",
  "phone_hours": "M\u00e5n\u2013Tor: 08.00\u201316.00, lunchst\u00e4ngt 11.45\u201313.00. Fre 08.00\u201315.00 Lunchst\u00e4ngt 11.45\u201313.00",
  "cell_phone": "",
  "fax": "",
  "address": "",
  "zip_code": "",
  "postal_town": "",
  "visitors_address": "von Troils v\u00e4g 8A",
  "visitors_address_zip_code": "213 73",
  "visitors_address_postal_town": "Malm\u00f6",
  "visitors_district": "\u00d6ster",
  "visitors_address_geo_position_x": "121638",
  "visitors_address_geo_position_y": "6162531",
  "visiting_hours": "M\u00e5n\u2013Tor 08.30\u201315.30, lunchst\u00e4ngt 11.45\u201313.00, Fre 08.30\u201315.00, lunchst\u00e4ngt 11.45\u201313.00",
  "homepage": "",
  "created_at": "2013-11-01T15:41:52+01:00",
  "updated_at": "2013-11-05T13:59:56+01:00",
  "legacy_dn": "cn=Individ- & familjeomsorgen Roseng\u00e5rd, ou=Funktionskonton, ou=Organisation och funktion, ou=Sitevision, o=malmo"
}
```
