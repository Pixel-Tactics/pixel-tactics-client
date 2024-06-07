extends Node

class_name MapManager

signal move_tile_selected
signal attack_tile_selected

@export var action_tile_templ = preload("res://objects/action_tile.tscn")

@onready var tilemap = $TileMap
@onready var action_tiles = $ActionTiles
@onready var heroes = $Heroes

var map_state = null
var last_bfs_result = {}

func make_move_tiles(map: Array, src: Vector2i, max_length, hero_pos: Array):
	remove_tiles()
	var bfs_result = BFSOnMap.new(map, src, max_length, hero_pos).calculate()
	last_bfs_result = bfs_result
	for node in bfs_result.keys():
		var action_tile = action_tile_templ.instantiate()
		action_tile.init(ActionTile.MOVE)
		action_tile.position = map_to_world(node)
		action_tile.pressed.connect(_on_move_tile_pressed.bind())
		action_tiles.add_child(action_tile)
		
func make_attack_tiles(map: Array, src: Vector2i, max_length):
	remove_tiles()
	var bfs_result = BFSOnMap.new(map, src, max_length).calculate()
	last_bfs_result = bfs_result
	for node in bfs_result.keys():
		var action_tile = action_tile_templ.instantiate()
		action_tile.init(ActionTile.ATTACK)
		action_tile.position = map_to_world(node)
		action_tile.pressed.connect(_on_attack_tile_pressed.bind())
		action_tiles.add_child(action_tile)
	
func remove_tiles():
	last_bfs_result = {}
	var children = action_tiles.get_children()
	for child in children:
		action_tiles.remove_child(child)
		child.queue_free()

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
				if map[i][j] == 2:
					wall_cells.append(Vector2(j, i))

	for cell in boundary_cells:
		tilemap.set_cell(0, cell, 0, Vector2(1, 2))
	tilemap.set_cells_terrain_connect(0, ground_cells + ground_cells, 0, 0)
	for cell in wall_cells:
		tilemap.set_cell(1, cell, 0, Vector2(6, 0))

func _generate_boundaries():
	for i in range(-16, 16):
		for j in range(-16, 16):
			tilemap.set_cell(0, Vector2i(i, j), 0, Vector2i(1, 2))

func map_to_world(pos: Vector2):
	return tilemap.map_to_local(pos)
	
func world_to_map(pos: Vector2):
	return tilemap.local_to_map(pos)

func update_map(_new_map):
	pass

func get_map():
	return map_state

func vector_plus_directions(vector, dir_list):
	var diff = Vector2i(0,0)
	for dir in dir_list:
		if dir == "RIGHT":
			diff += Vector2i(1,0)
		elif dir == "LEFT":
			diff += Vector2i(-1,0)
		elif dir == "UP":
			diff += Vector2i(0,-1)
		else:
			diff += Vector2i(0,1)
	return vector + diff

func _on_move_tile_pressed(pos: Vector2):
	var map_pos = world_to_map(pos)
	var cur = map_pos
	var arr = []
	while last_bfs_result.has(cur) and last_bfs_result[cur].last != null:
		var last_node = last_bfs_result[cur].last
		var diff = cur - last_node
		var dir
		if diff == Vector2i(1, 0):
			dir = "RIGHT"
		elif diff == Vector2i(-1, 0):
			dir = "LEFT"
		elif diff == Vector2i(0, 1):
			dir = "DOWN"
		else:
			dir = "UP"
		arr.push_back(dir)
		cur = null
		cur = last_node
	arr.reverse()
	emit_signal("move_tile_selected", arr)

func _on_attack_tile_pressed(pos: Vector2):
	emit_signal("attack_tile_selected", pos)
