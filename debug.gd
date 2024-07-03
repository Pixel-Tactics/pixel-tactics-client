@tool
extends EditorScript

const LOOPS: int = 2000
const ITEMS: int = 1250

func _run():
	var v1 = Vector2(1,2)
	var arr = [v1]
	v1.x = 100
	print(v1)
	print(arr[0])
	
