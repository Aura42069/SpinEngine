extends CharacterBody2D

const GENESIS_TO_GODOT = 40

const acceleration_speed = 0.046875 * GENESIS_TO_GODOT
const deceleration_speed = 0.5 * GENESIS_TO_GODOT
const friction_speed = 0.046875 * GENESIS_TO_GODOT
const top_speed = 6 * GENESIS_TO_GODOT

const air_acceleration_speed = 0.09375 * GENESIS_TO_GODOT
const gravity_force = 0.21875 * GENESIS_TO_GODOT

var ground_speed = 0

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

func debug_text():
	$"Camera2D/DebugText".text = "
X: %d
Y: %d
XS: %d
YS: %d
GS: %d
GA: %d
" % [global_position.x, global_position.y, velocity.x, velocity.y, ground_speed, 0]

func ground_angle():
	return get_floor_normal().angle()

func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction = Input.get_axis("ui_left", "ui_right")
	if Input.is_action_pressed("ui_left"):
		if (ground_speed > 0):
			ground_speed -= deceleration_speed  # decelerate
			if (ground_speed <= 0):
				ground_speed = -0.5  # emulate deceleration quirk
		elif (ground_speed > -top_speed):
			ground_speed -= acceleration_speed  # accelerate
			if (ground_speed <= -top_speed):
				ground_speed = -top_speed # impose top speed limit
	elif Input.is_action_pressed("ui_right"):
		if (ground_speed < 0): # if moving to the left
			ground_speed += deceleration_speed # decelerate
			if (ground_speed >= 0):
				ground_speed = 0.5 # emulate deceleration quirk
		elif (ground_speed < top_speed): # if moving to the right
			ground_speed += acceleration_speed # accelerate
			if (ground_speed >= top_speed):
				ground_speed = top_speed # impose top speed limit
	else:
		ground_speed -= min(abs(ground_speed), friction_speed) * sign(ground_speed); # decelerate

	if is_on_floor():
		velocity.x = ground_speed

	debug_text()
	move_and_slide()
