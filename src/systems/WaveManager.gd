class_name WaveManager
extends Node

signal wave_started(wave_number: int)
signal wave_completed(wave_number: int)
signal all_waves_completed

@export var orc_basic_scene: PackedScene
@export var orc_fast_scene: PackedScene
@export var boss_scene: PackedScene
@export var spawn_margin: float = 80.0

const MAX_WAVES: int = 20
const BASE_COUNT: int = 5
const COUNT_SCALE: float = 1.3

var current_wave: int = 0
var enemies_alive: int = 0
var is_wave_active: bool = false

func start_next_wave() -> void:
	current_wave += 1
	if current_wave > MAX_WAVES:
		all_waves_completed.emit()
		return
	var count: int = _calc_count(current_wave)
	enemies_alive = count
	is_wave_active = true
	wave_started.emit(current_wave)
	_spawn_wave(count)

func _calc_count(wave: int) -> int:
	var base: int = int(BASE_COUNT * pow(COUNT_SCALE, wave - 1))
	return int(base * GameManager.get_spawn_multiplier())

func _spawn_wave(count: int) -> void:
	if current_wave % 5 == 0 and boss_scene != null:
		var boss: Enemy = boss_scene.instantiate() as Enemy
		boss.max_health = int(boss.max_health * GameManager.get_health_multiplier())
		boss.damage = int(boss.damage * GameManager.get_damage_multiplier())
		get_tree().current_scene.add_child(boss)
		boss.global_position = _arena_edge_position()
		boss.xp_dropped.connect(_on_xp_dropped)
		boss.died.connect(_on_enemy_died)
		enemies_alive += 1
	for i: int in range(count):
		var pos: Vector2 = _arena_edge_position()
		var scene: PackedScene = _pick_scene(i)
		if scene == null:
			enemies_alive -= 1
			continue
		var enemy: Enemy = scene.instantiate() as Enemy
		enemy.max_health = int(enemy.max_health * GameManager.get_health_multiplier())
		enemy.damage = int(enemy.damage * GameManager.get_damage_multiplier())
		get_tree().current_scene.add_child(enemy)
		enemy.global_position = pos
		enemy.xp_dropped.connect(_on_xp_dropped)
		enemy.died.connect(_on_enemy_died)

func _pick_scene(index: int) -> PackedScene:
	if current_wave >= 3 and index % 3 == 2 and orc_fast_scene != null:
		return orc_fast_scene
	return orc_basic_scene

func _arena_edge_position() -> Vector2:
	const AX: float = 1160.0
	const AY: float = 620.0
	match randi() % 4:
		0: return Vector2(randf_range(-AX, AX), -AY)
		1: return Vector2(randf_range(-AX, AX), AY)
		2: return Vector2(-AX, randf_range(-AY, AY))
		_: return Vector2(AX, randf_range(-AY, AY))

func _on_enemy_died() -> void:
	enemies_alive -= 1
	if enemies_alive <= 0 and is_wave_active:
		is_wave_active = false
		wave_completed.emit(current_wave)

func _on_xp_dropped(amount: int, _pos: Vector2) -> void:
	var players: Array = get_tree().get_nodes_in_group("players")
	if players.size() > 0 and players[0] is Player:
		(players[0] as Player).gain_xp(amount)
