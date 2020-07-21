extends KinematicBody2D

export var health = 4

onready var animatedSprite = $AnimatedSprite

func _ready():
	animatedSprite.play("default")

func _physics_process(delta):
	if health <= 0:
		queue_free()

func _on_Hurtbox_area_entered(area):
	health -= area.damage
