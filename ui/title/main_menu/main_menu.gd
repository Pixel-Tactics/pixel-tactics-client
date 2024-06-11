extends Control

@onready var user_stats = $UserStats

var _user: User = null

func init(player_token: String, user: User):
	_user = user
	user_stats.update_ui(_user)
