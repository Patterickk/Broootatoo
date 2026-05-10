class_name HUD
extends CanvasLayer

@onready var health_bar: TextureProgressBar = $Margin/VBox/HealthBar
@onready var xp_bar: TextureProgressBar = $Margin/VBox/XPBar
@onready var wave_label: Label = $Margin/VBox/WaveLabel
@onready var level_label: Label = $Margin/VBox/LevelLabel
@onready var stats_btn: Button = $StatsBtn
@onready var stats_panel: Panel = $StatsPanel
@onready var stats_text: Label = $StatsPanel/VBox/StatsLabel

var _player: Player = null

func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS
	await get_tree().process_frame
	var players: Array = get_tree().get_nodes_in_group("players")
	if players.size() == 0:
		return
	_player = players[0] as Player
	_player.health_changed.connect(_on_health_changed)
	_player.xp_changed.connect(_on_xp_changed)
	_player.level_up.connect(_on_level_up)
	_refresh_health(_player.health, _player.max_health)
	_refresh_xp(_player.current_xp, _player.xp_to_next)
	level_label.text = "LVL 1"
	stats_btn.pressed.connect(_toggle_stats)
	stats_panel.hide()

func _on_health_changed(current: int, maximum: int) -> void:
	_refresh_health(current, maximum)

func _refresh_health(current: int, maximum: int) -> void:
	health_bar.max_value = maximum
	health_bar.value = current

func _on_xp_changed(current: int, required: int) -> void:
	_refresh_xp(current, required)

func _refresh_xp(current: int, required: int) -> void:
	xp_bar.max_value = required
	xp_bar.value = current

func _on_level_up(new_level: int) -> void:
	level_label.text = "LVL " + str(new_level)

func set_wave(current: int, maximum: int) -> void:
	wave_label.text = "Wave %d / %d" % [current, maximum]

func _toggle_stats() -> void:
	if stats_panel.visible:
		stats_panel.hide()
	else:
		_refresh_stats()
		stats_panel.show()

func _refresh_stats() -> void:
	if not is_instance_valid(_player):
		return
	var weapon: Node = _player.find_child("ArrowWeapon", true, false)
	var dmg: int = 0
	var fr: float = 0.0
	if weapon != null and weapon.get("damage") != null:
		dmg = weapon.get("damage")
		fr = weapon.get("fire_rate")
	stats_text.text = (
		"HP: %d / %d\nArmor: %d\nSpeed: %.0f\nDodge: %d%%\nLevel: %d\nATK: %d\nFire Rate: %.1f/s"
		% [_player.health, _player.max_health, _player.armor, _player.speed,
		   int(_player.dodge_chance * 100), _player.level, dmg, fr]
	)
