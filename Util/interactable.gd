extends Area3D
class_name Interactable

var in_range:bool = false
signal interact

func _input(event: InputEvent) -> void:
	if in_range:
		if Input.is_action_just_pressed("interact") and check_line_of_sight():
			interact.emit()

func check_line_of_sight() -> bool:
	var space_state = get_world_3d().direct_space_state
	
	# Create a direct ray query from the enemy's eyes to the player's position
	# Adjust global_position.y slightly if you want it at "eye level"
	var query = PhysicsRayQueryParameters3D.create(global_position, Game.player.global_position)
	
	# Set your collision mask (e.g., Layer 1 and Layer 2)
	query.collision_mask = 3 
	
	# Optional: Prevent the enemy from hitting its own collision box
	query.exclude = [get_parent().get_rid()] 
	
	var result = space_state.intersect_ray(query)

	if result:
		if result.collider == Game.player:
			return true
			
	return false

func _on_body_entered(body: Node3D) -> void:
	if body is Player:
		in_range = true
		


func _on_body_exited(body: Node3D) -> void:
	if body is Player:
		in_range = false
