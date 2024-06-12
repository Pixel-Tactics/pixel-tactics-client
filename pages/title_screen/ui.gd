extends CanvasLayer

signal login_submit
signal register_submit
signal invite_submit

@onready var form = $Login
@onready var main_menu = $MainMenu
@onready var toast = $Toast

var locked: bool = false

func _ready():
	form.login_submitted.connect(_on_login_submit.bind())
	form.register_submitted.connect(_on_register_submit.bind())
	form.error_received.connect(_on_form_error.bind())
	main_menu.invite_submitted.connect(_on_invite_submit.bind())

func _on_login_submit(username, password):
	if not locked:
		locked = true
		toast.push(ToastBox.LOADING, "LOADING...")
		emit_signal("login_submit", username, password)

func _on_register_submit(username, password):
	if not locked:
		locked = true
		toast.push(ToastBox.LOADING, "LOADING...")
		emit_signal("register_submit", username, password)

func _on_form_error(msg):
	locked = false
	toast.push(ToastBox.ERROR, msg)

func _on_invite_submit(user_id):
	emit_signal("invite_submit", user_id)

func form_error(msg):
	locked = false
	toast.push(ToastBox.ERROR, msg)

func notify(msg):
	toast.push(ToastBox.INFO, msg)

func go_to_menu():
	form.visible = false
	main_menu.init(Global.user)
	main_menu.visible = true
