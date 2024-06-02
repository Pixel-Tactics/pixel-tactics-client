extends Node

signal success_received

func handle_incoming(message: Dictionary):
	print(message)
	emit_signal("success_received", message["body"]["session"]["id"])
