extends Node


@onready var main_menu = $MainMenu
func _ready():
	main_menu.connect("play_pressed",play_game)
	main_menu.connect("settings_pressed",feature_not_implemented)
	main_menu.connect("credits_pressed",feature_not_implemented)
	main_menu.connect("quit_pressed",quit_game)
	pass

@onready var level_handler = $level_handler
func play_game() -> void:
	main_menu.hide() #dont want to see this while playing game
	load_level("res://world/levels/debug_level.tscn")

func load_level(path : String) -> void: #loads level
	for old in level_handler.get_children(false):
		old.queue_free()
	
	var new_level = load(path).instantiate()
	level_handler.add_child(new_level)

func feature_not_implemented() -> void:
	printerr("feature not implemented")
	#just say its not implemented yet
	pass

func _input(_event):
	if Input.is_action_just_pressed("pause"):
		
		pass

func quit_game():
	get_tree().quit(3)
