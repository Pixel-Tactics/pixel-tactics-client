@tool
extends EditorScript

const LOOPS: int = 2000
const ITEMS: int = 1250

enum Testos {
	ABC,
	DEF,
	GHI,
}

func _run():
	print(len(Testos))
	print(Testos.keys())
	print(Testos.values())
	
