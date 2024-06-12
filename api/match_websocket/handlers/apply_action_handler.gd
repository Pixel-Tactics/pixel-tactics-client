extends Node

signal move_accepted
signal attack_accepted

func handle_incoming(message: Dictionary):
	if message.body["actionName"] == "move":
		emit_signal("move_accepted", message.body["actionSpecific"])
	elif message.body["actionName"] == "attack":
		print("SENDINGHIM")
		emit_signal("attack_accepted", message.body["actionSpecific"])
