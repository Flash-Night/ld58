extends Control

@onready var game_control:Control = $"..".game_control

@onready var page_button_l=$Button
@onready var page_button_r=$Button2
var selecting:int
var buttons:Array[Control]
var max_using = 10 # 8
var max_page = 2
var now_page:int
var scene :PackedScene
func _ready() -> void:
	if scene != null:
		return
	scene = preload("res://card_button.tscn")
	#for j in range(max_page):
		#for i in range(max_using):
			#buttons.append(scene.instantiate()) 
			#var k=j*max_using +i
			#add_child(buttons[k])
			#buttons[k].position.x=-600+i*100
			#buttons[k].position.y=250
			#buttons[k].z_index=20
			#buttons[k].hide()
	for i in range(max_using):
		var btn = scene.instantiate()
		buttons.append(btn) 
		self.add_child(btn)
		btn.position.x = -625 + i * 140
		btn.position.y = 220
		#buttons[i].hide()
		if btn.init(game_control, i):
			var section:float = 1 - i * 0.1
			btn.initAnimation(section)
		btn.btn.button_down.connect(bplace.bind(btn))
	now_page=0
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


func bplace(button)->void:
	game_control.place_tile_buttons(button.id)
		
func show_button_monster (x:int,id:int)->void:
	buttons[x].init(game_control, id)
	buttons[x].mouseExit()
	
#func _process(_delta: float) -> void:
	#pass
	#selecting=0
	#for i in range(max_using*max_page):
		#if buttons[i].button_pressed:
			#selecting=i
