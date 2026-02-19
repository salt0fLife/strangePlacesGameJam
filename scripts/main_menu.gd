extends Control
signal play_pressed
signal settings_pressed
signal credits_pressed
signal quit_pressed


func _ready():
	$blackout.visible = true #we want this to be visible in game, but its annoying in editor so i hid it
	play_intro_anim() #put it in a function just in case there is more than just animationPlayer


func play_intro_anim(): #plays into
	$AnimationPlayer.play("intro")


func _on_play_button_down():
	emit_signal("play_pressed")


func _on_settings_button_down():
	emit_signal("settings_pressed")


func _on_credits_button_down():
	emit_signal("credits_pressed")


func _on_quit_button_down():
	emit_signal("quit_pressed")
