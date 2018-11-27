#!/usr/bin/env python
# -*- coding: utf-8 -*-

import sys

sys.path.insert(0, '../DTO')
sys.path.insert(0, '../Models')
sys.path.insert(0, '../Services')

from HTTPService import HTTPType
from HTTPService import StatusCode
from HTTPService import HTTP
from Error import Error
from MainController import Controller
from MainController import Resource
from RegisterEventRequest import RegisterEventRequest
from Event import Event

class EventController(Controller):
	def __init__(self, server, path):
		super(EventController, self).__init__(server,path)
		self.resources.append(Resource("register",HTTPType.POST))
		self.resources.append(Resource("all",HTTPType.GET))

	def handle(self,request):
		for resource in self.resources:
			if request.url.resource==resource.name and request.type==resource.type:
				if resource.name=="register":
					return self.register(request)
				elif resource.name=="all":
					return self.getAll(request)
				
		error=Error(str(404),{"pointer": request.url.path+'/'+request.url.resource},"Not found","Resource not implemented on backend.")
		return HTTP(status=StatusCode.C500,data=Error.listToJson([error]),contenttype="application/json")

	def register(self,request):
		event=RegisterEventRequest.fromJson(request.data)
		if self.sql.checkIfNCExists(event.owner_id):
			pass
		else:
			error=Error(str(404),{"pointer": request.url.path+'/'+request.url.resource},"Not found","Account not found on databse.")
			return HTTP(status=StatusCode.C404,data=Error.listToJson([error]),contenttype="application/json")

	def getAll(self,request):
		events=self.sql.getEvents()
		return HTTP(status=StatusCode.OK,data=Event.listToJson(events),contenttype="application/json")