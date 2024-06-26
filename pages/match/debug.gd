@tool
extends EditorScript


# Called when the node enters the scene tree for the first time.
func _run():
	var test = 3
	match test:
		2:
			print("OKAY")
			test = 3
		3:
			print("NOT SUPPOSED TO")

func test(arr):
	arr[0] = 2
