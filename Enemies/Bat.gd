extends KinematicBody2D

const KNOCKBACK_SPEED = 150
const KNOCKBACK_FRICTION = 300

var knockback_direction := Vector2.ZERO
var knockback_velocity := Vector2.ZERO

onready var stats = $Stats


func _physics_process(delta) -> void:
	knockback_velocity = knockback_velocity.move_toward(Vector2.ZERO, KNOCKBACK_FRICTION * delta)
	knockback_velocity = move_and_slide(knockback_velocity)


func _on_Hurtbox_area_entered(area) -> void:
	stats.health -= area.damage
	knockback_direction = area.get_parent().global_position.direction_to(global_position)
	knockback_velocity = knockback_direction * KNOCKBACK_SPEED


func _on_Stats_no_health():
	queue_free()
