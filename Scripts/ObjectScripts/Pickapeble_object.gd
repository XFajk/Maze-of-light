extends RigidBody3D

var picked_up : bool = false
var destination_position : Vector3 = Vector3()
var speed := 1000.0

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	if picked_up:
		gravity_scale = 0.0

		var direction = (destination_position - position)
		var distance = position.distance_to(destination_position)
		var impulse = direction * speed * delta
		linear_velocity = impulse
		
	else:
		gravity_scale = 1.0
		
func pick_up():
	pass
