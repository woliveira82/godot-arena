extends Control

onready var player = $Player
var black_sprites = load("res://src/game/characters/resources/Black.tres")
var dark_sprites = load("res://src/game/characters/resources/Dark.tres")
var elf_sprites = load("res://src/game/characters/resources/Elf.tres")
var orc_sprites = load("res://src/game/characters/resources/Orc.tres")
var white_sprites = load("res://src/game/characters/resources/White.tres")


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
