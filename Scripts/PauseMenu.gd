extends Node

@onready var pause_menu = $"."

	
func resume():
	get_tree().paused = false
	pause_menu.hide()
	
	
func pause():
	get_tree().paused = true
	pause_menu.show()

func escape():
	if Input.is_action_just_pressed("escape") and get_tree().paused == false:
		pause()
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	elif Input.is_action_just_pressed("escape") and get_tree().paused == true:
		resume()
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
		
		
func _process(delta: float) -> void:
	escape()

func _ready() -> void:
	pass


func _on_resume_button_pressed() -> void:
	resume()
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)


func _on_return_button_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/MainMenu.tscn")
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)


func _on_quit_button_pressed() -> void:
	get_tree().quit()
