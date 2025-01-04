extends CharacterBody3D

const SPEED = 3.0
const JUMP_VELOCITY = 2.5
var is_on_fire = false
var fire_effect

var timer
var rng

func _ready() -> void:
	timer = $Timer
	rng = RandomNumberGenerator.new()
	fire_effect = $Fire
	fire_effect.hide()  # Make sure it's hidden initially

func checkDeath():
	var is_moving = velocity.x != 0 or velocity.y != 0 or velocity.z != 0
	var in_danger_condition = Globals.isDanger() and !Globals.isRotating() and (is_moving or not is_on_floor())
	
	if in_danger_condition:
		is_on_fire = true
		fire_effect.show()  # Show the fire effect

func go():
	if not is_on_fire:
		run_down()

func run_down():
	var direction := (transform.basis * Vector3(0, 0, 1)).normalized()
	if direction:
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)

	move_and_slide()

func _process(delta: float) -> void:
	go()
	checkDeath()
