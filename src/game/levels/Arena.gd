extends Control

var rng = RandomNumberGenerator.new()
var black_sprites = load("res://src/game/characters/resources/Black.tres")
var dark_sprites = load("res://src/game/characters/resources/Dark.tres")
var elf_sprites = load("res://src/game/characters/resources/Elf.tres")
var orc_sprites = load("res://src/game/characters/resources/Orc.tres")
var white_sprites = load("res://src/game/characters/resources/White.tres")
var enemy_scene = preload("res://src/game/characters/Enemy.tscn")

onready var player = $YSort/Player
onready var field = $YSort
onready var hearts = $Hearts


func _ready():
	randomize()
	rng.randomize()
	hearts.max_hearts = player.stats.max_health
	hearts.hearts = player.stats.health


func _on_ButtonEnemy_button_down():
	var enemy = enemy_scene.instance()
	enemy.global_position = Vector2(300, rng.randi_range(80, 170))
	field.add_child(enemy)
	enemy.set_enemy(get_node("YSort/Player"))


func _on_Player_health_update(value):
	hearts.set_hearts(value)


func _on_Player_player_dead():
	hearts.set_hearts(0)
	Engine.time_scale = 0.2
