#!/usr/bin/env python
# -*- coding: utf-8 -*-

import json

class MusicGenre(object):
	def __init__(self, id:int, name:str):
		self.id=id
		self.name=name

	@staticmethod
	def toJson(musicgenre):
		return json.dumps(musicgenre.__dict__)

	@staticmethod
	def fromJson(json):
		return json.loads(json, object_hook=lambda d: MusicGenre(**d))
