extends CharacterBody3D

@export var mouse_sensitivity : float = 0.03

@export var speed : float = 5.0
@export var horizontal_acceleration : float = 6.0
@export var gravity : float = 20.0
@export var jump : float = 10.0


# logic vars
var mouse_capcured : bool = false

var direction : Vector3 = Vector3()
var horizontal_velocity : Vector3 = Vector3()
var movement : Vector3 = Vector3()
var gravity_vec : Vector3 = Vector3()

var scanned_object = null
var picked_up_somethig : bool = false


@onready var head := $head
@onready var ground_check := $ground_check
@onready var interaction_ray := $head/Camera3D/interaction_ray
@onready var pickup_location_object := $head/hold_position
@onready var flashLight := $head/Camera3D/flashLight

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	mouse_capcured = true
	flashLight.visible = false
	
func _input(event):
	if event is InputEventMouseMotion:
		rotate_y(deg_to_rad(-event.relative.x * mouse_sensitivity))
		head.rotate_x(deg_to_rad(-event.relative.y * mouse_sensitivity))
		head.rotation.x = clamp(head.rotation.x, deg_to_rad(-89), deg_to_rad(89))
	if Input.is_action_just_pressed("ui_cancel"):
		if mouse_capcured:
			Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
			mouse_capcured = false
		else:
			Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
			mouse_capcured = true 

func _physics_process(delta):
	direction = Vector3()
	
	if not is_on_floor(): 
		gravity_vec += Vector3.DOWN * gravity * delta
	else:
		gravity_vec = Vector3.ZERO
		
	if Input.is_action_just_pressed("jump") and (is_on_floor() or ground_check.is_colliding()):
		gravity_vec = Vector3.UP * jump
		
	if Input.is_action_just_pressed("flashLight"):
		if flashLight.visible:
			flashLight.visible = false
		else:
			flashLight.visible = true
		
	# drops the object it was holding
	if scanned_object != null:
		if scanned_object.picked_up:
			scanned_object.destination_position = pickup_location_object.global_position
			if Input.is_action_just_pressed("interact"):
				scanned_object.picked_up = false
				scanned_object.linear_velocity /= 5
	
	# pick up the and rigidbody object
	if Input.is_action_just_pressed("interact") and not picked_up_somethig:
		scanned_object = null
		if interaction_ray.is_colliding():
			scanned_object = interaction_ray.get_collider()
			if scanned_object is RigidBody3D:
				if scanned_object.has_method("pick_up"):
					picked_up_somethig = true
					scanned_object.picked_up = true
					scanned_object.destination_position = pickup_location_object.global_position
			else:
				scanned_object = null
			
	# makes sure that the objects stays droped when the player droped it 
	if scanned_object != null:
		if not scanned_object.picked_up:
			picked_up_somethig = false

	
	if Input.is_action_pressed("move_forward"):
		direction -= transform.basis.z 
	elif Input.is_action_pressed("move_backward"):
		direction += transform.basis.z
	if Input.is_action_pressed("move_left"):
		direction -= transform.basis.x
	elif Input.is_action_pressed("move_right"):
		direction += transform.basis.x
		
	direction = direction.normalized()
	horizontal_velocity = horizontal_velocity.lerp(direction * speed, horizontal_acceleration * delta)
	movement = Vector3(horizontal_velocity.x + gravity_vec.x, gravity_vec.y, horizontal_velocity.z + gravity_vec.z)
	
	velocity = movement
	move_and_slide()
		
