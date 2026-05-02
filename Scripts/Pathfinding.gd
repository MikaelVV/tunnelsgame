extends CharacterBody3D

var speed = 3
var acceleration = 10

@onready var navigationAgent := $NavigationAgent3D
#@onready var target := $"../Marker3D"
@onready var targetNext := $"../Marker3D2"
@onready var model := $"Model/ukko solttu"
@onready var detection_area := $"Area3D"
@onready var player := %"Player"

var enemies = []

enum States { IDLE, WAITING, MOVE, ATTACK}
var state : States = States.IDLE

var idle_wait_time: float = 3.5 # Määrittää kauanko vihollinen on paikoillaan ennenkuin se alkaa liikkumaan.
var idle_timer_count: float = 0

func _physics_process(delta):
	#var direction = Vector3()
	
	#navigationAgent.target_position = target.global_position
	
	#direction = navigationAgent.get_next_path_position() - global_position
	#direction = direction.normalized()
	
	
	#target.global_position. PS. Tän kanssa pitää vielä kikkailla, että se käännös tapahtuu sulavasti
	#look_at(navigationAgent.get_next_path_position())
	
	match state:
		States.IDLE:
			idling()
		States.WAITING:
			waiting(delta)
		States.MOVE:
			move()
		States.ATTACK:
			attack()
	
	#if(navigationAgent.is_target_reached()):
		#nextTarget(delta)
	#else:
		#navigationAgent.target_position = target.global_position
		
	move_and_slide()
	
#func nextTarget(_delta):
	#target.global_position = targetNext.global_position
	#navigationAgent.target_position = target.global_position
	#look_at(target.global_position)
	
func idling():
	velocity = Vector3.ZERO # Pitää vihollisen varmasti liikkumattomana, kun sen tilana on IDLE
	idle_timer_count = idle_wait_time
	state = States.WAITING
	print("idling")
	
func waiting(delta):
	print("waiting to do something")
	idle_timer_count -= delta
	
	if idle_timer_count <= 0.0:
		var get_target = new_target()
		var navigation_map = navigationAgent.get_navigation_map()
		var best_target = NavigationServer3D.map_get_closest_point(navigation_map, get_target)
		navigationAgent.target_position = best_target
		state = States.MOVE
		
	
func move():
	print("moving!")
	var current_position = global_transform.origin
	var next_position = navigationAgent.get_next_path_position()
	var direction = (next_position - current_position).normalized()
	look_at(navigationAgent.get_next_path_position())
	#velocity = velocity.lerp(direction * speed, acceleration * delta)
	velocity = direction * speed
	
func attack():
	var current_position = global_transform.origin
	var get_player_position = player.position
	var next_position = navigationAgent.get_next_path_position()
	var direction = (next_position - current_position).normalized() 
	navigationAgent.target_position = get_player_position
	velocity = direction * speed
	look_at(navigationAgent.get_next_path_position())
	print("attacking!")

#NPC pystyy liikkumaan vasemmalle, tai oikealle välillä 2.5 - 5.5 metriä. Vector2, eli Y on 0 value
#Koska ei tietenkään haluta, että sotilaat lentää (vielä).
func new_target() -> Vector3:
	var offset_x = randf_range(2.5, 5.5) * (-1 if randf() < 0.5 else 1)
	var offset_z = randf_range(2.5, 5.5) * (-1 if randf() < 0.5 else 1)
	return global_transform.origin + Vector3(offset_x, 0, offset_z)

#Kun NPC pääsee kohteeseensa, niin state muuttuu taas idleksi ja alkaa etsimään uutta patrollaus kohdetta.
func _on_navigation_agent_3d_target_reached() -> void:
	print("reached target!")
	state = States.IDLE


func _on_area_3d_body_entered(body: Node3D) -> void:
	if body.is_in_group("Player"):
		attack()
		state = States.ATTACK


func _on_area_3d_body_exited(body: Node3D) -> void:
	if body.is_in_group("Player"):
		state = States.IDLE
