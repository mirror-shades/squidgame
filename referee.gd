extends CharacterBody3D

const SPEED = 10.0
const JUMP_VELOCITY = 5
var is_on_fire = false
var fire_effect
var text_effect

func _ready():
	# Get the reference to the fire child node
	fire_effect = $Fire
	fire_effect.hide()  # Make sure it's hidden initially
	text_effect = $Camera3D/RichTextLabel
	text_effect.text = ""  # Initialize empty

func checkDeath():
	var is_moving = velocity.x != 0 or velocity.y != 0 or velocity.z != 0
	var in_danger_condition = Globals.isDanger() and !Globals.isRotating() and (is_moving or not is_on_floor())
	
	if in_danger_condition:
		is_on_fire = true
		fire_effect.show()  # Show the fire effect

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta
	
	if is_on_fire:
		return

	# Handle jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var input_dir := Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	var direction := (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)

	move_and_slide()

func checkWinner():
	print(Globals.getPlayers().size())
	if(Globals.getPlayers().size() == 1):
		$Camera3D/RichTextLabel.text = Globals.getWinner() + " wins!"
	if(Globals.getPlayers().size() == 0):
		$Camera3D/RichTextLabel.text = "No one wins!"

func _process(delta: float) -> void:
	#checkDeath()
	checkWinner()
