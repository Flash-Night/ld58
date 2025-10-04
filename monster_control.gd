extends Control
@onready var player=$"../Player"
@onready var camera=$"../Camera2D"
@onready var monsterlayer=$"../MonsterLayer"
@onready var map=$"../Map"

var buttons:Array[Button]
var scene=preload("res://tile_button.tscn")
func _ready() -> void:
	var control=camera.get_node("Control")
	control.game_control=self
	control.bconnect()

func isDroppable(pos:Vector2i, isFly:bool)-> bool:
	if monsterlayer.monsterDict.has(pos):
		return false
	if isFly:
		return true
	var cellID = map.get_cell_source_id(pos)
	return cellID == 0

func place_tile_buttons()->void:
	remove_tile_buttons()
	var x = player.position.x
	var y = player.position.y
	var playerpos = player.pos
	for i in range(7):
		for j in range(7):
			var pos = Vector2i(playerpos.x + i - 3,playerpos.y + j - 3)
			buttons.append(scene.instantiate())
			var k=i*7+j
			add_child(buttons[k])
			buttons[k].position.x=x-7*32+i*64
			buttons[k].position.y=y-7*32+j*64
			buttons[k].z_index=10
			buttons[k].pressed.connect(drop.bind(pos))
			
func drop(pos):
	if isDroppable(pos, false):
		monsterlayer.addPet(0, pos)
	remove_tile_buttons()

func remove_tile_buttons()->void:
	for b in buttons:
		b.queue_free()
	buttons.resize(0)
