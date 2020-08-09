extends KinematicBody2D

const EnemyDeathEffect = preload("res://Effects/EnemyDeathEffect.tscn")

export var health = 4
export var MAX_SPEED = 50
export var FRICTION = 200
export var WANDER_BUFFER = 4

var knockback = Vector2.ZERO

onready var animatedSprite = $AnimatedSprite
onready var hurtbox = $Hurtbox
onready var blinkAnimationPlayer = $BlinkAnimationPlayer

func _ready():
	animatedSprite.play("Idle")
	
func _physics_process(delta):
	knockback = knockback.move_toward(Vector2.ZERO, FRICTION * delta)
	knockback = move_and_slide(knockback)
	
	var player = get_parent().get_node("Player")
	if player != null:
		animatedSprite.flip_h = global_position.x > player.global_position.x
	animatedSprite.scale = lerp(animatedSprite.scale, Vector2(1,1), 0.2)
	
func death(knockback_vector):
	queue_free()
	var enemyDeathEffect = EnemyDeathEffect.instance()
	get_parent().add_child(enemyDeathEffect)
	enemyDeathEffect.global_position = global_position
	
func _on_Hurtbox_area_entered(area):
	animatedSprite.scale = Vector2(1.3, 0.7)
	knockback = area.knockback_vector * 80
	animatedSprite.play("Hurt")
	health -= area.damage
	if health <= 0:
		death(area.knockback_vector)
	hurtbox.start_invincibility(0.5)

func _on_Hurtbox_invincibility_started():
	blinkAnimationPlayer.play("Start")

func _on_Hurtbox_invincibility_ended():
	animatedSprite.play("Idle")
	blinkAnimationPlayer.play("Stop")
