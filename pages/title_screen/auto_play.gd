extends AudioStreamPlayer


# Called when the node enters the scene tree for the first time.
func _ready():
	self.finished.connect(_play_music.bind())
	_play_music()

func _play_music():
	self.play()
