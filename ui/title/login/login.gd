extends Control

signal login_submitted
signal register_submitted
signal error_received

@onready var title = $PanelContainer/VBoxContainer/Label
@onready var login_choose = $PanelContainer/VBoxContainer/Choose/LoginButton
@onready var register_choose = $PanelContainer/VBoxContainer/Choose/RegisterButton
@onready var login_form = $PanelContainer/VBoxContainer/LoginForm
@onready var register_form = $PanelContainer/VBoxContainer/RegisterForm
@onready var login_form_submit = $PanelContainer/VBoxContainer/LoginForm/Submit
@onready var register_form_submit = $PanelContainer/VBoxContainer/RegisterForm/Submit

var loading_icon = preload("res://assets/ui/icons/Clock.png")

var is_login: bool = true
var is_disabled: bool = false

func _ready():
	login_choose.pressed.connect(_on_login_choose.bind())
	register_choose.pressed.connect(_on_register_choose.bind())
	login_form_submit.pressed.connect(_on_login_submit.bind())
	register_form_submit.pressed.connect(_on_register_submit.bind())

func _on_login_submit():
	var username = login_form.find_child("Username").text
	var password = login_form.find_child("Password").text
	if username == "":
		emit_signal("error_received", "USERNAME EMPTY")
		return
	if password == "":
		emit_signal("error_received", "PASSWORD EMPTY")
		return
	is_disabled = true
	_disable_submit(login_form_submit)
	emit_signal("login_submitted", username, password)

func _on_register_submit():
	var username = register_form.find_child("Username").text
	var password = register_form.find_child("Password").text
	var password_check = register_form.find_child("RetypePassword").text
	if username == "":
		emit_signal("error_received", "USERNAME EMPTY")
		return
	if password == "":
		emit_signal("error_received", "PASSWORD EMPTY")
		return
	if password != password_check:
		emit_signal("error_received", "PASSWORD MISMATCH")
		return
	is_disabled = true
	_disable_submit(register_form_submit)
	emit_signal("register_submitted", username, password)

func _on_login_choose():
	if not is_disabled:
		title.text = "Login"
		login_form.visible = true
		register_form.visible = false

func _on_register_choose():
	if not is_disabled:
		title.text = "Register"
		login_form.visible = false
		register_form.visible = true

func _disable_submit(submit_button: Button):
	submit_button.text = ""
	submit_button.icon_alignment = HORIZONTAL_ALIGNMENT_CENTER
	submit_button.icon = loading_icon
	submit_button.disabled = true
	
func _enable_submit(submit_button: Button):
	submit_button.text = "Submit"
	submit_button.icon_alignment = HORIZONTAL_ALIGNMENT_LEFT
	submit_button.icon = null
	submit_button.disabled = false

func enable():
	is_disabled = false
	_enable_submit(login_form_submit)
	_enable_submit(register_form_submit)
