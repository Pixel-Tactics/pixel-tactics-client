extends RefCounted

class_name BaseAttackAnimation

signal animation_ended

var _hero: BaseHero = null

func init_hero(hero: BaseHero):
	_hero = hero

func start_animation(_center_pos: Vector2, _targets: Array[BaseHero], _parent_obj: Node):
	push_error("animation not implemented")
