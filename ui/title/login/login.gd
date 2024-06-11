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

var is_login: bool = true

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
	emit_signal("register_submitted", username, password)

func _on_login_choose():
	title.text = "Login"
	login_form.visible = true
	register_form.visible = false

func _on_register_choose():
	title.text = "Register"
	login_form.visible = false
	register_form.visible = true
