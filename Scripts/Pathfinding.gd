extends CharacterBody3D

var acceleration = 10

@export var health = 100
@export var speed = 4.5

@onready var navigationAgent := $NavigationAgent3D
@onready var target := $"../NavigationRegion3D/Markers/Marker3D"
@onready var targetNext := $"../NavigationRegion3D/Markers/Marker3D2"
@onready var model := $"."
@onready var detection_area := $"Area3D"
@onready var player := %"Player"
@onready var cover_positions = [target.position, targetNext.position]

enum States { IDLE, WAITING, MOVE, ATTACK, RETREAT, TOCOVER}
var state : States = States.IDLE

var idle_wait_time: float = 6.5 # Määrittää kauanko vihollinen on paikoillaan ennenkuin se alkaa liikkumaan.
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
		States.RETREAT:
			retreat()
		States.TOCOVER:
			tocover()
	
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
	
#Keskeneräinen attack funktio. Tällä hetkellä vaan huomattuaan pelaajan se seuraa sitä.
func attack():
	var current_position = global_transform.origin
	var get_player_position = player.position
	var next_position = navigationAgent.get_next_path_position()
	var direction = (next_position - current_position).normalized() 
	navigationAgent.target_position = get_player_position
	velocity = direction * speed
	look_at(navigationAgent.get_next_path_position())
	print("attacking!")
	
func retreat():
	if health <= 25:
		print("retreating!")
		
#Laskee arrayhin laittettujen markkerien välillä matkan ja ottaa lyhyimmän matkan riippuen omasta sijainnista.
func tocover():
	var current_position = global_transform.origin
	var closest_position
	var closest_distance = INF
	
	for p in cover_positions:
		var distance = global_transform.origin.distance_to(p)
		if distance < closest_distance:
			closest_distance = distance
			closest_position = p
	print("taking cover!")
	
	var next_position = navigationAgent.get_next_path_position()
	var direction = (next_position - current_position).normalized()
	navigationAgent.target_position = closest_position
	velocity = direction * speed
	look_at(navigationAgent.get_next_path_position())
	return closest_position

#NPC pystyy liikkumaan vasemmalle, tai oikealle välillä 2.5 - 5.5 metriä. Vector2, eli Y on 0 value
#Koska ei tietenkään haluta, että sotilaat lentää (vielä).
func new_target() -> Vector3:
	var offset_x = randf_range(2.5, 5.5) * (-1 if randf() < 0.5 else 1)
	var offset_z = randf_range(2.5, 5.5) * (-1 if randf() < 0.5 else 1)
	return global_transform.origin + Vector3(offset_x, 0, offset_z)

#Kun NPC pääsee kohteeseensa, niin state muuttuu taas idleksi ja alkaa etsimään uutta patrollaus kohdetta.
func _on_navigation_agent_3d_target_reached() -> void:
	if health <= 50:
		state = States.TOCOVER
	else:
		print("reached target!")
		state = States.IDLE

#Katsoo onko pelaaja näköetäisyydessä ja jos on, niin hyökkää.
func _on_area_3d_body_entered(body: Node3D) -> void:
	if body.is_in_group("Player"):
		state = States.TOCOVER

#Pelaajan päästyä pois näköetäisyydeltä, vihollinen palaa takaisin idleen.
func _on_area_3d_body_exited(body: Node3D) -> void:
	if body.is_in_group("Player"):
		state = States.IDLE
