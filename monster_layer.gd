extends Node2D

var monsterList:Array[Node]
var petList:Array[Node]
var monsterDict:Dictionary

var monsterScene:PackedScene

func _ready() -> void:
	monsterScene = load("res://monster.tscn")
	monsterDict = {}
	petList = []
	monsterList = get_children(false)
	for _child in monsterList:
		var pos = _child.init(true, -1)
		monsterDict[pos] = _child

func addPet(id:int, pos:Vector2i) -> bool:
	if monsterDict.has(pos):
		return false
	var pet = monsterScene.instantiate()
	self.add_child(pet)
	pet.init(false, id, pos)
	petList.append(pet)
	monsterDict[pos] = pet
	refresh(pos)
	return true

func removeAllPets() -> Array:
	var arr = []
	for pet in petList:
		var pos = pet.pos
		arr.append(pet.id)
		monsterDict.erase(pos)
		remove_child(pet)
		pet.queue_free()
	petList = []
	return arr

func refresh(center:Vector2i) -> void:
	for dx in range(-1,2):
		for dy in range(-1,2):
			var pos = Vector2i(center.x + dx, center.y + dy)
			if(monsterDict.has(pos)):
				var c_monster = monsterDict[pos]
				c_monster.refresh()
	for monster in monsterList:
		monster.isCaptured()
