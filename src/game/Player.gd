extends KinematicBody2D

const ACCELERATION = 500
const MAX_SPEED = 150
const FRICTION = 500

onready var animation_player = $AnimationPlayer

var rng = RandomNumberGenerator.new()

var velocity = Vector2.ZERO
var facing_right = true


func _ready():
	randomize()
	rng.randomize()


func _physics_process(delta):
	move(delta)
	velocity = move_and_slide(velocity)


func move(delta):
	var input_vector = Vector2.ZERO
	input_vector.x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	input_vector.y = Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
	input_vector = input_vector.normalized()
	
	if input_vector.x > 0:
		facing_right = true

	elif input_vector.x < 0:
		facing_right = false
	
	if input_vector != Vector2.ZERO:
		velocity = velocity.move_toward(input_vector * MAX_SPEED, ACCELERATION * delta)
		if facing_right:
			animation_player.play("run_right")
		else:
			animation_player.play("run_left")
		
	else:
		if facing_right:
			animation_player.play("idle_right_2")
		
		else:
			animation_player.play("idle_left_2")
			
#		var chance = rng.randf()
#		print(chance)
#		if chance > 0.9:
#			animation_player.play("idle_right_1")
		
#		elif chance > 0.8:
#			animation_player.play("idle_right_2")
		velocity = velocity.move_toward(Vector2.ZERO, FRICTION * delta)
