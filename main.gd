extends Control

@export var startbutton:Button

func _ready():
	startbutton.text = "Click me"
	startbutton.pressed.connect(_button_pressed)

func _button_pressed():
	print("Hello world!")
