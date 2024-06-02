extends Control

signal submitted

@onready var form = $CredentialsForm
var player_input = null
var opponent_input = null
var submit_button = null

func _ready():
	player_input = form.find_child("Player")
	opponent_input = form.find_child("Opponent")
	submit_button = form.find_child("Button")
	submit_button.connect("pressed", _on_submit.bind())

func _on_submit():
	var player_id = player_input.text
	var opponent_id = opponent_input.text
	emit_signal("submitted", player_id, opponent_id)
