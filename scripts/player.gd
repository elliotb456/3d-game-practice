extends CharacterBody3D

# How fast the player moves in meters per second
@export var speed = 14
# The downward acceleration when in the air, in meters per second squared 
@export var fall_accelaration = 75

var target_velocity= Vector3.ZERO


func _physics_process(delta):
    # Local variable to store the input direction
    var direction = Vector3.ZERO

    # Check for the movement inputs defined in the project settings and update the direction accordingly
    # In 3D spaces, the X,Z axis is the ground plane, Y is the vertical plane 
    if Input.is_action_pressed("move_right"):
        direction.x += 1
    if Input.is_action_pressed("move_left"):
        direction.x -= 1
    if Input.is_action_pressed("move_back"):
        direction.z += 1 
    if Input.is_action_pressed("move_forward"):
        direction.z -= 1


    # Normalising the Vectors length 
    # Prevents the player from moving faster by going diagonally
    if direction != Vector3.ZERO:
        # We only normalise the vector if the direction has length > 0, meaning the player is moving 
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