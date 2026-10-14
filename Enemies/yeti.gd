extends CharacterBody3D


const SPEED = 100

@onready var animation_player: AnimationPlayer = $Yeti/AnimationPlayer
@onready var navigation_agent_3d: NavigationAgent3D = $NavigationAgent3D


@export var player:Player

var idle:bool = true
var chase: bool = false
var hit:bool = false

func _physics_process(delta: float) -> void:
	if hit:
		return
	if chase:
		navigation_agent_3d.target_position = player.position
		look_at(player.position, Vector3.UP, true)
		velocity = direction_to_player() * delta
		if animation_player.current_animation != "Walk":
			animation_player.play("Walk")
	elif idle:
		velocity = Vector3.ZERO
	
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta
	
	move_and_slide()

func direction_to_player() -> Vector3:
	var destination = navigation_agent_3d.get_next_path_position()
	var local_spot = destination - global_position
	var direction = local_spot.normalized()
	
	return direction * SPEED

func check_line_of_sight() -> bool:
	var space_state = get_world_3d().direct_space_state
	
	# Create a direct ray query from the enemy's eyes to the player's position
	# Adjust global_position.y slightly if you want it at "eye level"
	var query = PhysicsRayQueryParameters3D.create(global_position, player.global_position)
	
	# Set your collision mask (e.g., Layer 1 and Layer 2)
	query.collision_mask = 3 
	
	# Optional: Prevent the enemy from hitting its own collision box
	query.exclude = [get_rid()] 
	
	var result = space_state.intersect_ray(query)

	if result:
		if result.collider == player:
			return true
			
	return false


func _on_trigger_zone_body_entered(body: Node3D) -> void:
	if body is Player:
		chase = check_line_of_sight()


func _on_trigger_zone_body_exited(body: Node3D) -> void:
	if body is Player:
		chase = false
		idle = true


func _on_navigation_agent_3d_target_reached() -> void:
	call_deferred("death")

func death():
	hit = true
	chase = false
	idle = false
	animation_player.play("Dance")
	await animation_player.animation_finished
	queue_free()
