extends Control

@export var startbutton:Button

func _ready():
	startbutton.text = "Click me"
	startbutton.pressed.connect(_start)

func _start():
	print("helloworld")
	get_tree().change_scene_to_file("res://game.tscn")
