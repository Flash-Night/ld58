extends Node2D

var animation:AnimatedSprite2D
var map:TileMapLayer
var pos:Vector2i


func _ready() -> void:
	#animation = get_node("Animation")
	map = get_parent().get_node("Map")
	pos = Vector2i(0,0)
	self.position.x = 32
	self.position.y = 32
	
func  _process(_delta: float) -> void:
	if Input.is_action_just_pressed("ui_left"):
		move("left")
	if Input.is_action_just_pressed("ui_right"):
		move("right")
	if Input.is_action_just_pressed("ui_up"):
		move("back")
	if Input.is_action_just_pressed("ui_down"):
		move("front")

func move(direction:String) -> void:
	var targetpos = Vector2i(pos.x,pos.y)
	#animation.play(direction)
	if direction == "left":
		targetpos.x -= 1
	elif direction == "right":
		targetpos.x += 1
	elif direction == "back":
		targetpos.y -= 1
	elif direction == "front":
		targetpos.y += 1
	var cellID = map.get_cell_source_id(targetpos)
	if cellID == 0:
		pos = targetpos
		self.position.x = pos.x * 64 + 32
		self.position.y = pos.y * 64 + 32
