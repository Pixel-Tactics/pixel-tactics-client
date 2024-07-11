extends BaseHero

func _init():
	attack_animation = SlashAnimation.new()
	attack_animation.init_hero(self)
	_attack_start_frame = 1
	_attack_end_frame = 4
