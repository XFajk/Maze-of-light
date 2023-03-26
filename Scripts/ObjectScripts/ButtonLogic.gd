extends CharacterBody3D

@export var ActivatedObject : Node3D = null
@export var ActivatedObjectSpeed : float = 1.0
@export var ActivetedObjectPositionOffset : Vector3 = Vector3(0.0, 10.0, 0.0)
var ActiveObjectPositionLimit : Vector3 = Vector3.ZERO
var ActiveObjectOriginalPosition : Vector3 = Vector3.ZERO
var elapsed_time : float = 0.0

# logic vars
var button_active : bool = false

@onready var buttonParts = $buttonParts 

var button_delta : float = 0.01
var button_original_pos := Vector3.ZERO
var button_limit := Vector3.ZERO

# Called when the node enters the scene tree for the first time.
func _ready():
	button_original_pos = buttonParts.position
	button_limit = buttonParts.position - Vector3(0.0, 0.1, 0.0)
	ActiveObjectOriginalPosition = ActivatedObject.position
	ActiveObjectPositionLimit = ActivatedObject.position + ActivetedObjectPositionOffset


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if button_active:
		elapsed_time += delta
		
		var t = min(1.0, elapsed_time/ActivatedObjectSpeed)
		
		ActivatedObject.position = ActivatedObject.position.lerp(ActiveObjectPositionLimit, t*ActivatedObjectSpeed)
		
		if buttonParts.position.y > button_limit.y:
			buttonParts.set_position(buttonParts.position - Vector3(0.0, button_delta, 0.0)) 
	else:
		elapsed_time += delta
		
		var t = min(1.0, elapsed_time/ActivatedObjectSpeed)
		
		ActivatedObject.position = ActivatedObject.position.lerp(ActiveObjectOriginalPosition, t*ActivatedObjectSpeed)
		if buttonParts.position.y < button_original_pos.y:
			buttonParts.set_position(buttonParts.position + Vector3(0.0, button_delta, 0.0)) 

func _on_activation_area_body_entered(body):
	elapsed_time = 0.0
	button_active = true


func _on_activation_area_body_exited(body):
	elapsed_time = 0.0
	button_active = false

