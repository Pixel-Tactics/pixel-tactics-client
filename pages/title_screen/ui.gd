extends CanvasLayer

@onready var form = $Login
@onready var toast = $Toast

func _ready():
	form.login_submitted.connect(_on_login_submit.bind())
	form.register_submitted.connect(_on_register_submit.bind())
	form.error_received.connect(_on_form_error.bind())

func _on_login_submit(username, password):
	toast.push(ToastBox.LOADING, "LOADING...")
	
func _on_register_submit(username, password):
	toast.push(ToastBox.LOADING, "LOADING...")

func _on_form_error(msg):
	toast.push(ToastBox.ERROR, msg)
