extends Node

signal action_accepted

func handle_incoming(message: Dictionary):
	var action = message.body["actionSpecific"]
	action["name"] = message.body["actionName"]
	self.action_accepted.emit(action)
