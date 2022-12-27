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


func _ready():
	randomize()
	rng.randomize()


func _on_ButtonBlack_button_down():
	player.update_frames(black_sprites)


func _on_ButtonDark_button_down():
	player.update_frames(dark_sprites)


func _on_ButtonElf_button_down():
	player.update_frames(elf_sprites)


func _on_ButtonOrc_button_down():
	player.update_frames(orc_sprites)


func _on_ButtonWhite_button_down():
	player.update_frames(white_sprites)


func _on_ButtonEnemy_button_down():
	var enemy = enemy_scene.instance()
	enemy.global_position = Vector2(300, rng.randi_range(80, 170))
	field.add_child(enemy)
	enemy.set_enemy(get_node("YSort/Player"))
	
