extends Node2D

var monsterList:Array[Node]
var monsterDict:Dictionary

func _ready() -> void:
	monsterDict = {}
	monsterList = get_children(false)
	for _child in monsterList:
		var pos = _child.init()
		monsterDict[pos] = _child
