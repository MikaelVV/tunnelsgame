extends Node3D

var weapons = []
var current_weapon = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	for i in self.get_children():
		weapons.append(i)
		i.visible = false
	weapons[current_weapon].visible = true


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("next_weapon"):
		weapons[current_weapon].visible = false
		switch_weapons(1)
	elif Input.is_action_just_pressed("previous_weapon"):
		weapons[current_weapon].visible = false
		switch_weapons(-1)
		
func switch_weapons(direction):
	current_weapon += direction
	if (current_weapon < 0):
		current_weapon += weapons.size()
	elif current_weapon >= weapons.size():
		current_weapon -= weapons.size()
		
	weapons[current_weapon].visible = true
