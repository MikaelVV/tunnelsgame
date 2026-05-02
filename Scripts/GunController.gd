extends Node3D

@export var damage = 10.0
@onready var switch_anim = $WeaponSwitchAnim
@onready var raycast = $RayCast3D
@onready var weapon_audio = $WeaponAudio

var shooting = false


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_action_pressed("primary_fire") and shooting:
		shooting = false
		if raycast.is_colliding():
				if raycast.get_collider().is_in_group("Enemies"):
					raycast.get_collider().hp -= damage
			
			



func _on_weapon_switch_anim_animation_finished(anim_name: StringName) -> void:
	pass # Replace with function body.
