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
	var target_monster:Monster = monsterDict[pos]
	refresh_ability(pos,-1)
	monsterDict.erase(pos)
	refresh_ability(pos,1)
	refresh_power(pos)
	#remove_child(target_monster)
	#target_monster.queue_free()
	target_monster.get_node("GreenFlag").hide()
	target_monster.get_node("RedFlag").hide()
	target_monster.get_node("PowerLabel").hide()
	var speed = randf_range(0.5,1.0)
	var anim:AnimationPlayer = target_monster.get_node("AnimationPlayer")
	anim.play("remove",-1,speed)
	anim.animation_finished.connect(free_monster.bind(target_monster))

func free_monster(_anim_name:String, target_monster:Monster)->void:
	remove_child(target_monster)
	target_monster.queue_free()
	print("aa")

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
					
