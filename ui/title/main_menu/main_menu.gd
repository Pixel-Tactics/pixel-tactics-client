extends Control

signal invite_submitted
signal error_received

@onready var user_stats = $UserStats
@onready var invite_form = $InviteBattle

var _user: User = null

func init(user: User):
	_user = user
	user_stats.update_ui(_user)

func _ready():
	invite_form.invite_submitted.connect(_on_invite_submit)
	invite_form.error_received.connect(_on_invite_error)

func _on_invite_submit(user_id):
	invite_submitted.emit(user_id)

func _on_invite_error():
	error_received.emit("CANNOT FETCH PLAYERS")
