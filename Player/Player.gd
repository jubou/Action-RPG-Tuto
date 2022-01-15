extends KinematicBody2D

export var ACCELERATION = 400
export var MAX_SPEED = 100
export var ROLL_SPEED = 150
export var FRICTION = 400
enum { MOVE, ROLL, ATTACK }
var state = MOVE
var roll_vector = Vector2.LEFT
var velocity = Vector2.ZERO
onready var animationPlayer = $AnimationPlayer
onready var animationTree = $AnimationTree
onready var animationState = animationTree.get("parameters/playback")


func _ready():
	animationTree.active = true


func _physics_process(delta):
	match state:
		MOVE:
			move_state(delta)
		ATTACK:
			attack_state(delta)
		ROLL:
			roll_state(delta)


func move_state(delta):
	var mouse_vector = global_position.direction_to(get_global_mouse_position())
	animationTree.set("parameters/Attack/blend_position", mouse_vector)

	var input_vector = Vector2.ZERO
	input_vector.x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	input_vector.y = Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
	input_vector = input_vector.normalized()

	if input_vector != Vector2.ZERO:
		roll_vector = input_vector
		animationTree.set("parameters/Run/blend_position", input_vector)
		animationTree.set("parameters/Idle/blend_position", input_vector)
		animationTree.set("parameters/Roll/blend_position", input_vector)
		animationState.travel("Run")
		velocity = velocity.move_toward(input_vector * MAX_SPEED, ACCELERATION * delta)

	else:
		animationState.travel("Idle")
		velocity = velocity.move_toward(Vector2.ZERO, FRICTION * delta)

	move()

	if Input.is_action_just_pressed("attack"):
		animationTree.set("parameters/Idle/blend_position", mouse_vector)
		state = ATTACK
	if Input.is_action_just_pressed("roll"):
		state = ROLL


func move():
	velocity = move_and_slide(velocity)


func attack_state(_delta):
	velocity = Vector2.ZERO
	animationState.travel("Attack")


func roll_state(_delta):
	move()
	velocity = roll_vector * ROLL_SPEED
	animationState.travel("Roll")


func attack_animation_finished():
	state = MOVE


func roll_animation_finished():
	velocity = velocity * 0.5
	state = MOVE
