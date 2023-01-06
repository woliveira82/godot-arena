extends Node

signal no_health

export var max_health: int = 3
export var speed: int = 0
export var vigor: int = 0
export var invencible: bool = false

onready var health: int = max_health
onready var timer = $Timer


func harm(value: int):
	if not invencible:
		health -= abs(value)
		invencible = true
		if health <= 0:
			health = 0
			emit_signal("no_health")
			return
		
		timer.start(1.0)


func heal(value: int):
	health = min(health + abs(value), max_health)


func _on_Timer_timeout():
	invencible = false
