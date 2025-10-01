extends Control

@export var startbutton:Button
@export var endbutton:Button

var mybutton:PackedScene
var count:int = 0

func _ready():
	#startbutton.text = "Click me"
	startbutton.pressed.connect(_start)
	endbutton.pressed.connect(_createMyButton)
	mybutton = load("res://mybutton.tscn")

func _start():
	print("helloworld")
	get_tree().change_scene_to_file("res://game.tscn")

func _createMyButton():
	if count < 10:
		var mbinst = mybutton.instantiate()
		add_child(mbinst)
		mbinst.position.x = 50
		mbinst.position.y = 70 * count
		count += 1
