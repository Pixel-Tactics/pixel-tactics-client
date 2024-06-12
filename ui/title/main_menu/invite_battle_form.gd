extends PanelContainer

signal invite_submitted

@onready var user_id_field = $VBoxContainer/InviteForm/UserId
@onready var submit_button = $VBoxContainer/InviteForm/Submit

func _ready():
	submit_button.pressed.connect(_on_submit)

func _on_submit():
	var user_id = user_id_field.text
	emit_signal("invite_submitted", user_id)
