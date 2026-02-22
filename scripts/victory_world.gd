extends Control

signal change_world

func _on_back_button_down():
	emit_signal("change_world", "MENU")
