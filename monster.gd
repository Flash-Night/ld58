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

static var powerChange:PackedScene = load("res://power_change_effect.tscn")

static var icons:Array[Texture2D] = [
	load("res://images/icons/逆时雨.png"),
	load("res://images/icons/弥烖兵.png"),
	load("res://images/icons/宁风旱.png"),
	load("res://images/icons/祈福祥.png"),
	load("res://images/icons/诸怀.png"), #4
	load("res://images/icons/寄生.png"),
	load("res://images/icons/虺蛇.png"),
	load("res://images/icons/鬼虎.png"),
	load("res://images/icons/肥遗.png"),
	load("res://images/icons/蛊疫.png"), #9
	load("res://images/icons/寄生.png"), #10
	load("res://images/icons/鬼虎.png"),
	load("res://images/icons/鬼虎.png"),
	load("res://images/icons/肥遗.png"),
	load("res://images/icons/蛊疫.png"), #14
	load("res://images/icons/祈福祥.png"), #15
	load("res://images/icons/逆时雨.png"),
	load("res://images/icons/弥烖兵.png"),
	load("res://images/icons/宁风旱.png"),
	load("res://images/icons/taiji.png")
]

static var monsterData:Dictionary = {
	0:{
		"name": "逆时雨",
		"name_en": "Ni Shi Yu",
		"power": 4,
		"type": 1,
		"description": "化祝为兽，为老巫觋所赠。\n“雨顺时康，蛮荒草木遍芬芳。”",
		"description_en": "A monster born from a wish, given by Wu Xi as a gift. \"May seasonal rains bring timely health, and wild plants and grasses bloom with fragrant wealth.\""
	},
	1:{
		"name": "弥烖兵",
		"name_en": "Mi Zai Bing",
		"power": 4,
		"type": 2,
		"description": "化祝为兽，为老巫觋所赠。\n“消灾厄，弥贼兵，祸乱兹息。”",
		"description_en": "A monster born from a wish, given by Wu Xi as a gift. \"Ward off disasters and woes, thwart enemy hordes, so turmoil ceases and peace is restored.\""
	},
	2:{
		"name": "宁风旱",
		"name_en": "Nin Feng Han",
		"power": 4,
		"type": 3,
		"description": "化祝为兽，为老巫觋所赠。\n“瑞祝通天，免有风旱涤山川。”",
		"description_en": "A monster born from a wish, given by Wu Xi as a gift. \"May sacred prayers reach heaven’s gate, sparing the land from storms or drought, cleansing mountains and rivers’ state.\""
	},
	3:{
		"name": "祈福祥",
		"name_en": "Qi Fu Xiang",
		"power": 3,
		"type": 0,
		"description": "化祝为兽，为老巫觋所赠。\n“上祈福祥，尚使丰穰能出云。”",
		"description_en": "A monster born from a wish, given by Wu Xi as a gift. \"We pray for blessings from above, that clouds may yield abundant harvests, filled with grace and love.\""
	},
	4:{
		"name": "诸怀",
		"name_en": "Zhu Huai",
		"power": 3,
		"type": 1,
		"ability": 1,
		"description": "牛四角人目彘耳，是则害人。\n周围四格所有怪物力量+1",
		"description_en": "A murderous monster with four horns, thick nostrils, human eyes, and pig ears. \nAll orthogonally adjacent units power+1"
	},
	5:{
		"name": "寄生",
		"name_en": "Ji Sheng",
		"power": 3,
		"type": 3,
		"ability": 2,
		"description": "附皮毛施于血肉，葳蕤四垂。\n周围四格有水属性怪物时，自身力量+1",
		"description_en": "A polymeric substance attaching to fur, nourished by blood and flesh, with stems slender and dense. \nPower+1 when orthogonally adjacent to water units"
	},
	6:{
		"name": "虺蛇",
		"name_en": "Hui She",
		"power": 3,
		"type": 1,
		"ability": 6,
		"description": "博三寸，首大如擘，牙最毒。\n周围八格所有水属性怪物力量+1",
		"description_en": " A three-inches wide snake. Its head is as big as a split horn with extremely poisonous fangs. \nAll surrounding water units power+1"
	},
	7:{
		"name": "鬼虎",
		"name_en": "Gui Hu",
		"power": 3,
		"type": 2,
		"ability": 3,
		"description": "有青兽，人面虎身，是食人。\n周围四格所有草属性怪物力量-1",
		"description_en": "A green beast with human face and tiger body, which likes to eat people. \nAll orthogonally adjacent nature units power-1"
	},
	8:{
		"name": "肥遗",
		"name_en": "Fei Yi",
		"power": 3,
		"type": 2,
		"ability": 0,
		"description": "蛇六足四翼者，主千里大旱。\n飞行",
		"description_en": "A snake with six legs and four wings, indicating a severe drought of a thousand miles. \nFlying"
	},
	9:{
		"name": "蛊疫",
		"name_en": "Gu Yi",
		"power": 3,
		"type": 3,
		"ability": 5,
		"description": "皿虫而俾相啖，其存者为蛊。\n周围8格同时有水火草三种属性怪物时，自身力量加1倍",
		"description_en": "The survivor of insects cannibalizing each other on a dish called Gu. \nPower+100% if surrounding by water, nature and fire units"
	},
	10:{
		"name": "寄生",
		"name_en": "Ji Sheng",
		"power": 3,
		"type": 3,
		"ability": 9,
		"description": "附皮毛施于血肉，葳蕤四垂。\n周围八格所有草属性怪物力量+1，且每有一个草属性自身力量+1",
		"description_en": "A polymeric substance attaching to fur, nourished by blood and flesh, with stems slender and dense. Surrounding nature units power +1 and make self power +1"
	},
	11:{
		"name": "鬼虎",
		"name_en": "Gui Hu",
		"power": 3,
		"type": 2,
		"ability": 10,
		"description": "有青兽，人面虎身，是食人。\n周围八格存在2个或以上火属性怪物时，周围八格怪物力量-1",
		"description_en": "A green beast with human face and tiger body, which likes to eat people. \nIf surrounded by 2 or more fire units, all surrounding units power-1"
	},
	12:{
		"name": "鬼虎",
		"name_en": "Gui Hu",
		"power": 4,
		"type": 2,
		"ability": 11,
		"description": "有青兽，人面虎身，是食人。\n周围八格存在2个或以上火属性怪物时，力量+1",
		"description_en": "A green beast with human face and tiger body, which likes to eat people. \nIf surrounded by 2 or more fire units, self power+1"
	},
	13:{
		"name": "肥遗",
		"name_en": "Fei Yi",
		"power": 4,
		"type": 2,
		"ability": 8,
		"description": "蛇六足四翼者，主千里大旱。\n飞行，周围4格力量加1倍",
		"description_en": "A snake with six legs and four wings, indicating a severe drought of a thousand miles. \nFlying, all orthogonally adjacent units power+100%"
	},
	14:{
		"name": "蛊疫",
		"name_en": "Gu Yi",
		"power": 2,
		"type": 3,
		"ability": 16,
		"description": "皿虫而俾相啖，其存者为蛊。\n飞行，周围8格同时有水火草三种属性怪物时，周围8格力量-1",
		"description_en": "The survivor of insects cannibalizing each other on a dish called Gu. \nFlying, surrounding units power -1 if surrounding by water, nature and fire units"
	},
	15:{
		"name": "祈福祥……？",
		"name_en": "Qi Fu Xiang...?",
		"power": 2,
		"type": 0,
		"ability": 12,
		"description": "那不是我的造物吗……？\n飞行，周围八格所有无属性怪物力量+1",
		"description_en": "Isn't that my creature...? \nFlying, all surronding neutral units power+1"
	},
	16:{
		"name": "逆时雨……？",
		"name_en": "Ni Shi Yu...?",
		"power": 2,
		"type": 1,
		"ability": 13,
		"description": "那不是我的造物吗……？\n飞行，周围八格所有水属性怪物力量+1",
		"description_en": "Isn't that my creature...? \nFlying, all surronding water units power+1"
	},
	17:{
		"name": "弥烖兵……？",
		"name_en": "Mi Zai Bing...?",
		"power": 2,
		"type": 2,
		"ability": 14,
		"description": "那不是我的造物吗……？\n飞行，周围八格所有火属性怪物力量+1",
		"description_en": "Isn't that my creature...? \nFlying, all surronding fire units power+1"
	},
	18:{
		"name": "宁风旱……？",
		"name_en": "Nin Feng Han...?",
		"power": 2,
		"type": 3,
		"ability": 15,
		"description": "那不是我的造物吗……？\n飞行，周围八格所有草属性怪物力量+1",
		"description_en": "Isn't that my creature...? \nFlying, all surronding nature units power+1"
	},
	19:{
		"name": "？？？",
		"name_en": "???",
		"power": 2,
		"type": 0,
		"ability": 7,
		"description": "？？？？？ \n周围8格每个属性使自身力量+1",
		"description_en": "????? \nEvery type of surronding units make this unknown creature power+1"
	},
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
#@onready var typeRect:ColorRect = get_node("TypeRect")

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
	type = data["type"]
	if type == 1:
		powerLabel.add_theme_color_override("font_color", Color(0,0.5,1,1))
	elif type == 2:
		powerLabel.add_theme_color_override("font_color", Color(1,0.25,0,1))
	elif type == 3:
		powerLabel.add_theme_color_override("font_color", Color(0,1,0.5,1))
	
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
	

func init(_isEnemy:bool, _id:int, _monsterDict, _pos:Vector2i = Vector2i.MIN) -> Vector2i:
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
	
	var icon:Sprite2D = $Icon
	icon.texture = icons[id]
	
	type = data["type"]
	if type == 1:
		powerLabel.add_theme_color_override("font_color", Color(0,0.5,1,1))
	elif type == 2:
		powerLabel.add_theme_color_override("font_color", Color(1,0.25,0,1))
	elif type == 3:
		powerLabel.add_theme_color_override("font_color", Color(0,1,0.5,1))
	
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
	
	if _pos.x < -999:
		pos = Vector2i(floor(self.position.x / 64),floor(self.position.y / 64))
	else:
		pos = _pos
	self.position.x = pos.x * 64 + 32
	self.position.y = pos.y * 64 + 32
	
	#self.refresh()
	return pos
	
func showInfo():
	Game.tooltip.showDescription(data)


func hideInfo():
	var tooltip = Game.tooltip
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
		var addx=0
		for rpos in pos4:
			if monsterDict.has(pos + rpos):
				var targetmonster = monsterDict[pos + rpos]
				if targetmonster.type == 1:
					addx= 1
		self.powerAdder+=addx*x
	elif self.ability == 3:
		for rpos in pos4:
			if monsterDict.has(pos + rpos):
				var targetmonster = monsterDict[pos + rpos]
				if targetmonster.type == 3:
					targetmonster.powerAdder -= 1*x
	elif self.ability == 4:
		for rpos in pos4:
			if monsterDict.has(pos + rpos):
				var targetmonster = monsterDict[pos + rpos]
				if targetmonster.type == 1:
					self.powerAdder += 1*x
	elif self.ability == 5:
		var has:Array[bool]
		for i in range(4):
			has.append(false)
		for rpos in pos8:
			if monsterDict.has(pos + rpos):
				var targetmonster = monsterDict[pos + rpos]
				has[targetmonster.type]= true
		if has[1] && has[2] && has[3] :
			self.powerMultiplier+= 1*x
	elif self.ability == 6:
		for rpos in pos8:
			if monsterDict.has(pos + rpos):
				var targetmonster = monsterDict[pos + rpos]
				if targetmonster.type == 1:
					targetmonster.powerAdder += 1*x
	elif self.ability == 7:
		var has:Array[bool]
		for i in range(4):
			has.append(false)
		for rpos in pos8:
			if monsterDict.has(pos + rpos):
				var targetmonster = monsterDict[pos + rpos]
				has[targetmonster.type]= true
		for i in range(4):
			if has[i] :
				self.powerAdder+= 1*x
	if self.ability == 8:
		for rpos in pos4:
			if monsterDict.has(pos + rpos):
				var targetmonster = monsterDict[pos + rpos]
				targetmonster.powerMultiplier+=1*x
	elif self.ability == 9:
		for rpos in pos8:
			if monsterDict.has(pos + rpos):
				var targetmonster = monsterDict[pos + rpos]
				if targetmonster.type == 3:
					self.powerAdder += 1*x
					targetmonster.powerAdder += 1*x
	elif self.ability == 10:
		var countF=0
		for rpos in pos8:
			if monsterDict.has(pos + rpos):
				var targetmonster = monsterDict[pos + rpos]
				if targetmonster.type == 2:
					countF+=1
		if countF>=2:
			for rpos in pos8:
				if monsterDict.has(pos + rpos):
					var targetmonster = monsterDict[pos + rpos]
					targetmonster.powerAdder -= 1*x
	elif self.ability == 11:
		var countF=0
		for rpos in pos8:
			if monsterDict.has(pos + rpos):
				var targetmonster = monsterDict[pos + rpos]
				if targetmonster.type == 2:
					countF+=1
		if countF>=2:
			self.powerAdder+=1*x
	elif self.ability == 12:
		for rpos in pos8:
			if monsterDict.has(pos + rpos):
				var targetmonster = monsterDict[pos + rpos]
				if targetmonster.type == 0:
					targetmonster.powerAdder += 1*x
	elif self.ability == 13:
		for rpos in pos8:
			if monsterDict.has(pos + rpos):
				var targetmonster = monsterDict[pos + rpos]
				if targetmonster.type == 1:
					targetmonster.powerAdder += 1*x
	elif self.ability == 14:
		for rpos in pos8:
			if monsterDict.has(pos + rpos):
				var targetmonster = monsterDict[pos + rpos]
				if targetmonster.type == 2:
					targetmonster.powerAdder += 1*x
	elif self.ability == 15:
		for rpos in pos8:
			if monsterDict.has(pos + rpos):
				var targetmonster = monsterDict[pos + rpos]
				if targetmonster.type == 3:
					targetmonster.powerAdder += 1*x
	elif self.ability == 16:
		var has:Array[bool]
		for i in range(4):
			has.append(false)
		for rpos in pos8:
			if monsterDict.has(pos + rpos):
				var targetmonster = monsterDict[pos + rpos]
				has[targetmonster.type]= true
		if has[1] && has[2] && has[3] :
			for rpos in pos8:
				if monsterDict.has(pos + rpos):
					var targetmonster = monsterDict[pos + rpos]
					targetmonster.powerAdder -= 1*x
			
		
func update_power()->void:
	var dpower = power
	power=basepower*powerMultiplier+powerAdder
	powerLabel.text = str(power)
	if power != dpower:
		var pc = powerChange.instantiate()
		get_parent().add_child(pc)
		pc.start(self.position.x, self.position.y, power - dpower)
	
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
