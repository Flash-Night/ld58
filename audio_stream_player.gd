extends AudioStreamPlayer
func _on_finished() -> void:
	play()
func _ready() -> void:
	finished.connect(Callable(_on_finished) )
