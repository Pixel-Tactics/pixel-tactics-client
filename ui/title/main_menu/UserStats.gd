extends PanelContainer

@onready var level_label = $HBoxContainer/LevelBox/LevelLabel
@onready var name_label = $HBoxContainer/VBoxContainer/NameLabel
@onready var exp_label = $HBoxContainer/VBoxContainer/ExpLabel

func update_ui(user: User):
	level_label.text = str(user.level)
	name_label.text = "%s (rating: %d)" % [user.username, user.rating]
	exp_label.text = "Exp: %d / %d" % [user.cur_experience, user.max_experience]
