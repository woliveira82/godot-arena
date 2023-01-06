extends KinematicBody2D

var ACCELERATION = 500
var MAX_SPEED = 50
var FRICTION = 500

enum {
	IDLE,
	MOVE,
	ATTACK,
	DAMAGE,
	DYING,
}

onready var animated_sprite = $AnimatedSprite
onready var animation = $AnimationPlayer
onready var timer_state = $TimerState
onready var weapon_position = $Position2D
onready var weapon = $Position2D/Sword
onready var stats = $Stats

var rng = RandomNumberGenerator.new()
var state = IDLE
var alive: bool = true
var velocity = Vector2.ZERO
var enemy = null
var keep_state: bool = false

export var alt_animation: bool = false
export var race = Data.HUMAN_BLACK

signal look_for_player(enemy)


func _ready():
	_keep_state(1.0, IDLE)
	var sprite = null
	match race:
		Data.DARK_ELF:
			sprite = load("res://src/game/characters/resources/Dark.tres")
			stats.speed = 1
			_set_speed()
		Data.ELF:
			sprite = load("res://src/game/characters/resources/Elf.tres")
			stats.speed = 1
			_set_speed()
		Data.HUMAN_BLACK:
			sprite = load("res://src/game/characters/resources/Black.tres")
			stats.vigor = 1
		Data.HUMAN_WHITE:
			sprite = load("res://src/game/characters/resources/White.tres")
			stats.vigor = 1
		Data.ORC:
			sprite = load("res://src/game/characters/resources/Orc.tres")
			stats.health += 1
			
	animated_sprite.frames = sprite


func _physics_process(delta):
	if alive:
		if not enemy:
			state = IDLE

		elif not keep_state:
			if _close_to(enemy):
				_keep_state(0.5, ATTACK)

			else:
				state = MOVE

	match state:
		IDLE: _idle(delta)
		MOVE: _move_toward(enemy, delta)
		ATTACK: _attack(delta)
		DAMAGE: _damage(delta)
		DYING: _dying(delta)

	_flip_sprite(velocity.x)
	velocity = move_and_slide(velocity)


func set_enemy(new_enemy):
	enemy = new_enemy


func _set_speed():
	var mod = 1.0 + stats.speed / 10
	ACCELERATION *= mod
	MAX_SPEED *= mod
	FRICTION *= mod


func _close_to(target_enemy):
	return global_position.distance_to(target_enemy.global_position) < 15


func _flip_sprite(x_velocity):
	var face_left = state != DAMAGE
	if x_velocity < 0:
		animated_sprite.flip_h = face_left
		weapon_position.scale.x = -1

	elif x_velocity > 0:
		animated_sprite.flip_h = !face_left
		weapon_position.scale.x = 1


func _idle(delta):
	animated_sprite.play("Idle 1")
	weapon.idle()
	velocity = velocity.move_toward(Vector2.ZERO, FRICTION * delta)


func _attack(delta):
	animated_sprite.play("Attack")
	weapon.attack()
	velocity = velocity.move_toward(Vector2.ZERO, FRICTION * delta)


func _damage(delta):
	animated_sprite.play("Damage")
	weapon.run()
	velocity = velocity.move_toward(Vector2.ZERO, FRICTION * delta)


func _dying(delta):
	animated_sprite.play("Dying")
	velocity = velocity.move_toward(Vector2.ZERO, FRICTION * delta)


func _move_toward(target_enemy, delta):
	animated_sprite.play("Run")
	weapon.run()
	var direction = global_position.direction_to(target_enemy.global_position)
	velocity = velocity.move_toward(direction * MAX_SPEED, ACCELERATION * delta)


func _keep_state(duration, new_state=null):
	keep_state = true
	timer_state.start(duration * (1.0 - stats.vigor / 10))
	if new_state: state = new_state


func _on_TimerState_timeout():
	keep_state = false


func _on_Hurtbox_area_entered(area):
	if alive:
		_keep_state(0.5, DAMAGE)
		stats.harm(1)
		var push_force = 150 if area.global_position.x < position.x else -150
		velocity.x += push_force


func _on_Stats_no_health():
	keep_state = true
	alive = false
	state = DYING
	animation.play("Vanish")
