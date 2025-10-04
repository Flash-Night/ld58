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
		var pos = _child.init(-1)
		monsterDict[pos] = _child

func addPet(pos:Vector2i) -> bool:
	if monsterDict.has(pos):
		return false
	var pet = monsterScene.instantiate()
	self.add_child(pet)
	pet.init(0)
	return true
