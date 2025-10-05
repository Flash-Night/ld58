extends Camera2D

@export var game_control:Control
var player:Node2D

func _ready() -> void:
	player = get_parent().get_node("Player")

func _process(_delta: float) -> void:
	self.position.x += (player.position.x - self.position.x) * 0.05
	self.position.y += (player.position.y - self.position.y) * 0.05
