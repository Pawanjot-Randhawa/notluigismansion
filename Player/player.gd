extends CharacterBody3D
class_name Player

@export var rotation_speed: float = PI / 16

const SPEED = 5.0
const JUMP_VELOCITY = 4.5
var moving: bool = false

func _ready() -> void:
	Game.player = self

func _physics_process(delta: float) -> void:
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
