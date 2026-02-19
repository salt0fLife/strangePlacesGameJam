extends Control
const main_scene = "res://main.tscn"
func _ready():
	$AnimationPlayer.play("intoAnimation") #plays the intro animation
	await $AnimationPlayer.animation_finished #waits for the animation to finish
	get_tree().change_scene_to_file(main_scene) #changes the scene to main menu

func _input(_event):
	if Input.is_action_just_pressed("ui_accept"): #when enter is pressed
		$AnimationPlayer.emit_signal("animation_finished") #causes it to cancel early
