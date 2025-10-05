extends Control

@onready var btn:TextureButton = $TextureButton
@onready var anim:AnimationPlayer = $TextureButton/AnimationPlayer

static var textures:Array[CompressedTexture2D] = [
	load("res://images/cards/1.png"),
	load("res://images/cards/2.png"),
	load("res://images/cards/3.png"),
	load("res://images/cards/4.png")
]

var control:Control
var id:int

func _ready():
	btn.mouse_entered.connect(mouseEnter)
	btn.mouse_exited.connect(mouseExit)
	#btn.texture_normal =

func init(_control:Control, _id:int) -> bool:
	control = _control
	id = _id
	if control.using_pets_id[id] == -1:
		self.hide()
		return false
	self.show()
	if id < len(textures):
		btn.texture_normal = textures[id]
	return true
	
func initAnimation(section:float):
	anim.play_section("init",section)

func mouseEnter():
	if !control.pets_used[id]:
		anim.play("mouse_enter")

func mouseExit():
	if !control.pets_used[id]:
		anim.play("mouse_enter",-1, -0.75, true)
