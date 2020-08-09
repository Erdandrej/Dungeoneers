extends KinematicBody2D

export var health = 4

onready var animatedSprite = $AnimatedSprite
onready var hurtbox = $Hurtbox
onready var blinkAnimationPlayer = $BlinkAnimationPlayer

func _ready():
	animatedSprite.play("Idle")
		
func _on_Hurtbox_area_entered(area):
	animatedSprite.play("Hurt")
	health -= area.damage
	if health <= 0:
		queue_free()
	hurtbox.start_invincibility(0.5)

func _on_Hurtbox_invincibility_started():
	blinkAnimationPlayer.play("Start")

func _on_Hurtbox_invincibility_ended():
	animatedSprite.play("Idle")
	blinkAnimationPlayer.play("Stop")
