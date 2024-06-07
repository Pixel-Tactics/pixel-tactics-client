extends Object

class_name BFSOnMap

var _map: Array
var _hero_pos: Array
var _src: Vector2i
var _queue: Array
var _visited: Dictionary
var _max_dist

func _init(
	map: Array,
	src: Vector2i,
	max_dist = null,
	hero_pos: Array = [],
):
	_map = map
	_hero_pos = hero_pos
	_src = src
	_max_dist = max_dist
	_visited = {}
	_queue = []

func calculate():
	# TODO: still uses map on visited, still uses array on queue, still uses vector float
	_queue.push_back({
		"point": _src,
		"dist": 0,
		"last": null,
	})
	_visited[_src] = {
		"dist": 0,
		"last": null,
	}
	while len(_queue) > 0:
		var cur_node = _queue.front()
		_queue.pop_front()
		var cur_point = cur_node.point
		var cur_dist = cur_node.dist
		_enqueue_if_available(Vector2i(cur_point.x+1, cur_point.y), cur_point, cur_dist + 1)
		_enqueue_if_available(Vector2i(cur_point.x-1, cur_point.y), cur_point, cur_dist + 1)
		_enqueue_if_available(Vector2i(cur_point.x, cur_point.y+1), cur_point, cur_dist + 1)
		_enqueue_if_available(Vector2i(cur_point.x, cur_point.y-1), cur_point, cur_dist + 1)
	return _visited
	
func _enqueue_if_available(cur_node: Vector2i, last_node: Vector2i, dist: int):
	var len_x = len(_map[0])
	var len_y = len(_map)
	var cur_x = cur_node.x
	var cur_y = cur_node.y
	if _max_dist != null and dist > _max_dist:
		return
	if not (0 <= cur_x and cur_x < len_x and 0 <= cur_y and cur_y < len_y):
		return
	if _map[cur_y][cur_x] == 2:
		return
	if len(_hero_pos) > 0:
		for pos in _hero_pos:
			if cur_node == pos:
				return
	if _visited.has(cur_node):
		return
	_visited[cur_node] = {
		"last": last_node,
		"dist": dist,
	}
	_queue.push_back({
		"point": cur_node,
		"dist": dist,
		"last": last_node,
	})
