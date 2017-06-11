
extends RigidBody2D
#This is for the bird lol
onready var state = FlyingState.new(self)
const State_Fly = 0
const State_Flap = 1
const State_Hit = 2
const State_Ground = 3
const Speed = 50

signal stateChanged

func _ready():
	
	set_fixed_process(true)
	set_process_input(true)
	set_process_unhandled_input(true)
	add_to_group(game.Group_Birds)
	
	connect("body_enter",self,"bodyEnter")
	print("Bird is ready!")
	pass

func _fixed_process(delta):
	state.update(delta)
	pass



func _input(event):
	state.input(event)
	
	pass

func _unhandled_input(event):
	if state.has_method('unhandled_input'):
		state.unhandled_input(event)

func bodyEnter(otherBody):
	if state.has_method("bodyEnter"):
		state.bodyEnter(otherBody)
	pass

func set_state(new_state):
	state.exit()
	
	if new_state == State_Fly:
		state = FlyingState.new(self)
	elif new_state == State_Flap:
		state = FlappingState.new(self)
	elif new_state == State_Hit:
		state = HitState.new(self)
	elif new_state == State_Ground:
		state = GroundedState.new(self)
	
	emit_signal("stateChanged",self)
	pass

func getState():
	if state extends FlyingState:
		return State_Fly
	elif state extends FlappingState:
		return State_Flap
	elif state extends HitState:
		return State_Hit
	elif state extends GroundedState:
		return State_Ground


#Flying State--------------------------------------------------------------------------------------
class FlyingState:
	var bird
	var prevGravity
	func _init(bird):
		self.bird = bird
		bird.set_linear_velocity(Vector2(bird.Speed,bird.get_linear_velocity().y))
		bird.get_node("anim").play("flying")
		prevGravity = bird.get_gravity_scale()
		bird.set_gravity_scale(0)
		pass
	
	func update(delta):
		pass
	
	func input(event):
		pass
	
	func exit():
		bird.set_gravity_scale(prevGravity)
		bird.get_node("anim").stop()
		bird.get_node("animSprite").set_pos(Vector2(0,0))
		pass
#Flapping State--------------------------------------------------------------------------------------
class FlappingState:
	var bird
	
	
	func _init(bird):
		self.bird = bird
		bird.set_linear_velocity(Vector2(bird.Speed,bird.get_linear_velocity().y))
		flap()
		pass
	
	func update(delta):
		if rad2deg(bird.get_rot()) > 30:
			bird.set_rot(deg2rad(30))
			bird.set_angular_velocity(0)
	
		if bird.get_linear_velocity().y > 0:
			bird.set_angular_velocity(1.5)
		pass
	
	func input(event):
		if event.is_action_pressed("flap"):# or InputEvent.SCREEN_TOUCH:
			flap()
			print("space key is pressed")
		
		if event.is_action_pressed("boost"):
			boost()
		pass
	
	func unhandled_input(event):
		if event.type != InputEvent.MOUSE_BUTTON or !event.is_pressed() or event.is_echo() : return
		
		if event.button_index == BUTTON_LEFT:
			flap()
			
	func bodyEnter(otherBody):
		if otherBody.is_in_group(game.Group_Pipes):
			print('Bird Crashed!!! :(')
			bird.set_state(bird.State_Hit)
		elif otherBody.is_in_group(game.Group_Grounds):
			print('Mayday Mayday!!! X_X')
			bird.set_state(bird.State_Ground)
		pass
	
	func boost():
		bird.set_linear_velocity(Vector2(150,bird.get_linear_velocity().y))
		bird.set_angular_velocity(-3)
		bird.get_node("anim").play("flap")
		pass
	
	func flap():
		bird.set_linear_velocity(Vector2(bird.get_linear_velocity().x,-150))
		bird.set_angular_velocity(-3)
		bird.get_node("anim").play("flap")
		pass
	
	func exit():
		pass
#Hit State--------------------------------------------------------------------------------------
class HitState:
	var bird
	
	
	func _init(bird):
		self.bird = bird
		bird.set_linear_velocity(Vector2(0,0))
		bird.set_angular_velocity(2)
		
		var otherBody = bird.get_colliding_bodies()[0]
		bird.add_collision_exception_with(otherBody)
		pass
	
	func update(delta):
		pass
	
	func input(event):
		pass
	
	func bodyEnter(otherBody):
		if otherBody.is_in_group(game.Group_Grounds):
			bird.set_state(bird.State_Ground)
		pass
	
	func exit():
		pass
#Grounded State--------------------------------------------------------------------------------------
class GroundedState:
	var bird
	
	
	func _init(bird):
		self.bird = bird
		bird.set_linear_velocity(Vector2(0,0))
		bird.set_angular_velocity(0)
		print('grounded')
		pass
	
	func update(delta):
		pass
	
	func input(event):
		pass
	
	func exit():
		pass