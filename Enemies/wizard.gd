extends CharacterBody3D


const SPEED = 5.0
const JUMP_VELOCITY = 4.5

var in_range:bool = false
var can_attack:bool = true

var in_portal:bool = false

@onready var portal: AnimatedSprite3D = $Portal

func _ready() -> void:
	portal.connect("frame_changed", attack_end)

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta
	
	if in_range and check_line_of_sight():
		look_at(Game.player.position, Vector3.UP, true)
		if can_attack:
			attack()

func attack():
	print("Attacking")
	can_attack = false
	portal.global_position = Game.player.global_position
	portal.play("default")
	%StartSound.play()

func attack_end():
	if portal.frame == 24:
		if in_portal:
			Game.player.position = Game.spawn.position
			portal.global_position = Game.player.global_position
		%StartSound.stop()
		%SpellSound.play()
	%AttackCooldown.start()

func check_line_of_sight() -> bool:
	var space_state = get_world_3d().direct_space_state
	
	# Create a direct ray query from the enemy's eyes to the player's position
	# Adjust global_position.y slightly if you want it at "eye level"
	var query = PhysicsRayQueryParameters3D.create(global_position, Game.player.global_position)
	
	# Set your collision mask (e.g., Layer 1 and Layer 2)
	query.collision_mask = 3 
	
	# Optional: Prevent the enemy from hitting its own collision box
	query.exclude = [get_rid()] 
	
	var result = space_state.intersect_ray(query)

	if result:
		if result.collider == Game.player:
			return true
			
	return false

func _on_attack_cooldown_timeout() -> void:
	can_attack = true

func _on_trigger_zone_body_entered(body: Node3D) -> void:
	if body is Player:
		in_range = true


func _on_trigger_zone_body_exited(body: Node3D) -> void:
	if body is Player:
		in_range = false


func _on_hit_zone_body_entered(body: Node3D) -> void:
	if body is Player:
		in_portal = true


func _on_hit_zone_body_exited(body: Node3D) -> void:
	if body is Player:
		in_portal = false
