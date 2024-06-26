extends Node

enum SceneName {
	TITLE_SCREEN,
	MATCH,
}

var title_templ = preload("res://pages/title_screen/title_screen.tscn")
var match_templ = preload("res://pages/match/match.tscn")

var next_scene = null
var current_scene = null

func _ready():
	change_scene(SceneName.TITLE_SCREEN)

func _process(_delta):
	if next_scene != null:
		_on_next_scene()

func change_scene(scene_name: SceneName):
	next_scene = scene_name

func _on_next_scene():
	var scene = null
	match next_scene:
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
