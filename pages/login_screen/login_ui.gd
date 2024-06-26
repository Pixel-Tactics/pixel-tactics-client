extends CanvasLayer

signal login_submit
signal register_submit

@onready var form = $Login
@onready var toast = $Toast

var locked: bool = false

func _ready():
	form.login_submitted.connect(_on_login_submit.bind())
	form.register_submitted.connect(_on_register_submit.bind())
	form.error_received.connect(_on_form_error.bind())

func _on_login_submit(username, password):
	if not locked:
		locked = true
		emit_signal("login_submit", username, password)

func _on_register_submit(username, password):
	if not locked:
		locked = true
		emit_signal("register_submit", username, password)

func _on_form_error(msg):
	locked = false
	toast.push(ToastBox.ERROR, msg)

func form_error(msg):
	locked = false
	toast.push(ToastBox.ERROR, msg)
	form.enable()
