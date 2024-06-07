@tool
extends EditorScript


# Called when the node enters the scene tree for the first time.
func _run():
	var arr = [-1, 3, 5]
	test(arr)
	print(arr)

func test(arr):
	arr[0] = 2
