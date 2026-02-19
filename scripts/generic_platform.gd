@tool
extends StaticBody2D
@export var ground_height = 0.0
@export var added_height = 0.0
@export var dead_ground = false
@export var clipping_enabled = false #if nodes are arranged for clipping

func _ready():
	settup_all()

func settup_all() -> void:
	ground_height += added_height
	get_child(0).position.y += added_height #should be clipMask or graphics if not clipping
	z_index = int((global_position.y - ground_height))
	if clipping_enabled:
		settup_clipping()

func settup_clipping(): #if platform is ontop of other platform cuts the bottom off so it looks right
	#this is all a buggy mess :/
	var col = move_and_collide(Vector2.ZERO,true)
	if col != null: #is colliding
		var hit = col.get_collider()
		if hit.is_in_group("wall"):
			var height_dif = (hit.ground_height + hit.added_height)
			if (height_dif<=(ground_height)):
				return #its not lower than you dont change anything
			print("clipped platform")
			$clipMask.position.y += height_dif
			$clipMask/graphics.position.y -= height_dif
			z_index -= (int(ground_height - hit.ground_height))*0.5
