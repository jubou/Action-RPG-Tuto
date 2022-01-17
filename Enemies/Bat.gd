extends KinematicBody2D

const EnemyDeathEffect = preload("res://Effects/EnemyDeathEffect.tscn")

const FRICTION = 200
const ACCELERATION = 300
const MAX_SPEED = 50
const KNOCKBACK_SPEED = 150
const KNOCKBACK_FRICTION = 300

enum { IDLE, WANDER, CHASE }

var knockback_direction := Vector2.ZERO
var knockback_velocity := Vector2.ZERO
var velocity := Vector2.ZERO

onready var sprite = $AnimatedSprite
onready var stats = $Stats
onready var playerDetectionZone = $PlayerDetectionZone
var state = IDLE


func _physics_process(delta) -> void:
	knockback_velocity = knockback_velocity.move_toward(Vector2.ZERO, KNOCKBACK_FRICTION * delta)
	knockback_velocity = move_and_slide(knockback_velocity)

	match state:
		IDLE:
			velocity = velocity.move_toward(Vector2.ZERO, FRICTION * delta)
			seek_player()
		WANDER:
			pass
		CHASE:
			var player = playerDetectionZone.player

			if player != null:
				var direction = global_position.direction_to(player.global_position)
				velocity = velocity.move_toward(direction * MAX_SPEED, ACCELERATION * delta)

			else:
				state = IDLE

			sprite.flip_h = velocity.x < 0

	velocity = move_and_slide(velocity)
	print(state)


func seek_player():
	if playerDetectionZone.can_see_player():
		state = CHASE


func _on_Hurtbox_area_entered(area) -> void:
	stats.health -= area.damage
	knockback_direction = area.get_parent().global_position.direction_to(global_position)
	knockback_velocity = knockback_direction * KNOCKBACK_SPEED


func _on_Stats_no_health():
	queue_free()
	var enemyDeathEffect = EnemyDeathEffect.instance()
	get_parent().add_child(enemyDeathEffect)
	enemyDeathEffect.global_position = global_position
