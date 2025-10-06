extends Sprite2D

@onready var anim:AnimationPlayer = $AnimationPlayer

func _ready() -> void:
	anim.animation_finished.connect(hideFinish)

func showLabel():
	self.show()
	anim.play("show")

func hideLabel():
	anim.play("hide")

func hideFinish(anim_name:String):
	if anim_name == "hide":
		self.hide()
