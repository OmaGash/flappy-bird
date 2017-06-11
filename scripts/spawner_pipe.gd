extends Node2D

const scn_pipe = preload("res://scene/pipe.tscn")
const pipeWidth = 26
const groundHeight = 56
const offset_y = 55
const offset_x = 65
const fillView = 3

func _ready():
	var bird = utils.get_main_node().get_node("bird")
	if bird:
		bird.connect("stateChanged", self, "_on_bird_state_changed", [], CONNECT_ONESHOT)
	pass

func _on_bird_state_changed(bird):
	if bird.getState() == bird.State_Flap:
		start()
	pass

func start():
	initPos()
	for i in range(fillView):
		spawn_move()
	pass

func initPos():
	randomize()
	var initPos = Vector2()
	initPos.x = get_viewport_rect().size.width + pipeWidth/2
	initPos.y = rand_range(0+offset_y,get_viewport_rect().size.height-groundHeight-offset_y)
	
	
	var camera = utils.get_main_node().get_node("camera")
	if camera:
		initPos.x += camera.get_total_pos().x
	set_pos(initPos)
	pass

func spawn_move():
	spawn_pipe()
	nextPos()

func spawn_pipe():
	var new_pipe = scn_pipe.instance()
	new_pipe.set_pos(get_pos())
	new_pipe.connect("exit_tree",self,"spawn_move")
	get_node("container").add_child(new_pipe)
	pass

func nextPos():
	randomize()
	var nextPos = get_pos()
	nextPos.x += pipeWidth/2 + offset_x +pipeWidth/2
	nextPos.y = rand_range(0+offset_y,get_viewport_rect().size.height-groundHeight-offset_y)
	set_pos(nextPos)
	pass
