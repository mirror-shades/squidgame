extends Node3D

# Reference to the Timer node
var random_timer

# Rotation amount in degrees to apply at each timeout
@export var rotation_amount: float = 180.0
# Random number generator
var rng = RandomNumberGenerator.new()

# Add these new variables at the top with the other properties
var rotation_duration: float # Duration of rotation in seconds
var is_rotating: bool = false

func set_rotation_duration():
	rotation_duration = rng.randf_range(0.5, 1)

func _ready():
	random_timer = $Timer
	# Connect the timeout signal of the timer to a function
	random_timer.timeout.connect(_on_RandomTimer_timeout)
	# Start the process by setting the first random timeout
	set_random_timeout()
	set_rotation_duration()

func set_random_timeout():
	# Get a random float between 2 and 4
	var random_time = rng.randf_range(2, 4)
	random_timer.wait_time = random_time
	random_timer.start()

func _on_RandomTimer_timeout():
	# Rotate the node when the timer times out
	rotate_node()

	# Set a new random timeout for the next event
	set_random_timeout()

func rotate_node():
	if Globals.isRotating():
		return
		
	Globals.setRotating(true)
	var rotation_rad = deg_to_rad(rotation_amount)
	
	# Create a tween for smooth rotation
	var tween = create_tween()
	tween.tween_property(self, "rotation:y", self.rotation.y + rotation_rad, rotation_duration)
	tween.finished.connect(func(): 
		Globals.setRotating(false)
		Globals.setDanger(!Globals.isDanger()))
