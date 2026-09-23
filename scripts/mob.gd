extends CharacterBody3D

# Minimum speed of the mob in meters per second
@export var min_speed = 10
# Maximum speed of the mob in meters per second
@export var max_speed = 18
# Emitted when the player jumps on the mob
signal squashed

func _physics_process(_delta):
	move_and_slide()


# The function will be called from the Main scene
func initialize(start_position, player_position):
	# We position the move by placing it at the start_position
	# and rotate it towards the player_position, so it looks a the player.
	look_at_from_position(start_position, player_position, Vector3.UP)
	# Rotate this mob randomly within range of -45 and +45 degrees,
	# so that is doesn't move directly towards the player
	rotate_y(randf_range(-PI / 4, PI /4))

	# We calculate a random speed integer
	var random_speed = randi_range(min_speed, max_speed)
	# We calculare a forwarad velocity that represents that speed
	velocity = Vector3.FORWARD * random_speed
	# We then rotate the velocity vector based on the mob's Y rotation
	# in order to move in the direction the mob is looking.
	velocity = velocity.rotated(Vector3.UP, rotation.y)


# This fucntion is called when the signal is triggered by leaving the screen
func _on_visible_on_screen_notifier_3d_screen_exited():
	# Destroys the instance it's called on, in this case the main Mob node
	queue_free()


func squash():
	squashed.emit()
	queue_free()
