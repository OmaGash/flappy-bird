extends Node

const Group_Pipes = "pipes"
const Group_Grounds = "grounds"
const Group_Birds = "birds"

const Bronze = 10
const Silver = 20
const Gold = 30
const Platinum = 40

var score = 0 setget _set_score
var score_hi = 0 setget _set_best

signal score_changed
signal best_changed

func _ready():
	stage_manager.connect('stageChanged',self,'_stageChanged')
	connect("best",self,"_bestPressed")
	pass

func _stageChanged():
	score = 0
	pass

func _set_best(newValue):
	if newValue > score_hi:
		score_hi = newValue
		emit_signal("best_changed")
	pass

func _set_score(newValue):
	score = newValue
	emit_signal("score_changed")
	pass

func _bestPressed():
	score = 999
	pass
