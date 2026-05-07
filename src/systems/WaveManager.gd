class_name WaveManager
extends Node

signal wave_started(wave_number: int)
signal wave_completed(wave_number: int)
signal all_waves_completed

@export var orc_basic_scene: PackedScene
@export var orc_fast_scene: PackedScene
@export var spawn_margin: float = 80.0

const MAX_WAVES: int = 10
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
	var vp_rect: Rect2 = get_viewport().get_visible_rect()
	for i: int in range(count):
		var pos: Vector2 = _offscreen_position(vp_rect)
		var scene: PackedScene = _pick_scene(i)
		if scene == null:
			enemies_alive -= 1
			continue
		var enemy: Enemy = scene.instantiate() as Enemy
		# Scale stats by difficulty before _ready fires
		enemy.max_health = int(enemy.max_health * GameManager.get_health_multiplier())
		enemy.damage = int(enemy.damage * GameManager.get_damage_multiplier())
		get_tree().current_scene.add_child(enemy)
		enemy.global_position = pos
		enemy.xp_dropped.connect(_on_xp_dropped)
		enemy.died.connect(_on_enemy_died)

func _pick_scene(index: int) -> PackedScene:
	# Fast orc every 3rd enemy starting wave 3
	if current_wave >= 3 and index % 3 == 2 and orc_fast_scene != null:
		return orc_fast_scene
	return orc_basic_scene

func _offscreen_position(rect: Rect2) -> Vector2:
	match randi() % 4:
		0: return Vector2(randf_range(rect.position.x, rect.end.x), rect.position.y - spawn_margin)
		1: return Vector2(randf_range(rect.position.x, rect.end.x), rect.end.y + spawn_margin)
		2: return Vector2(rect.position.x - spawn_margin, randf_range(rect.position.y, rect.end.y))
		_: return Vector2(rect.end.x + spawn_margin, randf_range(rect.position.y, rect.end.y))

func _on_enemy_died() -> void:
	enemies_alive -= 1
	if enemies_alive <= 0 and is_wave_active:
		is_wave_active = false
		wave_completed.emit(current_wave)

func _on_xp_dropped(amount: int, _pos: Vector2) -> void:
	var players: Array = get_tree().get_nodes_in_group("players")
	if players.size() > 0 and players[0] is Player:
		(players[0] as Player).gain_xp(amount)
