extends Control

@onready var winning_label = $PanelContainer/VBoxContainer/WinningStatus
@onready var opponent_label = $PanelContainer/VBoxContainer/Opponent
@onready var reward_list = $PanelContainer/VBoxContainer/PanelContainer/RewardScroll/RewardHBox

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
