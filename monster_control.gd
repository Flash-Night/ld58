extends Control
@onready var player=$"../Player"
@onready var camera=$"../Camera2D"
@onready var monsterlayer=$"../MonsterLayer"
@onready var map=$"../Map"
@onready var control=camera.get_node("Control")
var buttons:Array[Button]
var scene=preload("res://tile_button.tscn")
var using_max=8
var page_max=2
var now_page=0
var using_pets_id:Array[int]
var pets_used:Array[bool]

var selection:int = -1

func _ready() -> void:
	for i in range(using_max*page_max):
		using_pets_id.append(-1)
		pets_used.append(false)
	for i in range(0,4):
		using_pets_id[i]=i
		#control.show_button_monster(i,i)
	control.game_control=self

func isDroppable(pos:Vector2i, isFly:bool)-> bool:
	if monsterlayer.monsterDict.has(pos):
		return false
	if isFly:
		return true
	var cellID = map.get_cell_source_id(pos)
	return cellID == 0

func place_tile_buttons(id:int)->void:
	selection = id
	remove_tile_buttons()
	player.isIdle = false
	var playerpos = player.pos
	var x = playerpos.x*64.0
	var y = playerpos.y*64.0
	for i in range(7):
		for j in range(7):
			var pos = Vector2i(playerpos.x + i - 3,playerpos.y + j - 3)
			buttons.append(scene.instantiate())
			var k=i*7+j
			add_child(buttons[k])
			buttons[k].position.x=x-3*64+i*64
			buttons[k].position.y=y-3*64+j*64
			buttons[k].z_index=10
			buttons[k].pressed.connect(drop.bind(pos))
			
func drop(pos):
	player.isIdle = true
	if isDroppable(pos, false) && pets_used[selection]==false && using_pets_id[selection]!=-1:
		monsterlayer.addPet(using_pets_id[selection], pos)
		pets_used[selection]=true
		control.buttons[selection].disable()
	selection = -1
	remove_tile_buttons()

func remove_tile_buttons()->void:
	for b in buttons:
		b.queue_free()
	buttons.resize(0)

func remove_pets() -> void:
	var regain_pets=monsterlayer.removeAllPets()
	for i in using_max:
		for j in regain_pets:
			if using_pets_id[i]==j :
				pets_used[i]=false
				control.buttons[i].enable()
				control.buttons[i].initAnimation(0.8 + float(randi_range(0,4)) * 0.05)
func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("z"):
		remove_pets()
