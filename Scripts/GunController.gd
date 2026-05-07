extends Node3D

@export var damage = 5.0
@onready var switch_anim = $WeaponSwitchAnim
@onready var raycast = $RayCast3D
@onready var weapon_audio = $WeaponAudio

var can_shoot = true


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_action_pressed("primary_fire") and can_shoot:
		can_shoot = false
		if raycast.is_colliding():
			print(raycast.get_collider())
			if raycast.get_collider().is_in_group("Enemies"):
				raycast.get_collider().taking_damage(damage)
			
			



func _on_weapon_switch_anim_animation_finished(anim_name: StringName) -> void:
	pass # Replace with function body.
