extends Node

signal success_received

func handle_incoming(message: Dictionary):
	emit_signal("success_received", message.body.session)
