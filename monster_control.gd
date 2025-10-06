extends Control
@onready var player=$"../Player"
@onready var camera=$"../Camera2D"
@onready var monsterlayer=$"../MonsterLayer"
@onready var map=$"../Map"
@onready var control=camera.get_node("Control")
@onready var selectlabel = $"../Selectlabel"

var buttons:Array[Button]
var scene=preload("res://tile_button.tscn")
var using_max=20 # 8
var page_max=2
var now_page=0
var using_pets_id:Array[int]
var pets_used:Array[bool]

var selection:int = -1

func _ready() -> void:
	for i in range(using_max):
		using_pets_id.append(-1)
		pets_used.append(false)
	for i in range(0,4):
		using_pets_id[i]=i
		#control.show_button_monster(i,i)
	control.game_control=self
	selectlabel.hide()
	
	var hintl = $"../FrontMap/HintLabel"
	var hintl2 = $"../FrontMap/HintLabel2"
	var hintl3 = $"../FrontMap/HintLabel3"
	if Game.language_en:
		hintl.text = "Use monster cards to collect new monsters. \nPlace your own monsters around the target monster. \nIf the target monster is surrounded by your own monsters \nabove, below, left, and right, and all four monsters's power \nare higher than the target, you have captured and collected it."
		hintl2.text = "Fight using each monster's ability!"
		hintl3.text = "Press Z to wtihdraw all \nyour monsters placed"
	
func isDroppable(pos:Vector2i, isFly:bool)-> bool:
	if monsterlayer.monsterDict.has(pos):
		return false
	if isFly:
		return true
	var cellID = map.get_cell_source_id(pos)
	return cellID == 0

func place_tile_buttons(id:int)->void:
	remove_tile_buttons()
	selection = id
	var isFly = (selection == 8 || (selection>=13 && selection<=18))
	player.isIdle = false
	selectlabel.showLabel()
	var playerpos = player.pos
	var x = playerpos.x*64.0
	var y = playerpos.y*64.0
	selectlabel.position.x = x + 32
	selectlabel.position.y = y + 32
	for i in range(7):
		for j in range(7):
			var pos = Vector2i(playerpos.x + i - 3,playerpos.y + j - 3)
			buttons.append(scene.instantiate())
			var k=i*7+j
			add_child(buttons[k])
			if !isDroppable(pos, isFly):
				buttons[k].hide()
			
			buttons[k].position.x=x-3*64+i*64 + 4
			buttons[k].position.y=y-3*64+j*64 + 4
			buttons[k].z_index=10
			buttons[k].pressed.connect(drop.bind(pos))
			
func drop(pos):
	var isFly = (selection == 8 || (selection>=13 && selection<=18))
	if isDroppable(pos, isFly) && pets_used[selection]==false && using_pets_id[selection]!=-1:
		monsterlayer.addPet(using_pets_id[selection], pos)
		pets_used[selection]=true
		control.buttons[selection].disable()
	remove_tile_buttons()

func remove_tile_buttons()->void:
	player.isIdle = true
	selectlabel.hideLabel()
	selection = -1
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
	if selection == -1 and Input.is_action_just_pressed("z"):
		remove_pets()
	if Input.is_action_just_pressed("ui_cancel"):
		remove_tile_buttons()
