extends Area2D

onready var timer = $Timer
onready var collision_shape = $CollisionShape2D

signal hit(area)

var invencible = false


func _on_Timer_timeout():
	invencible = false


func _on_Hurtbox_area_entered(area):
	if not invencible:
		invencible = true
		emit_signal('hit', area)
		timer.start(0.7)
