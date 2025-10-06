extends PanelContainer

@onready var content:RichTextLabel = $Content

func _ready():
	Game.tooltip = self
	hide()

func showDescription(data:Dictionary):
	self.show()
	#self.position = pos + Vector2(20,20)
	var text
	if Game.language_en:
		text = data["description_en"]
	else:
		text = data["description"]
	content.text = text
