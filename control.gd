extends Control

@export var game_control:Control
var selecting:int
var buttons:Array[Button]
var max_using = 8
func _ready() -> void:
	pass
func bconnect()->void:
	var scene=preload("res://monster_using.tscn")
	buttons.resize(max_using)
	for i in range(max_using):
		buttons[i] = scene.instantiate()
		add_child(buttons[i])
		buttons[i].position.x=-600+i*100
		buttons[i].position.y=250
		buttons[i].z_index=20
	for i in range(max_using):
		buttons[i].button_down.connect(Callable(game_control,"place_tile_buttons"))
	
func _process(delta: float) -> void:
	selecting=0
	for i in range(max_using):
		if buttons[i].button_pressed:
			selecting=i
