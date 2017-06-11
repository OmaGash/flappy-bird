extends CanvasLayer

const stage = 'res://stage/game_stage.tscn'
signal stageChanged
var isChanging = false

func _ready():
	
	pass

func changeStage(stagePath):
	if isChanging: return
	isChanging = true
	get_tree().get_root().set_disable_input(true)
	
	#Transistion (In)
	get_node("anim").play("in")
	yield(get_node("anim"), "finished")
	#Stage changing
	get_tree().change_scene(stagePath)
	emit_signal("stageChanged")
	#Transition (Out)
	get_node("anim").play("out")
	yield(get_node("anim"),"finished")
	isChanging = false
	get_tree().get_root().set_disable_input(false)
	pass
