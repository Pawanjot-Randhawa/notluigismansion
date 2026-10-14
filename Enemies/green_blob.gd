extends CharacterBody3D


const SPEED = 1.0
const JUMP_VELOCITY = 4.5

@onready var animation_player: AnimationPlayer = $GreenBlob/AnimationPlayer
@onready var navigation_agent_3d: NavigationAgent3D = $NavigationAgent3D

@export var player:Player

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta
	var destination = navigation_agent_3d.get_next_path_position()
	var local_spot = destination - global_position
	var direction = local_spot.normalized()
	
	velocity = direction * SPEED
	look_at(player.position, Vector3.UP, true)
	move_and_slide()

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_accept"):
		navigation_agent_3d.target_position = player.position
