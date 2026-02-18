extends StaticBody2D
@export var ground_height = 0.0
@export var dead_ground = false

func _ready():
	z_index = int((global_position.y - ground_height))
