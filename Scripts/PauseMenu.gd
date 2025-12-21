extends Node

@onready var pause_menu = $"."

func resume():
	get_tree().paused = false
	pause_menu.hide()
	
	
func pause():
	get_tree().paused = true
	pause_menu.show()
# Called when the node enters the scene tree for the first time.

func escape():
	if Input.is_action_just_pressed("escape") and !get_tree().paused:
		pause()
	elif Input.is_action_just_pressed("escape") and get_tree().paused:
		resume()
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	escape()


func _on_resume_button_pressed() -> void:
	resume()


func _on_return_button_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/MainMenu.tscn")


func _on_quit_button_pressed() -> void:
	get_tree().quit()
