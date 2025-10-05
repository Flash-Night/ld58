extends PanelContainer

@onready var content:RichTextLabel = $Content

func _ready():
	hide()

func showInfo(pos:Vector2,text:String):
	self.position = pos + Vector2(20,20)
	content.text = text
