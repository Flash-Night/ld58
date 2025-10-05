extends Node2D
class_name Monster

@export var id:int

static var pos4 = [
	Vector2i(-1, 0),
	Vector2i(1, 0),
	Vector2i(0, -1),
	Vector2i(0, 1)
]
static var pos8 = [
	Vector2i(-1, -1),
	Vector2i(-1, 0),
	Vector2i(-1, 1),
	Vector2i(0, -1),
	Vector2i(0, 1),
	Vector2i(1, -1),
	Vector2i(1, 0),
	Vector2i(1, 1)
]

static var monsterData:Dictionary = {
	0:{
		"power": 4,
		"type": 1
	},
	1:{
		"power": 4,
		"type": 2
	},
	2:{
		"power": 4,
		"type": 3
	},
	3:{
		"power": 3,
		"type": 0
	},
	4:{
		"power": 1,
		"type": 1,
		"ability": 1
	},
	5:{
		"power": 3,
		"type": 2
	}
}

var data:Dictionary
var pos:Vector2i
var isEnemy:bool

var power:int
var type:int
var ability:int


var layer:Node2D

@onready var redflag:Sprite2D = get_node("RedFlag")
@onready var greenflag:Sprite2D = get_node("GreenFlag")
@onready var powerLabel:Label = get_node("PowerLabel")

func _ready():
	pass
	#layer =get_parent() 

func init_show_only(_id:int):
	print(_id)
	_ready()
	self.show()
	if _id > -1 :
		id = _id
	data = monsterData[id]
	power = data["power"]
	type = data["type"]
	if data.has("ability"):
		ability = data["ability"]
	else:
		ability = 0
	
	var rollover = $Rollover
	rollover.hide()
	
	greenflag.hide()
	redflag.hide()
	self.position.x = 45
	self.position.y = 45
	powerLabel.text = str(power)
	

func init(_isEnemy:bool, _id:int, _pos:Vector2i = Vector2i(-1,-1)) -> Vector2i:
	#print(_isEnemy,_id)
	self.show()
	isEnemy = _isEnemy
	if _id > -1 :
		id = _id
	data = monsterData[id]
	power = data["power"]
	type = data["type"]
	if data.has("ability"):
		ability = data["ability"]
	else:
		ability = 0
	
	if isEnemy:
		redflag.show()
		greenflag.hide()
	else:
		greenflag.show()
		redflag.hide()
	powerLabel.text = str(power)
	
	var rollover = $Rollover
	rollover.mouse_entered.connect(showInfo)
	rollover.mouse_exited.connect(hideInfo)
	
	if _pos.x < 0:
		pos = Vector2i(int(self.position.x / 64),int(self.position.y / 64))
	else:
		pos = _pos
	self.position.x = pos.x * 64 + 32
	self.position.y = pos.y * 64 + 32
	return pos
	
func showInfo():
	var tooltip = $"../../Control/Tooltip"
	tooltip.show()
	tooltip.showInfo(Vector2(self.position),str(id))

func hideInfo():
	var tooltip = $"../../Control/Tooltip"
	tooltip.hide()

func refresh(_monsterDict:Dictionary):
	var monsterDict = _monsterDict
	var posArr = [
		Vector2i(pos.x - 1, pos.y - 1),
		Vector2i(pos.x - 1, pos.y),
		Vector2i(pos.x - 1, pos.y + 1),
		Vector2i(pos.x, pos.y - 1),
		Vector2i(pos.x, pos.y + 1),
		Vector2i(pos.x + 1, pos.y - 1),
		Vector2i(pos.x + 1, pos.y),
		Vector2i(pos.x + 1, pos.y + 1)
	]
	var powerMultiplier = Vector2i(0,1)
	for targetpos in posArr:
		if monsterDict.has(targetpos):
			var target_monster = monsterDict[targetpos]
			if target_monster.ability > 0:
				pass
				#target_monster
	power = data["power"]

func processAbility(target_monster):
	if target_monster.ability == 1:
		pass

func capture(_monsterDict:Dictionary) -> bool:
	if !isEnemy:
		return false
	var posArr = [
		Vector2i(pos.x - 1, pos.y),
		Vector2i(pos.x + 1, pos.y),
		Vector2i(pos.x, pos.y - 1),
		Vector2i(pos.x, pos.y + 1)
	]
	var monsterDict = _monsterDict
	for targetpos in posArr:
		if !monsterDict.has(targetpos):
			return false
		var pet = monsterDict[targetpos]
		if pet.isEnemy:
			return false
		if pet.power <= self.power:
			return false
	
	#isEnemy = false
	#greenflag.show()
	#redflag.hide()
	_monsterDict.erase(self)
	get_parent().remove_child(self)
	self.queue_free()
	return true
