extends TextureRect

var _is_ready = false

func _process(_delta):
	if not _is_ready:
		_is_ready = true
		_tween_up()

func _tween_down():
	if not is_inside_tree():
		return
	var tween = get_tree().create_tween()
	tween.tween_property(
		self,
		"position",
		 Vector2(self.position.x, self.position.y + 16),
		2
	).set_trans(Tween.TRANS_SINE)
	tween.tween_callback(_tween_up)

func _tween_up():
	if not is_inside_tree():
		return
	var tween = get_tree().create_tween()
	tween.tween_property(
		self,
		"position",
		Vector2(self.position.x, self.position.y - 16),
		2
	).set_trans(Tween.TRANS_SINE)
	tween.tween_callback(_tween_down)
