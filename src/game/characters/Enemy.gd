extends KinematicBody2D

const ACCELERATION = 500
const MAX_SPEED = 50
const FRICTION = 500

onready var animated_sprite = $AnimatedSprite

var rng = RandomNumberGenerator.new()
var velocity = Vector2.ZERO
var allow_input = true
var enemy = null

export var alt_animation = false


func _physics_process(delta):
	if enemy == null:
		print('no enemy')
		return

	if _close_to(enemy):
		_attack()

	else:
		_walk_toward(enemy, delta)
	
	velocity = move_and_slide(velocity)


func set_enemy(new_enemy):
	print("set_enemy(new_enemy):")
	enemy = new_enemy


func _close_to(target_enemy):
	print(target_enemy.global_position)
	return false


func _attack():
	print("Attack")


func _walk_toward(target_enemy, delta):
	var target = target_enemy.position - global_position
	velocity = velocity.move_toward(target.normalized() * MAX_SPEED, ACCELERATION * delta)


func _on_Hurtbox_hit(body):
	print("Hit")
	print(body.position)
