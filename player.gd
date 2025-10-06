extends Node2D

@onready var animation:AnimatedSprite2D = $Animation
var map:TileMapLayer
var monsterLayer:Node2D

var pos:Vector2i
var speed = 8

var state:int
var isIdle = true

func _ready() -> void:
	map = get_parent().get_node("Map")
	monsterLayer = get_parent().get_node("MonsterLayer")
	
	pos = Vector2i(0,0)
	state = 0
	self.position.x = 32
	self.position.y = 32
	
func  _process(_delta: float) -> void:
	if state == 0:
		if !isIdle:
			return
		if Input.is_action_pressed("ui_left"):
			move("left")
		elif Input.is_action_pressed("ui_right"):
			move("right")
		elif Input.is_action_pressed("ui_up"):
			move("back")
		elif Input.is_action_pressed("ui_down"):
			move("front")
	elif state == 1:
		moving()
			

func isMovable(targetpos:Vector2i) -> bool:
	if map.get_cell_source_id(targetpos) != 0:
		return false
	if monsterLayer.monsterDict.has(targetpos):
		return !monsterLayer.monsterDict[targetpos].isEnemy
	return true


func move(direction:String) -> void:
	var targetpos = Vector2i(pos.x,pos.y)
	animation.play(direction)
	if direction == "left":
		targetpos.x -= 1
	elif direction == "right":
		targetpos.x += 1
	elif direction == "back":
		targetpos.y -= 1
	elif direction == "front":
		targetpos.y += 1
	if isMovable(targetpos):
		pos = targetpos
		state = 1
		moving()

func moving() -> void:
	var _posx = pos.x * 64 + 32
	var _posy = pos.y * 64 + 32
	var dx = _posx - self.position.x
	var dy = _posy - self.position.y
	if dx < -speed:
		self.position.x -= speed
	elif dx > speed:
		self.position.x += speed
	else:
		self.position.x = _posx
		dx = 0
	if dy < -speed:
		self.position.y -= speed
	elif dy > speed:
		self.position.y += speed
	else:
		self.position.y = _posy
		dy = 0
	if dx == 0 and dy == 0:
		state = 0
