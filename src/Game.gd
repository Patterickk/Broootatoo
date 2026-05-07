extends Node2D

@onready var wave_manager: WaveManager = $WaveManager
@onready var hud: HUD = $HUD
@onready var shop_ui: ShopUI = $ShopUI
@onready var player: Player = $Player

func _ready() -> void:
	wave_manager.wave_started.connect(_on_wave_started)
	wave_manager.wave_completed.connect(_on_wave_completed)
	wave_manager.all_waves_completed.connect(_on_all_waves_completed)
	shop_ui.upgrade_chosen.connect(_on_upgrade_chosen)
	GameManager.game_over.connect(_on_game_over)
	GameManager.game_won.connect(_on_game_won)
	GameManager.start_game()
	# Brief delay before wave 1 so the player can orient
	await get_tree().create_timer(1.0).timeout
	wave_manager.start_next_wave()

func _on_wave_started(wave_number: int) -> void:
	hud.set_wave(wave_number, WaveManager.MAX_WAVES)

func _on_wave_completed(_wave_number: int) -> void:
	await get_tree().create_timer(1.2).timeout
	shop_ui.show_shop(player)

func _on_upgrade_chosen(_stat: String, _amount: float) -> void:
	wave_manager.start_next_wave()

func _on_all_waves_completed() -> void:
	GameManager.end_game(true)

func _on_game_over() -> void:
	await get_tree().create_timer(1.5).timeout
	get_tree().reload_current_scene()

func _on_game_won() -> void:
	# TODO: show victory screen
	await get_tree().create_timer(2.0).timeout
	get_tree().reload_current_scene()
