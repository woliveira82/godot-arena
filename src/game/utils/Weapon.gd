extends Node2D


onready var animation = $AnimationPlayer


func attack():
	animation.play("Attack")


func idle():
	animation.play("Idle")


func run():
	animation.play("Run")
