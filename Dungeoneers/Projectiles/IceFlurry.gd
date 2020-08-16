extends Node2D

onready var projectile1 = $Projectile1
onready var projectile2 = $Projectile2
onready var projectile3 = $Projectile3
onready var projectile4 = $Projectile4
onready var projectile5 = $Projectile5

onready var projectiles = get_children()
var cooldown = 0.6

func shoot(start_pos):
	global_position = start_pos
	var origin_displacement = Vector2(0, - 20)
	for projectile in projectiles:
		projectile.shoot(global_position + origin_displacement)
		origin_displacement.y += 10
