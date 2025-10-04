extends Control
@onready var player=$"../Player"
@onready var camera=$"../Camera2D"
var buttons:Array[Button]
var scene=preload("res://tile_button.tscn")
func _ready() -> void:
	var control=camera.get_node("Control")
	control.game_control=self
	control.bconnect()
func place_tile_buttons()->void:
	remove_tile_buttons()
	var x = player.position.x
	var y = player.position.y
	for i in range(7):
		for j in range(7):
			buttons.append(scene.instantiate())
			var k=i*7+j
			add_child(buttons[k])
			buttons[k].position.x=x-7*32+i*64
			buttons[k].position.y=y-7*32+j*64
			buttons[k].z_index=10
			
func remove_tile_buttons()->void:
	for b in buttons:
		b.queue_free()
	buttons.resize(0)
