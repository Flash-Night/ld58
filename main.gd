extends Control

@onready var startbutton:TextureButton = $Button
@onready var anim:AnimationPlayer = $AnimationPlayer

#var mybutton:PackedScene
var game:PackedScene

func _ready():
	#startbutton.text = "Click me"
	game = preload("res://game.tscn")
	startbutton.pressed.connect(_start)
	anim.animation_finished.connect(switchScene)
	#endbutton.pressed.connect(_createMyButton)
	#mybutton = load("res://mybutton.tscn")

func _start():
	startbutton.hide()
	anim.play("fade")

func switchScene(_anim_name:String):
	get_tree().change_scene_to_packed(game)
