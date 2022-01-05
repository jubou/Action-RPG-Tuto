extends KinematicBody2D

const KNOCKBACK_ACCEL = 200
const KNOCKBACK_SPEED = 120

var knockback = Vector2.ZERO

func _physics_process(delta):
	knockback = knockback.move_toward(Vector2.ZERO, KNOCKBACK_ACCEL * delta)
	knockback = move_and_slide(knockback)

func _on_Hurtbox_area_entered(area):
	knockback = area.knockback_vector * KNOCKBACK_SPEED
