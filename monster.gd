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
static var pos9 = [
	Vector2i(-1, -1),
	Vector2i(-1, 0),
	Vector2i(-1, 1),
	Vector2i(0, -1),
	Vector2i(0, 0),
	Vector2i(0, 1),
	Vector2i(1, -1),
	Vector2i(1, 0),
	Vector2i(1, 1)
]

static var monsterData:Dictionary = {
	0:{
		"power": 4,
		"type": 1,
		"description": "Water"
	},
	1:{
		"power": 4,
		"type": 2,
		"description": "Fire"
	},
	2:{
		"power": 4,
		"type": 3,
		"description": "Nature"
	},
	3:{
		"power": 3,
		"type": 0,
		"description": "None"
	},
	4:{
		"power": 1,
		"type": 1,
		"ability": 1,
		"description": "Water, all adjacent units power+1"
	},
	5:{
		"power": 3,
		"type": 3,
		"ability": 2,
		"description": "Nature, power+1 when next to water unit"
	},
	6:{
		"power": 3,
		"type": 2,
		"ability": 3,
		"description": "Fire, all adjacent nature units power-1"
	}
}

var data:Dictionary
var pos:Vector2i
var isEnemy:bool

var power:int
var type:int
var ability:int
var enableAbility:bool = false
var basepower:int
var powerAdder:int
var powerMultiplier:int

var monsterDict

var layer:Node2D

@onready var redflag:Sprite2D = get_node("RedFlag")
@onready var greenflag:Sprite2D = get_node("GreenFlag")
@onready var powerLabel:Label = get_node("PowerLabel")
@onready var typeRect:ColorRect = get_node("TypeRect")

func _ready():
	pass
	#layer =get_parent() 

func init_show_only(_id:int):
	#print(_id)
	_ready()
	self.show()
	if _id > -1 :
		id = _id
	data = monsterData[id]
	power = data["power"]
	type = data["type"]
	if type == 1:
		typeRect.color = Color(0,0.5,1,1)
	elif type == 2:
		typeRect.color = Color(1,0.25,0,1)
	elif type == 3:
		typeRect.color = Color(0,1,0.5,1)
	else:
		typeRect.color = Color(1,1,1,1)
	
	if data.has("ability"):
		ability = data["ability"]
	else:
		ability = 0
	enableAbility = false
	
	var rollover = $Rollover
	rollover.hide()
	
	greenflag.hide()
	redflag.hide()
	self.position.x = 45
	self.position.y = 45
	powerLabel.text = str(power)
	

func init(_isEnemy:bool, _id:int, _monsterDict, _pos:Vector2i = Vector2i(-1,-1)) -> Vector2i:
	#print(_isEnemy,_id)
	self.show()
	isEnemy = _isEnemy
	if _id > -1 :
		id = _id
	monsterDict = _monsterDict
	data = monsterData[id]
	
	powerAdder = 0
	powerMultiplier = 1
	basepower = data["power"]
	power=basepower
	
	type = data["type"]
	if type == 1:
		typeRect.color = Color(0,0.5,1,1)
	elif type == 2:
		typeRect.color = Color(1,0.25,0,1)
	elif type == 3:
		typeRect.color = Color(0,1,0.5,1)
	else:
		typeRect.color = Color(1,1,1,1)
	
	if data.has("ability"):
		ability = data["ability"]
	else:
		ability = 0
	enableAbility = false
	
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
	
	#self.refresh()
	return pos
	
func showInfo():
	var tooltip = $"../../Control/Tooltip"
	tooltip.show()
	tooltip.showInfo(Vector2(self.position),data["description"])

func hideInfo():
	var tooltip = $"../../Control/Tooltip"
	tooltip.hide()

#func refresh():
	#for rpos in pos9:
		#var targetpos = self.pos + rpos
		#if monsterDict.has(targetpos):
			#var target_monster = monsterDict[targetpos]
			#if target_monster.ability > 0:
				#target_monster.checkAbility()
	#for dx in range(-2,3):
		#for dy in range(-2,3):
			#var targetpos = pos + Vector2i(dx,dy)
			#if monsterDict.has(targetpos):
				#var target_monster = monsterDict[targetpos]
				#target_monster.processAbilities()
#
#
#func checkAbility():
	#if self.ability == 1:
		#self.enableAbility = true
		
#func processAbilities():
	#powerAdder = 0
	#powerMultiplier = 1
	#for rpos in pos8:
		#if monsterDict.has(pos + rpos):
			#var targetmonster = monsterDict[pos + rpos]
			#if targetmonster.enableAbility:
				#processAbility(targetmonster.ability)
				#
		#for rpos in pos4:
			#var targetpos = pos + rpos
#
#func processAbility(targetAbility:int):
	#pass

func update_ability(x:int)->void:
	#print(x)
	if self.ability == 1:
		for rpos in pos4:
			if monsterDict.has(pos + rpos):
				var targetmonster = monsterDict[pos + rpos]
				targetmonster.powerAdder+=1*x
	elif self.ability == 2:
		for rpos in pos4:
			if monsterDict.has(pos + rpos):
				var targetmonster = monsterDict[pos + rpos]
				if targetmonster.type == 1:
					self.powerAdder += 1*x
	elif self.ability == 3:
		for rpos in pos4:
			if monsterDict.has(pos + rpos):
				var targetmonster = monsterDict[pos + rpos]
				if targetmonster.type == 3:
					targetmonster.powerAdder -= 1*x
		
func update_power()->void:
	power=basepower*powerMultiplier+powerAdder
	powerLabel.text = str(power)
func capture() -> bool:
	if !isEnemy:
		return false
	var posArr = [
		Vector2i(pos.x - 1, pos.y),
		Vector2i(pos.x + 1, pos.y),
		Vector2i(pos.x, pos.y - 1),
		Vector2i(pos.x, pos.y + 1)
	]
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
	return true
