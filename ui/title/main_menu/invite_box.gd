extends PanelContainer

signal invite_sent

@onready var _label = $VBoxContainer/Label
@onready var _submit_button = $VBoxContainer/Submit

var _loading_icon = preload("res://assets/ui/icons/Clock.png")

var username = null

func init(pusername):
	self.username = pusername

func _ready():
	_label.text = username
	_submit_button.pressed.connect(_on_invite)

func _on_invite():
	invite_sent.emit(username)

func enable():
	_submit_button.text = "Invite"
	_submit_button.icon_alignment = HORIZONTAL_ALIGNMENT_LEFT
	_submit_button.icon = null
	_submit_button.disabled = false

func disable():
	_submit_button.text = ""
	_submit_button.icon_alignment = HORIZONTAL_ALIGNMENT_CENTER
	_submit_button.icon = _loading_icon
	_submit_button.disabled = true
