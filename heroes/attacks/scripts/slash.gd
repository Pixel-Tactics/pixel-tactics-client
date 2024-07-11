extends BaseAttackAnimation

class_name SlashAnimation

var _slash_projectile = preload("res://heroes/attacks/projectiles/slash.tscn")
var _is_playing: bool = false

func start_animation(_center_pos: Vector2, targets: Array[BaseHero], parent_obj: Node):
	if _is_playing:
		push_warning("animation is playing")
		return
	
	if len(targets) == 0:
		push_warning("target cannot be empty")
		return
	
	_is_playing = true
	_hero.animation_attack_started.connect(_create_slash.bind(_hero, targets, parent_obj))
	_hero.play_animation("attack")

func _create_slash(hero: BaseHero, targets: Array[BaseHero], parent_obj: Node):
	hero.animation_attack_started.disconnect(
		_create_slash
	)
	
	var proj = _slash_projectile.instantiate()
	proj.position = targets[0].position
	parent_obj.add_child(proj)
	proj.animation_ended.connect(
		func():
			proj.queue_free()
			_hero.play_animation("default")
			_is_playing = false
			animation_ended.emit()
	)
	proj.play()
