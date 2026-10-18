extends CharacterBody3D


const SPEED = 1.0
const JUMP_VELOCITY = 4.5

const goop: PackedScene = preload("res://Enemies/slime_goop.tscn")
@onready var animation_player: AnimationPlayer = $GreenBlob/AnimationPlayer
@onready var navigation_agent_3d: NavigationAgent3D = $NavigationAgent3D

@export var step_distance: float = 1.0
var distance_traveled: float = 0.0

@export var markers: Array[Marker3D]
var index: int = 0
var points

func _ready() -> void:
	points = markers.map(func(marker: Marker3D): return marker.global_position)
	animation_player.play("Walk")

func _physics_process(_delta: float) -> void:
	var old_position: Vector3 = global_position
	
	if navigation_agent_3d.is_navigation_finished():
		index = (index  + 1) % points.size()
		navigation_agent_3d.target_position = points[index]
		
		return;
	
	var next_point := navigation_agent_3d.get_next_path_position()
	velocity = global_position.direction_to(next_point) * SPEED
	
	move_and_slide()

	var moved_amount: float = old_position.distance_to(global_position)
	distance_traveled += moved_amount
	
	if distance_traveled > step_distance:
		distance_traveled -= step_distance
		spawn_goop()

func spawn_goop():
	const GOOP_LIFETIME = 5.0
	var instance: Node3D = goop.instantiate()

	var timer: Timer = Timer.new()
	timer.wait_time = GOOP_LIFETIME
	timer.autostart = true
	timer.one_shot = true
	
	timer.timeout.connect(instance.on_free)	
	instance.add_child(timer)

	get_tree().current_scene.add_child(instance)
	instance.global_position = global_position
