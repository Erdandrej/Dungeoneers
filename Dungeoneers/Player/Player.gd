extends KinematicBody2D

export var ACCELERATION = 500
export var MAX_SPEED = 80
export var FRICTION = 500

var stats = PlayerStats
var velocity = Vector2.ZERO
var animation = "Idle"
var invicible = false
var casting = true

onready var sprite = $Sprite
onready var pivot = $Weapon_Pivot
onready var hurtbox = $Hurtbox
onready var animationPlayer = $AnimationPlayer
onready var blinkAnimationPlayer = $BlinkAnimationPlayer
onready var castTimer = $CastTimer

func _ready():
	stats.connect("no_health", self, "queue_free")
	stats.connect("next_level", self, "level_up")

func _physics_process(delta):
	sprite.scale = lerp(sprite.scale, Vector2(1,1), 0.2)
	
	var input_vector = Vector2.ZERO
	input_vector.x = Input.get_action_strength("right") - Input.get_action_strength("left")
	input_vector.y = Input.get_action_strength("down") - Input.get_action_strength("up")
	input_vector = input_vector.normalized()
	
	if global_position.x > get_global_mouse_position().x:
		h_flip(-1)
	else:
		h_flip(1)
	
	if input_vector != Vector2.ZERO:
		animation = "Run"
		velocity = velocity.move_toward(input_vector * MAX_SPEED, ACCELERATION * delta)
	else:
		animation = "Idle"
		velocity = velocity.move_toward(Vector2.ZERO, FRICTION * delta)
	
	if invicible:
		animation = "Hurt"
	
	animationPlayer.play(animation)
	velocity = move_and_slide(velocity)

func _unhandled_input(event):
	if event.is_action_pressed("cast") and casting:
		var projectile = preload("res://Projectiles/Icelance.tscn").instance()
		cast(projectile)
		stats.mana += 1
	
	if event.is_action_pressed("alt_cast") and casting:
		if stats.mana == stats.max_mana:
			var projectile = preload("res://Projectiles/Fireblast.tscn").instance()
			cast(projectile)
			stats.mana = 0
			
func h_flip(scale_x):
	sprite.scale.x = scale_x
	pivot.scale.x = scale_x

func cast(projectile):
	sprite.scale = Vector2(1.3, 0.7)
	get_parent().add_child(projectile)
	projectile.shoot(pivot.global_position)
	casting = false
	castTimer.start(projectile.cooldown)

func death():
	queue_free()
	var _current_scene = get_tree().reload_current_scene()

func level_up():
	stats.xp = 0
	stats.max_xp = stats.max_xp * 1.5
	stats.level += 1
	stats.max_health += 1

func _on_Hurtbox_area_entered(area):
	stats.health -= area.damage
	hurtbox.start_invincibility(1)

func _on_Hurtbox_invincibility_started():
	blinkAnimationPlayer.play("Start")
	invicible = true

func _on_Hurtbox_invincibility_ended():
	blinkAnimationPlayer.play("Stop")
	invicible = false

func _on_CastTimer_timeout():
	casting = true
