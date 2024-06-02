@tool
extends EditorScript


# Called when the node enters the scene tree for the first time.
func _run():
	var test = Player.new("test", [])
	print(test.id)
	print(test.hero_list)
	
	
