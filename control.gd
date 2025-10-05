extends Control

@export var game_control:Control

@onready var page_button_l=$Button
@onready var page_button_r=$Button2
var selecting:int
var buttons:Array[Button]
var max_using = 8
var max_page = 2
var now_page:int
var scene :PackedScene
func _ready() -> void:
	if scene!= null:
		return
	scene=preload("res://monster_using.tscn")
	for j in range(max_page):
		for i in range(max_using):
			buttons.append(scene.instantiate()) 
			var k=j*max_using +i
			add_child(buttons[k])
			buttons[k].position.x=-600+i*100
			buttons[k].position.y=250
			buttons[k].z_index=20
			buttons[k].hide()
	now_page=0
	for i in range(max_using):
		buttons[i].show()
	page_button_l.pressed.connect(switch_page.bind(-1))
	page_button_r.pressed.connect(switch_page.bind(1))
func switch_page(x:int)->void:
	var next_page=now_page+x
	if next_page>=max_page:
		next_page-=max_page
	if next_page<0:
		next_page+=max_page
	for i in range(max_using):
		buttons[now_page*max_using+i].hide()
	for i in range(max_using):
		buttons[next_page*max_using+i].show()
	now_page=next_page

func bconnect()->void:
	_ready()
	for i in range(max_using):
		buttons[i].button_down.connect(Callable(game_control,"place_tile_buttons"))
		
func show_button_monster (x:int,id:int)->void:
	_ready()
	var monster=buttons[x].get_node("Monster")
	monster.init_show_only(id)
	
func _process(_delta: float) -> void:
	#selecting=0
	for i in range(max_using):
		if buttons[i].button_pressed:
			selecting=i
