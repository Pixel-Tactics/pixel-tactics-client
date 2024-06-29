extends Node

enum SceneName {
	LOGIN,
	TITLE_SCREEN,
	MATCH,
}

var login_templ = preload("res://pages/login_screen/login_screen.tscn")
var title_templ = preload("res://pages/title_screen/title_screen.tscn")
var match_templ = preload("res://pages/match/match.tscn")

var next_scene = null
var current_scene = null

func _ready():
	change_scene(SceneName.LOGIN)

func _process(_delta):
	var is_run = get_tree().root.has_node("Blank")
	if next_scene != null and is_run:
		_on_next_scene()

func change_scene(scene_name: SceneName):
	next_scene = scene_name

func _on_next_scene():
	var scene = null
	match next_scene:
		SceneName.LOGIN:
			scene = login_templ.instantiate()
		SceneName.TITLE_SCREEN:
			scene = title_templ.instantiate()
		SceneName.MATCH:
			scene = match_templ.instantiate()
	if scene != null:
		get_tree().root.add_child(scene)
		if current_scene != null:
			current_scene.queue_free()
		current_scene = scene
	next_scene = null
