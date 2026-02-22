extends Node2D


@onready var player = $player
@onready var exit = $exit
signal change_world
signal player_died

func _ready():
	player.connect("player_died", _on_death)

func _on_death():
	emit_signal("player_died")

func _process(delta):
	if (player.position - exit.position).length() < 20.0:
		$exit/tooltip.visible = true
	else:
		$exit/tooltip.visible = false

func _input(event):
	if Input.is_action_just_pressed("enter_door"):
		if $exit/tooltip.visible:
			emit_signal("change_world", "res://gui/victory_world.tscn")
