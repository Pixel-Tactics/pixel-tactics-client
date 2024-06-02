@tool
extends EditorScript


# Called when the node enters the scene tree for the first time.
func _run():
	var test = TimeManager.new()
	var summe_call = summe.bind()
	test.connect("test", summe_call)
	test.disconnect("test", summe_call)
	
func summe(a, b):
	print(a + b)

func huwa():
	print("HE")
