extends Node


func Setup():
	pass
	
func GetMapData():
	return [
		[1, 1, 1, 1, 1, 1, 1],
		[1, 2, 2, 1, 1, 1, 1],
		[1, 1, 1, 1, 1, 1],
		[1, 1, 2, 2, 1],
		[1, 1, 1, 1, 1],
	]

func GetAvailableHeroes():
	return [
		"knight",
	]
