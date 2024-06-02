extends Node

@onready var tilemap = $TileMap

var map_state = null

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func generate_map(map: Array):
	map_state = map
	_generate_boundaries()
	
	var boundary_cells = []
	var ground_cells = []
	var wall_cells = []
	
	for i in range(map.size()):
		for j in range(map[i].size()):
			if map[i][j] <= 0:
				boundary_cells.append(Vector2(j, i))
			else:
				ground_cells.append(Vector2(j, i))
				if map[i][j] > 1:
					wall_cells.append(Vector2(j, i))

	for cell in boundary_cells:
		tilemap.set_cell(0, cell, 0, Vector2(1, 2))
	tilemap.set_cells_terrain_connect(0, ground_cells + ground_cells, 0, 0)
	for cell in wall_cells:
		tilemap.set_cell(1, cell, 0, Vector2(6, 0))

func _generate_boundaries():
	var cells = []
	for i in range(-64, 65):
		for j in range(-64, 65):
			tilemap.set_cell(0, Vector2(i, j), 0, Vector2(1, 2))

func update_map(new_map):
	pass

func get_map():
	return map_state
