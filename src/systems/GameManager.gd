extends Node

enum Difficulty { EASY, NORMAL, HARD }

signal game_over
signal game_won
signal difficulty_changed(mode: Difficulty)

var difficulty: Difficulty = Difficulty.NORMAL
var selected_character: String = "archer"
var is_game_active: bool = false
var elapsed_time: float = 0.0

const CHARACTER_SCENES: Dictionary = {
	"archer": "res://scenes/entities/player.tscn",
}

const _HEALTH_MULT: Dictionary = {
	Difficulty.EASY:   0.65,
	Difficulty.NORMAL: 1.0,
	Difficulty.HARD:   1.5,
}
const _DAMAGE_MULT: Dictionary = {
	Difficulty.EASY:   0.65,
	Difficulty.NORMAL: 1.0,
	Difficulty.HARD:   1.4,
}
const _SPAWN_MULT: Dictionary = {
	Difficulty.EASY:   0.6,
	Difficulty.NORMAL: 1.0,
	Difficulty.HARD:   1.6,
}

func set_difficulty(mode: Difficulty) -> void:
	difficulty = mode
	difficulty_changed.emit(mode)

func get_health_multiplier() -> float:
	return _HEALTH_MULT[difficulty]

func get_damage_multiplier() -> float:
	return _DAMAGE_MULT[difficulty]

func get_spawn_multiplier() -> float:
	return _SPAWN_MULT[difficulty]

func get_character_scene() -> PackedScene:
	var path: String = CHARACTER_SCENES.get(selected_character, CHARACTER_SCENES["archer"])
	return load(path) as PackedScene

func start_game() -> void:
	is_game_active = true
	elapsed_time = 0.0

func end_game(won: bool) -> void:
	is_game_active = false
	if won:
		game_won.emit()
	else:
		game_over.emit()

func _process(delta: float) -> void:
	if is_game_active:
		elapsed_time += delta
