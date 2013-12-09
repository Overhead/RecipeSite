---
layout: post
title:  "Search algo and API"
---

##Search Algorithm
Today we managed to fix the problem with showing results from our own DB as well as showing
results from the API. Now users can search for ingredients or recipe names, and get
results that come from our database and from the API.

##Pagination
When the search results where completed it was very fast to set up an easy API.
When requesting for http://xxx/api/list?search_string= or http://xxx/api/find/:id the users
will get a JSON returned to them with all data found in our database and from API.
The API will only return 12 results at the time so in the future this can be improved by start and stop.
The user can however decide where he wants to start, by using a new_page=12/24/36 parameter in the api-list 