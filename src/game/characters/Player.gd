extends KinematicBody2D

const ACCELERATION = 500
const MAX_SPEED = 50
const FRICTION = 500

onready var animated_sprite = $AnimatedSprite
onready var timer_attack = $TimerAttack

enum {
	IDLE,
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
	var input = _get_input_vector()
	if state != ATTACK:
		if Input.is_action_just_pressed("attack"):
			state = ATTACK
	
		else:
			state = IDLE if input == Vector2.ZERO else MOVE
	
		match state:
			IDLE:
				_idle()

			MOVE:
				_move(input)

			ATTACK:
				_attack()

			DYING:
				pass

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


func _idle():
	animated_sprite.play("Idle 1")
	velocity = velocity.move_toward(Vector2.ZERO, FRICTION)


func _move(input):
	animated_sprite.play("Run")
	velocity = velocity.move_toward(input * MAX_SPEED, ACCELERATION)


func _attack():
	animated_sprite.play("Attack")
	velocity = velocity.move_toward(Vector2.ZERO, FRICTION)
	timer_attack.start()


func update_frames(resource):
	animated_sprite.frames = resource


func _on_TimerAttack_timeout():
	state = IDLE


func _on_Hurtbox_hit(area):
	print(area.position)
