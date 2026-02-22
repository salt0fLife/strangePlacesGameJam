extends Node2D

@onready var player = $player
@onready var exit = $exit
signal change_world

func _process(delta):
	if (player.position - exit.position).length() < 50.0:
		$exit/tooltip.visible = true
	else:
		$exit/tooltip.visible = false
	
	if (player.position - $wip.position).length() < 50.0:
		$wip/toolTIP.visible = true
	else:
		$wip/toolTIP.visible = false
	

func _input(event):
	if Input.is_action_just_pressed("enter_door"):
		if $exit/tooltip.visible:
			emit_signal("change_world", "res://world/levels/sky_world.tscn")
