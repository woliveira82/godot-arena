extends KinematicBody2D

const ACCELERATION = 500
const MAX_SPEED = 50
const FRICTION = 500

enum {
	IDLE,
	MOVE,
	ATTACK,
	DAMAGE
}

onready var animated_sprite = $AnimatedSprite
onready var timer_idle = $TimerIdle

var rng = RandomNumberGenerator.new()
var state = IDLE
var velocity = Vector2.ZERO
var allow_input = true
var enemy = null
var stand_still = false

export var alt_animation = false


func _ready():
	_set_idle(1.0, IDLE)


func _physics_process(delta):
	if not stand_still:
		state = ATTACK if _close_to(enemy) else MOVE

	match state:
		IDLE: _idle(delta)
		MOVE: _move_toward(enemy, delta)
		ATTACK: _attack(delta)
		DAMAGE: _damage(delta)

	_flip_sprite(velocity.x)
	velocity = move_and_slide(velocity)


func set_enemy(new_enemy):
	enemy = new_enemy


func _close_to(target_enemy):
	return global_position.distance_to(target_enemy.global_position) < 15


func _flip_sprite(x_velocity):
	var face_left = state != DAMAGE
	if x_velocity < 0:
		animated_sprite.flip_h = face_left

	elif x_velocity > 0:
		animated_sprite.flip_h = !face_left


func _idle(delta):
	animated_sprite.play("Idle 1")
	velocity = velocity.move_toward(Vector2.ZERO, FRICTION * delta)


func _attack(delta):
	animated_sprite.play("Attack")
	velocity = velocity.move_toward(Vector2.ZERO, FRICTION * delta)


func _damage(delta):
	animated_sprite.play("Damage")
	velocity = velocity.move_toward(Vector2.ZERO, FRICTION * delta)


func _move_toward(target_enemy, delta):
	animated_sprite.play("Run")
	var direction = global_position.direction_to(target_enemy.global_position)
	velocity = velocity.move_toward(direction * MAX_SPEED, ACCELERATION * delta)


func _set_idle(duration, new_state):
	stand_still = true
	timer_idle.start(duration)
	state = new_state


func _on_Hurtbox_hit(area):
	_set_idle(0.5, DAMAGE)
	var push_force = 150 if area.global_position.x < position.x else -150
	velocity.x += push_force


func _on_TimerIdle_timeout():
	stand_still = false
