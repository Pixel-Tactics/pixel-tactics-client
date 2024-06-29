@tool
extends EditorScript


# Called when the node enters the scene tree for the first time.
func _run():
	print("test1".to_lower().find("p".to_lower()))
	#"ASD".to_lower().find(keyword.to_lower())
