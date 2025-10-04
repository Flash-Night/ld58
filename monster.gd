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
var isEnemy:bool

var power:int

var redflag:Sprite2D
var greenflag:Sprite2D
var powerLabel:Label

func _ready():
	redflag = get_node("RedFlag")
	greenflag = get_node("GreenFlag")
	powerLabel = get_node("PowerLabel")

func init(_isEnemy:bool, _id:int, _pos:Vector2i = Vector2i(-1,-1)) -> Vector2i:
	#print(_isEnemy,_id)
	isEnemy = _isEnemy
	if _id > -1 :
		id = _id
	data = monsterData[id]
	power = data["power"]
	#var lbtext = str(id) + ": " + str(data["power"])
	
	if isEnemy:
		redflag.show()
		greenflag.hide()
	else:
		greenflag.show()
		redflag.hide()
	powerLabel.text = str(power)
	
	if _pos.x < 0:
		pos = Vector2i(int(self.position.x / 64),int(self.position.y / 64))
	else:
		pos = _pos
	self.position.x = pos.x * 64 + 32
	self.position.y = pos.y * 64 + 32
	return pos

func refresh():
	pass

func isCaptured() -> bool:
	if !isEnemy:
		return false
	var posArr = [
		Vector2i(pos.x - 1, pos.y),
		Vector2i(pos.x + 1, pos.y),
		Vector2i(pos.x, pos.y - 1),
		Vector2i(pos.x, pos.y + 1)
	]
	var monsterDict = get_parent().monsterDict
	for targetpos in posArr:
		if !monsterDict.has(targetpos):
			return false
		var pet = monsterDict[targetpos]
		if pet.isEnemy:
			return false
		if pet.power <= self.power:
			return false
	return true
