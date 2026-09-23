extends CharacterBody3D

# How fast the player moves in meters per second
@export var speed = 14
# The downward acceleration when in the air, in meters per second squared
@export var fall_accelaration = 75
# Vertical impulse applied to the character when jumping, in meters per second
@export var jump_impulse = 20
# Vertical impulse applied to the character when bouncing off a mob,
# in meters per second, gain less height than a normal jump
@export var bounce_impulse = 16

var target_velocity= Vector3.ZERO


func _physics_process(delta):
	# Local variable to store the input direction
	var direction = Vector3.ZERO

	 # Check for the movement inputs defined in the project settings
	 # and update the direction accordingly
	 # In 3D spaces, the X,Z axis is the ground plane, Y is the vertical plane

	# Walking
	if Input.is_action_pressed("move_right"):
		direction.x += 1
	if Input.is_action_pressed("move_left"):
		direction.x -= 1
	if Input.is_action_pressed("move_back"):
		direction.z += 1
	if Input.is_action_pressed("move_forward"):
		direction.z -= 1
	# Jumping
	if is_on_floor() and Input.is_action_pressed("jump"):
		target_velocity.y = jump_impulse

	#Bouncing
	# Iterate through all collisions hat occured this frame
	for index in range(get_slide_collision_count()):
		# We get one of the collisions with the player
		var collision = get_slide_collision(index)

		# If there are duplicare collisions with a mob in a single frame
		# the mob will be deleted after the first collision, and a second call to
		# get_collider will return nill, leading to a null pointer when callling
		# collision.get_collider().is_in_group("mob").
		# This block of code prevents processing duplicate collisions.
		if collision.get_collider() == null:
			continue

		# If the collider is with a mob
		if collision.get_collider().is_in_group("mob"):
			var mob = collision.get_collider()
			# we check that we are hitting it from above
			if Vector3.UP.dot(collision.ge_normal()) > 0.1:
				#If so, we squash it and bounce
				mob.squash()
				target_velocity.y = bounce_impulse
				# Prevent further duplicate calls
				break

	# Normalising the Vectors length
	# Prevents the player from moving faster by going diagonally
	if direction != Vector3.ZERO:
		# We only normalise the vector if the direction has length > 0
		# meaning the player is moving
		direction = direction.normalized()
		# Setting the basis property will affect he rotation of the specified node
		$Pivot.basis = Basis.looking_at(direction)

	# Updating the velocity
	# Ground Velocity
	target_velocity.x = direction.x * speed
	target_velocity.z = direction.z * speed

	# Vertical Velocity
	if not is_on_floor(): # Checking if the player is in the air
		# If true, fall towards the floor (ie. gravity)
		target_velocity.y = target_velocity.y - (fall_accelaration * delta)

	# Moving the character
	velocity = target_velocity
	move_and_slide()
