extends KinematicBody2D

const ACCELERATION = 500
const MAX_SPEED = 150
const FRICTION = 500

onready var animation_player = $AnimationPlayer

enum {
	MOVE,
	ATTACK,
	DYING
}

var state = MOVE
var rng = RandomNumberGenerator.new()
var velocity = Vector2.ZERO
var facing_right = true
export var alt_animation = false


func _ready():
	randomize()
	rng.randomize()


func _physics_process(delta):
	match state:
		MOVE:
			_move(delta)

		ATTACK:
			pass

		DYING:
			pass

	velocity = move_and_slide(velocity)


func _get_input_vector():
	var input_vector = Vector2.ZERO
	input_vector.x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	input_vector.y = Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
	input_vector = input_vector.normalized()

	if input_vector.x > 0:
		facing_right = true

	elif input_vector.x < 0:
		facing_right = false
	
	return input_vector


func _move(delta):
	var input_vector = _get_input_vector()
	var face = 'right' if facing_right else 'left'
	if input_vector != Vector2.ZERO:
		$TimerIdle.stop()
		state = MOVE
		velocity = velocity.move_toward(input_vector * MAX_SPEED, ACCELERATION * delta)
		animation_player.play('run_%s' % face)

	else:
		if $TimerIdle.is_stopped():
			$TimerIdle.start(4)
		
		var animation_option = ''
		if alt_animation:
			animation_option = '_alt'

		animation_player.play('idle_%s%s' % [face, animation_option])
		velocity = velocity.move_toward(Vector2.ZERO, FRICTION * delta)


func _attack():
	pass


func _on_Timer_timeout():
	if rng.randf() > 0.5:
		alt_animation = true

	$TimerIdle.start(4)

