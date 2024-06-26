extends Control

signal back_to_menu

@onready var winning_label = $PanelContainer/VBoxContainer/WinningStatus
@onready var opponent_label = $PanelContainer/VBoxContainer/Opponent
@onready var reward_list = $PanelContainer/VBoxContainer/PanelContainer/RewardScroll/RewardHBox
@onready var loading = $PanelContainer/VBoxContainer/PanelContainer/Loading
@onready var reward_scroll = $PanelContainer/VBoxContainer/PanelContainer/RewardScroll
@onready var menu_button = $PanelContainer/VBoxContainer/Button

var reward_item_templ = preload("res://ui/match/match_ui/results/reward_item.tscn")

var winning_label_text = {
	true: "VICTORY",
	false: "DEFEATED"
}

func _ready():
	var winner_id = Global.last_session.state["winnerId"]
	var is_player_win = (Global.last_session.player.id == winner_id)
	var opponent = Global.last_session.opponent.id
	
	winning_label.text = winning_label_text[is_player_win]
	opponent_label.text = "AGAINST " + opponent
	
	menu_button.pressed.connect(func(): back_to_menu.emit())

func set_rewards(rewards: RewardDto):
	for child in reward_list.get_children():
		child.queue_free()
	for arr in rewards.reward_list:
		var key = arr[0]
		var value = arr[1]
		var reward_item = reward_item_templ.instantiate()
		reward_item.init(key, value)
		reward_list.add_child(reward_item)
	loading.visible = false
	reward_scroll.visible = true
