extends KinematicBody2D

export var ACCELERATION = 500
export var MAX_SPEED = 80
export var FRICTION = 500

var velocity = Vector2.ZERO

onready var pivot = $W_Pivot
onready var sprite = $Sprite
onready var animationPlayer = $AnimationPlayer
	
func _physics_process(delta):
	var angle = get_global_mouse_position().angle_to_point(pivot.global_position)
	pivot.global_rotation = angle
	var input_vector = Vector2.ZERO
	input_vector.x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	input_vector.y = Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
	input_vector = input_vector.normalized()
	
	if input_vector != Vector2.ZERO:
		sprite.flip_h = (input_vector.x < 0)
		animationPlayer.play("Run")
		velocity = velocity.move_toward(input_vector*MAX_SPEED, ACCELERATION * delta)
	else:
		animationPlayer.play("Idle")
		velocity = velocity.move_toward(Vector2.ZERO, FRICTION * delta)
	
	velocity = move_and_slide(velocity)
