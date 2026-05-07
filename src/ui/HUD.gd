class_name HUD
extends CanvasLayer

@onready var health_bar: ProgressBar = $Margin/VBox/HealthBar
@onready var xp_bar: ProgressBar = $Margin/VBox/XPBar
@onready var wave_label: Label = $Margin/VBox/WaveLabel
@onready var level_label: Label = $Margin/VBox/LevelLabel

func _ready() -> void:
	# Wait one frame so the player node is fully in the tree
	await get_tree().process_frame
	var players: Array = get_tree().get_nodes_in_group("players")
	if players.size() == 0:
		return
	var player: Player = players[0] as Player
	player.health_changed.connect(_on_health_changed)
	player.xp_changed.connect(_on_xp_changed)
	player.level_up.connect(_on_level_up)
	_refresh_health(player.health, player.max_health)
	_refresh_xp(player.current_xp, player.xp_to_next)
	level_label.text = "LVL 1"

# Dynamic health bar: colour shifts from green → red as HP drops
func _on_health_changed(current: int, maximum: int) -> void:
	_refresh_health(current, maximum)

func _refresh_health(current: int, maximum: int) -> void:
	health_bar.max_value = maximum
	health_bar.value = current
	var pct: float = float(current) / float(maximum) if maximum > 0 else 0.0
	health_bar.modulate = Color(1.0, pct, pct)

func _on_xp_changed(current: int, required: int) -> void:
	_refresh_xp(current, required)

func _refresh_xp(current: int, required: int) -> void:
	xp_bar.max_value = required
	xp_bar.value = current

func _on_level_up(new_level: int) -> void:
	level_label.text = "LVL " + str(new_level)

# Called by Game.gd each time a wave changes
func set_wave(current: int, maximum: int) -> void:
	wave_label.text = "Wave %d / %d" % [current, maximum]
