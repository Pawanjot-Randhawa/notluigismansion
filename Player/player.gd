extends CharacterBody3D
class_name Player

@export var rotation_speed: float = PI / 16

# For original reference, never changes
const DEFAULT_SPEED: float = 5.0

var SPEED: float = 5.0
const JUMP_VELOCITY: float = 4.5
var moving: bool = false

func _ready() -> void:
	Game.player = self

func _physics_process(delta: float) -> void:
	if not %FreezeTimer.paused:
		var percent = (%FreezeTimer.time_left / %FreezeTimer.wait_time) * 100.0
		%FreezeCircle.value = percent
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	## Handle jump.
	#if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		#velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var input_dir := Input.get_vector("left", "right", "forward", "back")
	var direction := (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		moving = true
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
		%mesh.rotation.y = rotate_toward(%mesh.rotation.y, Vector2(direction.x, -direction.z).angle() + PI/2,rotation_speed)
	else:
		moving = false
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)

	move_and_slide()

func swap_cam_to_player(value:bool):
	if value:
		Game.can_hit_player = true
		unpause_player()
		%Camera3D.make_current()
		%mesh.visible = true
	else:
		Game.can_hit_player = false
		pause_player()
		%mesh.visible = false

func get_movement_speed() -> float:
	return SPEED

func set_movement_speed(amount: float):
	SPEED = amount

func reset_movement_speed() -> void:
	SPEED = DEFAULT_SPEED

func slow_movement_by(modifier: float) -> void:
	# If the speed - modifier is <= 0, go to 1
	var potential_speed: float = SPEED - modifier
	const FALLBACK_SPEED = 1
	SPEED = potential_speed if potential_speed > 0 else FALLBACK_SPEED

func is_slowed() -> bool:
	return SPEED == DEFAULT_SPEED

func freeze():
	%FreezeCircle.value = 0
	pause_player()
	%FreezeTimer.start()
	%Ice.show()
	%FreezeCircle.show()
	%AnimationTree["parameters/Blend2/blend_amount"] = 1
	await %FreezeTimer.timeout
	%Ice.hide()
	%FreezeCircle.hide()
	%AnimationTree["parameters/Blend2/blend_amount"] = 0
	unpause_player()

func pause_player() -> void:
	SPEED = 0

func unpause_player() -> void:
	SPEED = DEFAULT_SPEED
