extends StaticBody3D


@onready var pivot: Node3D = $Pivot

var not_done:bool = false
var left:bool = true
var direction:float = -1
var progress:float = 2

func _process(delta: float) -> void:
	if not_done:
		if left:
			print("ran")
			pivot.rotation_degrees.z = clampf(pivot.rotation_degrees.z + (direction * delta * 50), -50.0, 50.0)
		if pivot.rotation_degrees.z < 3 and pivot.rotation_degrees.z > -3:
			progress -= 0.5 * delta
			if progress <=1:
				not_done = false
				exit()
			else:
				%Hint.scale.x = progress

func _input(event: InputEvent) -> void:
	if not_done:
		if Input.is_action_just_pressed("interact"):
			direction = 1
			%SqueakNoise.play()
		elif Input.is_action_just_pressed("q"):
			direction = -1
			%SqueakNoise.play()

func exit():
	%Hint.hide()
	%Pivot.hide()
	%"good-pic".show()
	await get_tree().create_timer(.5).timeout
	%Pass.restart()
	%FinalSound.play()
	Game.repair_compelted.emit()
	await %Pass.finished
	await get_tree().create_timer(.75).timeout
	Game.player.swap_cam_to_player(true)


func _on_interactable_interact() -> void:
	%Camera3D.make_current()
	Game.player.swap_cam_to_player(false)
	%Interactable.monitoring = false
	not_done = true
	%Hint.show()
	%Pivot.show()
	%"ground-pic".hide()
