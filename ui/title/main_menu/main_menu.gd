extends Control

signal invite_submitted

@onready var user_stats = $UserStats
@onready var invite_form = $InviteBattle

var _user: User = null

func init(user: User):
	_user = user
	user_stats.update_ui(_user)

func _ready():
	invite_form.invite_submitted.connect(_on_invite_submit)

func _on_invite_submit(user_id):
	emit_signal("invite_submitted", user_id)
