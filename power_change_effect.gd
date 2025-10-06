extends Node2D

func start(x:float,y:float,val:int) -> void:
	self.position.x = x + randi_range(-5,5)
	self.position.y = y + randi_range(-35,-25)
	var label = $Label
	var txt = str(val)
	if val > 0:
		txt = "+" + txt
		label.add_theme_color_override("font_color",Color.GREEN)
	label.text = txt
	var anim = $AnimationPlayer
	anim.play("powerchange")
	anim.animation_finished.connect(destroy)

func destroy(_anim_name) -> void:
	get_parent().remove_child(self)
	self.queue_free()
