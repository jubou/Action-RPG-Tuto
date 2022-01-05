extends Node2D

export(int) var max_health = 1
onready var health = max_health setget set_health

signal no_health # Call down, signal up

func set_health(value):
	"""
	Called as a normal setter
	"""
	health = value
	if health <= 0:
		emit_signal("no_health")
