extends Node2D

#var monsterList:Array[Node]
var petList:Array[Node]
var monsterDict:Dictionary

var monsterScene:PackedScene

@onready var monsterControl = $"../Control"

func _ready() -> void:
	monsterScene = load("res://monster.tscn")
	monsterDict = {}
	petList = []
	var monsterList = get_children(false)
	for _child in monsterList:
		var p=_child.position
		var pos = Vector2i(floor(p.x / 64),floor(p.y / 64))
		refresh_ability(pos,-1)
		_child.init(true, -1, monsterDict,pos)
		monsterDict[pos] = _child
		refresh_ability(pos,1)
		refresh_power(pos)

func addPet(id:int, pos:Vector2i) -> bool:
	if monsterDict.has(pos):
		return false
	
	
	refresh_ability(pos,-1)
	
	var pet = monsterScene.instantiate()
	self.add_child(pet)
	petList.append(pet)
	monsterDict[pos] = pet
	pet.init(false, id, monsterDict, pos)
	
	
	refresh_ability(pos,1)
	refresh_power(pos)
	
	
	#pet.refresh()
	return true

func removeAllPets() -> Array:
	var arr = []
	for pet in petList:
		var pos = pet.pos
		arr.append(pet.id)
		remove_with_pos(pos)
	petList = []
	return arr

func remove_with_pos(pos:Vector2i)->void:
	var target_monster = monsterDict[pos]
	refresh_ability(pos,-1)
	monsterDict.erase(pos)
	remove_child(target_monster)
	target_monster.queue_free()
	refresh_ability(pos,1)
	refresh_power(pos)
	

func refresh_ability(pos:Vector2i,x:int) -> void:
	for dx in range(-1,2):
		for dy in range(-1,2):
			var targetpos = pos + Vector2i(dx,dy)
			if monsterDict.has(targetpos):
				var target_monster = monsterDict[targetpos]
				target_monster.update_ability(x)
				
func refresh_power(pos:Vector2i) -> void:
	for dx in range(-2,3):
		for dy in range(-2,3):
			var targetpos = pos + Vector2i(dx,dy)
			if monsterDict.has(targetpos):
				var target_monster = monsterDict[targetpos]
				target_monster.update_power()
	for dx in range(-2,3):
		for dy in range(-2,3):
			var targetpos = pos + Vector2i(dx,dy)
			if monsterDict.has(targetpos):
				var target_monster = monsterDict[targetpos]
				if target_monster.capture():	
					var id=target_monster.id
					monsterControl.using_pets_id[id]=id
					monsterControl.pets_used[id]=false
					monsterControl.control.show_button_monster(id,id)
					remove_with_pos(targetpos)
					
