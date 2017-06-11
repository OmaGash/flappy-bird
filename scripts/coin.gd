extends Area2D



func _ready():
	connect("body_enter",self,"bodyEnter")
	print('Coin has been spawned!')
	pass

func bodyEnter(otherBody):
	if otherBody.is_in_group(game.Group_Birds):
		game.score += 1
		pass
	pass

