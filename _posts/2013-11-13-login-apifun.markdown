---
layout: post
title:  "Starting with login and api calls"
---

Today we started looking on how users shall authenticate to our site, 
and we started looking on how we would use different API's to get recipies.

## Login authentication
For the login part we looked on something called Omniauth for Ruby on Rails, 
which give us the oppertunity for logging in with Twitter, Facebook and Google accounts. 
While working we noticed that the facebook login required that we had our own domain, 
so for our app we will in the beginning only use Google login, 
and later look on how we can implement our own login.

## Yummly API
For the food recipe API we registered at developer.yummly.com in order to get access to their API. 
Here we have to possibility for many different search criterias and we will in the beginnning
only use this API for our site. 

## Todays result
After many hours of working we got some Google login to work, and we were able to get a 
dynamic first page for searching in the Yummly API. 
