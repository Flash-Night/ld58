extends Node2D

@export var id:int

var pos:Vector2i

func _ready():
	pass

func init() -> Vector2i:
	pos = Vector2i(int(self.position.x / 64),int(self.position.y / 64))
	self.position.x = pos.x * 64 + 32
	self.position.y = pos.y * 64 + 32
	return pos
