extends Node2D
class_name Monster

@export var id:int

static var monsterData:Dictionary = {
	0:{
		"power": 3,
		"type": 0
	},
	1:{
		"power": 2,
		"type": 1
	}
}

var data:Dictionary
var pos:Vector2i

var powerLabel:Label

func _ready():
	powerLabel = get_node("PowerLabel")

func init() -> Vector2i:
	data = monsterData[id]
	powerLabel.text = str(data["power"])
	
	pos = Vector2i(int(self.position.x / 64),int(self.position.y / 64))
	self.position.x = pos.x * 64 + 32
	self.position.y = pos.y * 64 + 32
	return pos
