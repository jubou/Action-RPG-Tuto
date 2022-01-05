extends KinematicBody2D

const EnemyDeathEffect = preload("res://Effects/EnemyDeathEffect.tscn")

export var KNOCKBACK_ACCEL = 200
export var KNOCKBACK_SPEED = 120

var knockback = Vector2.ZERO

onready var stats = $Stats

"""
Note:
Call down, signal up
"""

func _physics_process(delta):
	knockback = knockback.move_toward(Vector2.ZERO, KNOCKBACK_ACCEL * delta)
	knockback = move_and_slide(knockback)

func _on_Hurtbox_area_entered(area):
	stats.health -= area.damage # Here we call our setter set_health()
	knockback = area.knockback_vector * KNOCKBACK_SPEED

func _on_Stats_no_health():
	queue_free()
	var enemyDeathEffect = EnemyDeathEffect.instance()
	get_parent().add_child(enemyDeathEffect)
	enemyDeathEffect.global_position = global_position
