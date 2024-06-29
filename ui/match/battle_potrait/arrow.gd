extends TextureRect

func _ready():
	_tween_up()

func _tween_down():
	var tree = get_tree()
	if tree == null:
		return
	var tween = tree.create_tween()
	tween.tween_property(
		self,
		"position",
		 Vector2(self.position.x, self.position.y + 16),
		2
	).set_trans(Tween.TRANS_SINE)
	tween.tween_callback(_tween_up)

func _tween_up():
	var tree = get_tree()
	if tree == null:
		return
	var tween = tree.create_tween()
	tween.tween_property(
		self,
		"position",
		Vector2(self.position.x, self.position.y - 16),
		2
	).set_trans(Tween.TRANS_SINE)
	tween.tween_callback(_tween_down)
