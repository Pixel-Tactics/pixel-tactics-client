extends Control

signal invite_submitted
signal error_received

@onready var user_stats = $UserStats
@onready var invite_form = $InviteBattle

func update_ui():
	user_stats.update_ui(Global.user)

func _ready():
	invite_form.invite_submitted.connect(_on_invite_submit)
	invite_form.error_received.connect(_on_invite_error)
	Global.user_updated.connect(func(): update_ui())

func _on_invite_submit(user_id):
	invite_submitted.emit(user_id)

func _on_invite_error():
	error_received.emit("CANNOT FETCH PLAYERS")
