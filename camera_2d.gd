extends Camera2D

@export var game_control:Control
@onready var bg:Sprite2D = $White
var mat:ShaderMaterial
var player:Node2D
var threshold:float
var edge_hardness:float

func _ready() -> void:
	self.position.x = -256
	self.position.y = -256
	mat = bg.material
	#print(bg,mat)
	threshold = 1.0
	edge_hardness = 1.0
	mat.set_shader_parameter("cloud_threshold", threshold)
	mat.set_shader_parameter("edge_hardness", edge_hardness)
	player = get_parent().get_node("Player")

func _process(_delta: float) -> void:
	if threshold > 0.5:
		threshold -= 0.005
		edge_hardness += 0.01
		mat.set_shader_parameter("cloud_threshold", threshold)
		mat.set_shader_parameter("edge_hardness", edge_hardness)
	self.position.x += (player.position.x - self.position.x) * 0.05
	self.position.y += (player.position.y + 32 - self.position.y) * 0.05
