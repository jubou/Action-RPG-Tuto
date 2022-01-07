extends Area2D

const HitEffect = preload("res://Effects/HitEffect.tscn")

var invincible = false setget set_invincible

onready var timer = $Timer

signal invincibility_started
signal invincibility_ended

func set_invincible(value):
	invincible = value  # without self, it won't call the setter (to avoid recursion?)
	if invincible == true:
		emit_signal("invincibility_started")
	else:
		emit_signal("invincibility_ended")

func start_invincibility(duration):
	self.invincible = true
	timer.start(duration)

func create_hit_effect(_area):
	var effect = HitEffect.instance()
	var main = get_tree().current_scene
	main.add_child(effect)
	effect.global_position = global_position # - Vector2(0, 8) # offset
	# We can't use get_parent here because the parent is goin
	# to be freeing itselt in this case
	# We can use the parents parent but that starts to get
	# really messy (not recommended)

func _on_Timer_timeout():
	self.invincible = false  # With self calls the setter

func _on_Hurtbox_invincibility_started():
	set_deferred("monitorable", false) # monitorable is blockd during _physics_process

func _on_Hurtbox_invincibility_ended():
	monitorable = true # This happens on a timer, so set_deferred() is no necessary 
