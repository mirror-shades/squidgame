extends CharacterBody3D

const BASE_SPEED = 3.0
const JUMP_VELOCITY = 2.5

var speed = 3.0
var is_on_fire = false
var fire_effect
var timer
var rng
var locked = false

var can_move = true

func getLittleRand():
	const MIN = 0.01 
	const MAX = 0.05
	var littleRand = rng.randf_range(MIN, MAX) 
	return littleRand

func _ready() -> void:
	rng = RandomNumberGenerator.new()
	rng.randomize()
	
	speed = BASE_SPEED + getLittleRand()
	Globals.setPlayer("Coop")
	timer = $Timer
	fire_effect = $Fire
	fire_effect.hide()
	
	$Timer.timeout.connect(_on_Timer_timeout)

func checkDeath():
	var is_moving = velocity.x != 0 or velocity.y != 0 or velocity.z != 0
	var in_danger_condition = Globals.isDanger() and !Globals.isRotating() and (is_moving)
	
	if in_danger_condition:
		Globals.removePlayer("Coop")
		is_on_fire = true
		fire_effect.show()

func go():
	if not Globals.isDanger() or Globals.isRotating():
		locked = false
		run_down()
	else:
		if not locked:
			stop()

func stop():
	if timer.is_stopped():
		locked = true
		var timer_duration = getLittleRand()
		timer.wait_time = timer_duration 
		timer.start()
	else:
		# If timer is running, maintain locked state
		locked = true

func _on_Timer_timeout():
	velocity.z = 0
	if not Globals.isDanger():  # Only unlock if we're not in danger
		speed = BASE_SPEED + getLittleRand()
		locked = false

func run_down():
	# Only run if not locked
	if locked:
		return
		
	var direction := (transform.basis * Vector3(0, 0, 1)).normalized()
	if direction:
		velocity.x = direction.x * speed
		velocity.z = direction.z * speed
	else:
		velocity.x = move_toward(velocity.x, 0, speed)
		velocity.z = move_toward(velocity.z, 0, speed)

	move_and_slide()

func _process(delta: float) -> void:
	if (Globals.isDanger() or Globals.isRotating()) and not locked:
		stop()
	elif not Globals.isDanger() and not is_on_fire and Globals.getPlayers().size() > 1:
		locked = false
		go()
	
	checkDeath()
