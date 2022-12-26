extends KinematicBody2D

const ACCELERATION = 500
const MAX_SPEED = 50
const FRICTION = 500

onready var animated_sprite = $AnimatedSprite
onready var timer_input = $TimerInput

enum {
	IDLE,
	MOVE,
	ATTACK,
	DAMAGE,
	DYING
}

var state = MOVE
var rng = RandomNumberGenerator.new()
var velocity = Vector2.ZERO
var allow_input = true
export var alt_animation = false


func _ready():
	randomize()
	rng.randomize()


func _physics_process(delta):
	var input = Vector2.ZERO
	if allow_input:
		if Input.is_action_just_pressed("attack"):
			_disable_input(1.0, ATTACK)
	
		else:
			input = _get_input_vector()
			state = IDLE if input == Vector2.ZERO else MOVE
	
	match state:
		IDLE:
			_idle(delta)

		MOVE:
			_move(delta, input)

		ATTACK:
			_attack(delta)

		DAMAGE:
			_damage(delta)

		DYING:
			_dying(delta)

	velocity = move_and_slide(velocity)


func _get_input_vector():
	var input_vector = Vector2.ZERO
	input_vector.x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	input_vector.y = Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
	input_vector = input_vector.normalized()
	_flip_sprite(input_vector.x)
	return input_vector


func _flip_sprite(x_input):
	if x_input > 0:
		animated_sprite.flip_h = false


	elif x_input < 0:
		animated_sprite.flip_h = true


func _idle(delta):
	animated_sprite.play("Idle 1")
	velocity = velocity.move_toward(Vector2.ZERO, FRICTION)


func _move(delta, input):
	animated_sprite.play("Run")
	velocity = velocity.move_toward(input * MAX_SPEED, ACCELERATION * delta)


func _attack(delta):
	animated_sprite.play("Attack")
	velocity = velocity.move_toward(Vector2.ZERO, FRICTION * delta)


func _damage(delta):
	animated_sprite.play("Damage")	
	velocity = velocity.move_toward(Vector2.ZERO, FRICTION * delta)


func _dying(delta):
	animated_sprite.play("Damage")
	velocity = velocity.move_toward(Vector2.ZERO, FRICTION)


func update_frames(resource):
	animated_sprite.frames = resource


func _on_TimerAttack_timeout():
	state = IDLE


func _disable_input(duration, new_state):
	allow_input = false
	timer_input.start(duration)
	state = new_state


func _on_Hurtbox_hit(area):
	_disable_input(0.5, DAMAGE)
	var push_force = 150 if area.global_position.x < position.x else -150
	velocity.x += push_force


func _on_TimerInput_timeout():
	allow_input = true
