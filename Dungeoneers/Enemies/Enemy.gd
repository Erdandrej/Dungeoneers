extends KinematicBody2D

const EnemyDeathEffect = preload("res://Effects/EnemyDeathEffect.tscn")

export var ACCELERATION = 300
export var MAX_SPEED = 50
export var FRICTION = 200
export var WANDER_BUFFER = 4

enum{
	IDLE,
	WANDER,
	CHASE
}

var velocity = Vector2.ZERO
var knockback = Vector2.ZERO
var state = IDLE
var animation = "Idle"
var invicible = false

onready var animatedSprite = $AnimatedSprite
onready var hurtbox = $Hurtbox
onready var playerDetectionZone = $PlayerDetectionZone
onready var softCollision = $SoftCollision
onready var wanderController = $WanderController
onready var stats = $Stats
onready var blinkAnimationPlayer = $BlinkAnimationPlayer

func _ready():
	animatedSprite.play("Idle")
	state = pick_random_state([IDLE, WANDER])
	
func _physics_process(delta):
	knockback = knockback.move_toward(Vector2.ZERO, FRICTION * delta)
	knockback = move_and_slide(knockback)
	animatedSprite.scale = lerp(animatedSprite.scale, Vector2(1,1), 0.2)
	
	match state:
		IDLE:
			animation = "Idle"
			velocity = velocity.move_toward(Vector2.ZERO, FRICTION * delta)
			seek_player()
			if wanderController.get_time_left() == 0:
				update_wander()
				
		WANDER:
			seek_player()
			if wanderController.get_time_left() == 0:
				update_wander()
			accelerate_towards_point(wanderController.target_position, delta)
			if global_position.distance_to(wanderController.target_position) <= WANDER_BUFFER:
				update_wander()
				
		CHASE:
			animation = "Run"
			var player = playerDetectionZone.player
			if player != null:
				accelerate_towards_point(player.global_position, delta)
			else:
				state = IDLE
	
	if invicible:
		animation = "Hurt"
	animatedSprite.play(animation)
	if softCollision.is_colliding():
		velocity += softCollision.get_push_vector() * delta * 400
	velocity = move_and_slide(velocity)

func accelerate_towards_point(point, delta):
	var direction = global_position.direction_to(point)
	velocity = velocity.move_toward(direction * MAX_SPEED, ACCELERATION * delta)
	animatedSprite.flip_h = velocity.x < 0

func pick_random_state(state_list):
	state_list.shuffle()
	return state_list.pop_front()

func update_wander():
	state = pick_random_state([IDLE, WANDER])
	wanderController.start_wander_timer(rand_range(1, 3))

func seek_player():
	if playerDetectionZone.can_see_player():
		state = CHASE
		
func _on_Hurtbox_area_entered(area):
	stats.health -= area.damage
	animatedSprite.scale = Vector2(2.5, 0.5)
	knockback = area.knockback_vector * 120
	hurtbox.start_invincibility(0.5)

func _on_Hurtbox_invincibility_started():
	invicible = true
	blinkAnimationPlayer.play("Start")

func _on_Hurtbox_invincibility_ended():
	invicible = false
	blinkAnimationPlayer.play("Stop")

func _on_Stats_no_health():
	queue_free()
	var enemyDeathEffect = EnemyDeathEffect.instance()
	get_parent().add_child(enemyDeathEffect)
	enemyDeathEffect.global_position = global_position
