extends CanvasLayer

signal login_submit
signal register_submit
signal invite_submit

@onready var main_menu = $MainMenu
@onready var toast = $Toast

var locked: bool = false

func _ready():
	main_menu.init(Global.user)
	main_menu.invite_submitted.connect(_on_invite_submit)
	main_menu.error_received.connect(_on_error)

func _on_error(msg):
	locked = false
	toast.push(ToastBox.ERROR, msg)

func _on_invite_submit(user_id):
	emit_signal("invite_submit", user_id)

func notify(msg):
	toast.push(ToastBox.INFO, msg)
