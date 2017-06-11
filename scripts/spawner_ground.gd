extends Node2D

const scn_ground = preload('res://scene/ground.tscn')
const groundWidth = 168
const fillView = 2

func _ready():
	for i in range(fillView):
		spawn_move()
	print('Ground Spawner is ready!')
	pass

func spawn_move():
	spwn_ground()
	nextPos()

func spwn_ground():
	var new_ground = scn_ground.instance()
	new_ground.set_pos(get_pos())
	new_ground.connect('exit_tree', self, "spawn_move")
	get_node("container").add_child(new_ground)
	pass

func nextPos():
	set_pos(get_pos()+Vector2(groundWidth,0))
	pass
