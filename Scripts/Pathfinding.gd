extends CharacterBody3D

var speed = 3
var acceleration = 10

@onready var navigationAgent := $NavigationAgent3D
@onready var target := $"../Marker3D"
@onready var targetNext := $"../Marker3D2"
@onready var model := $"Model/ukko solttu"


func _physics_process(delta):
	var direction = Vector3()
	
	navigationAgent.target_position = target.global_position
	
	direction = navigationAgent.get_next_path_position() - global_position
	direction = direction.normalized()
	
	velocity = velocity.lerp(direction * speed, acceleration * delta)
	
	look_at(target.global_position)
	
	if(navigationAgent.is_target_reached()):
		nextTarget(delta)
	else:
		navigationAgent.target_position = target.global_position
		
	move_and_slide()
	
func nextTarget(_delta):
	target.global_position = targetNext.global_position
	navigationAgent.target_position = target.global_position
	look_at(target.global_position)
	
