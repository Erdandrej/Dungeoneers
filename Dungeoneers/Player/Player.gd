extends KinematicBody2D

export var ACCELERATION = 500
export var MAX_SPEED = 80
export var FRICTION = 500

var velocity = Vector2.ZERO
var animation = "Idle"

onready var sprite = $Sprite
onready var pivot = $Weapon_Pivot
onready var animationPlayer = $AnimationPlayer
	
func _physics_process(delta):
	var input_vector = Vector2.ZERO
	input_vector.x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	input_vector.y = Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
	input_vector = input_vector.normalized()
	
	
	if input_vector != Vector2.ZERO:
		animationPlayer.play("Run")
		velocity = velocity.move_toward(input_vector * MAX_SPEED, ACCELERATION * delta)
	else:
		animationPlayer.play("Idle")
		velocity = velocity.move_toward(Vector2.ZERO, FRICTION * delta)
			
	velocity = move_and_slide(velocity)

func _unhandled_input(event):
	if event.is_action_pressed("ui_left"):
		flip(-1)
	if event.is_action_pressed("ui_right"):
		flip(1)

func flip(scale_x):
	sprite.scale.x = scale_x
	pivot.scale.x = scale_x
