extends Control

@onready var btn:TextureButton = $TextureButton
@onready var anim:AnimationPlayer = $TextureButton/AnimationPlayer
@onready var typeRect:ColorRect = $TextureButton/TypeRect
@onready var nameText:Label = $TextureButton/NameText
@onready var powerText:Label = $TextureButton/PowerText

static var textures:Array[CompressedTexture2D] = [
	load("res://images/cards/0.png"),
	load("res://images/cards/1.png"),
	load("res://images/cards/2.png"),
	load("res://images/cards/3.png"),
	load("res://images/cards/0.png"),
	load("res://images/cards/5.png"),
	load("res://images/cards/6.png"),
	load("res://images/cards/7.png"),
	load("res://images/cards/8.png"),
	load("res://images/cards/9.png")
]

var control:Control
var id:int
var data:Dictionary

func _ready():
	btn.mouse_entered.connect(mouseEnter)
	btn.mouse_exited.connect(mouseExit)
	#btn.texture_normal =

func init(_control:Control, _id:int) -> bool:
	data = Monster.monsterData[_id]
	control = _control
	id = _id
	
	if control.using_pets_id[id] == -1:
		self.hide()
		return false
	
	nameText.text = data["name"]
	powerText.text = str(data["power"])
	var type = data["type"]
	if type == 1:
		typeRect.color = Color(0,0.5,1,1)
	elif type == 2:
		typeRect.color = Color(1,0.25,0,1)
	elif type == 3:
		typeRect.color = Color(0,1,0.5,1)
	else:
		typeRect.color = Color(0,0,0,1)
	
	self.show()
	if id < len(textures):
		btn.texture_normal = textures[id]
	return true
	
	
func disable():
	btn.disabled = true;
	nameText.hide()
	powerText.hide()
	typeRect.hide()

func enable():
	btn.disabled = false;
	nameText.show()
	powerText.show()
	typeRect.show()

func initAnimation(section:float):
	anim.play_section("init",section)

func mouseEnter():
	if !control.pets_used[id]:
		anim.play("mouse_enter")

func mouseExit(speed:float = -0.75):
	if !control.pets_used[id]:
		anim.play("mouse_enter",-1, speed, true)
