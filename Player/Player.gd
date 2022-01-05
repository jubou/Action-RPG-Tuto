extends KinematicBody2D

const ACCELERATION = 500
const FRICTION = 500
const MAX_SPEED = 80
const ROLL_SPEED = MAX_SPEED * 1.5

enum {
	MOVE,
	ROLL,
	ATTACK
}

var state = MOVE
var velocity = Vector2.ZERO
var input_vector = Vector2.DOWN
var roll_vector = input_vector

onready var animationPlayer = $AnimationPlayer
onready var animationTree = $AnimationTree
onready var animationState = animationTree.get("parameters/playback")

func _ready():
	set_animations()
	animationTree.active = true

func _physics_process(delta):
	match state:
		MOVE:
			move_state(delta)
		ROLL:
			roll_state()
		ATTACK:
			attack_state()

func set_animations():
	animationTree.set("parameters/Idle/blend_position", input_vector)
	animationTree.set("parameters/Run/blend_position", input_vector)
	animationTree.set("parameters/Attack/blend_position", input_vector)
	animationTree.set("parameters/Roll/blend_position", roll_vector)

func move_state(delta):
	input_vector = Vector2.ZERO
	input_vector.x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	input_vector.y = Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
	input_vector = input_vector.normalized()
	# Input should be in _process() function, but in Godot documentation
	# they always use _physics_process() 
	
	if input_vector != Vector2.ZERO:
		roll_vector = input_vector
		set_animations()
		animationState.travel("Run")
		velocity = velocity.move_toward(input_vector * MAX_SPEED, ACCELERATION * delta)
	else:
		animationState.travel("Idle")
		velocity = velocity.move_toward(Vector2.ZERO, FRICTION * delta)
	
	move()
	
	if Input.is_action_just_pressed("roll"):
		state = ROLL
	
	if Input.is_action_just_pressed("attack"):
		state = ATTACK

func roll_state():
	velocity = roll_vector * ROLL_SPEED
	animationState.travel("Roll")
	move()

func attack_state():
	velocity = Vector2.ZERO
	animationState.travel("Attack")

func move():
	# move_and_slide should be in _physical_process() function
	velocity = move_and_slide(velocity)
	

func roll_animation_finished():
	velocity *= 0.6 # Vector2.ZERO # To prevent boot sliding
	state = MOVE

func attack_animation_finished():
	state = MOVE
