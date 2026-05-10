extends Node2D

@onready var wave_manager: WaveManager = $WaveManager
@onready var hud: HUD = $HUD
@onready var upgrade_ui: UpgradeUI = $UpgradeUI

var player: Player = null

func _ready() -> void:
	_spawn_player()
	wave_manager.wave_started.connect(_on_wave_started)
	wave_manager.wave_completed.connect(_on_wave_completed)
	wave_manager.all_waves_completed.connect(_on_all_waves_completed)
	upgrade_ui.upgrade_chosen.connect(_on_upgrade_chosen)
	GameManager.game_over.connect(_on_game_over)
	GameManager.game_won.connect(_on_game_won)
	GameManager.start_game()
	await get_tree().create_timer(1.0).timeout
	wave_manager.start_next_wave()

func _spawn_player() -> void:
	var scene: PackedScene = GameManager.get_character_scene()
	player = scene.instantiate() as Player
	add_child(player)
	player.global_position = Vector2.ZERO
	player.level_up.connect(_on_player_level_up)

func _on_wave_started(wave_number: int) -> void:
	hud.set_wave(wave_number, WaveManager.MAX_WAVES)

func _on_wave_completed(_wave_number: int) -> void:
	await get_tree().create_timer(1.5).timeout
	wave_manager.start_next_wave()

func _on_player_level_up(_new_level: int) -> void:
	if is_instance_valid(player):
		upgrade_ui.show_upgrade(player)

func _on_upgrade_chosen(_stat: String, _amount: float) -> void:
	pass

func _on_all_waves_completed() -> void:
	GameManager.end_game(true)

func _on_game_over() -> void:
	await get_tree().create_timer(1.5).timeout
	get_tree().change_scene_to_file("res://scenes/character_select.tscn")

func _on_game_won() -> void:
	await get_tree().create_timer(2.0).timeout
	get_tree().change_scene_to_file("res://scenes/character_select.tscn")
