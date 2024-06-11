extends PanelContainer

@onready var level_label = $HBoxContainer/LevelBox/LevelLabel
@onready var name_label = $HBoxContainer/VBoxContainer/NameLabel
@onready var exp_label = $HBoxContainer/VBoxContainer/ExpLabel

func update_ui(pname, level, rating, exp, max_exp):
	level_label.text = level
	name_label.text = "%s (rating: %d)" % [pname, rating]
	exp_label.text = "Exp: %d / %d" % [exp, max_exp]
