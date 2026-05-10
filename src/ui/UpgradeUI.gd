class_name UpgradeUI
extends CanvasLayer

signal upgrade_chosen(stat: String, amount: float)

@onready var item_container: HBoxContainer = $Panel/VBox/Items
@onready var title_label: Label = $Panel/VBox/Title

const UPGRADES = [
	{"stat": "extra_arrows", "label": "+1 Arrow",       "amount": 1.0,  "desc": "Fire one extra arrow per shot (max 4 extra)."},
	{"stat": "pierce",       "label": "Pierce",          "amount": 1.0,  "desc": "Arrows pass through one extra enemy."},
	{"stat": "fire_rate",    "label": "+0.3 Fire Rate",  "amount": 0.3,  "desc": "Fire 0.3 more shots per second."},
	{"stat": "arrow_speed",  "label": "+60 Arrow Spd",   "amount": 60.0, "desc": "Arrows travel 60 units/s faster."},
	{"stat": "damage_flat",  "label": "+15 Damage",      "amount": 15.0, "desc": "All weapons deal 15 extra damage."},
	{"stat": "max_health",   "label": "+20 Max HP",      "amount": 20.0, "desc": "Restore and extend max health by 20."},
	{"stat": "armor",        "label": "+2 Armor",        "amount": 2.0,  "desc": "Reduce all incoming damage by 2."},
	{"stat": "speed",        "label": "+20 Speed",       "amount": 20.0, "desc": "Move 20 units per second faster."},
	{"stat": "dodge_chance", "label": "+5% Dodge",       "amount": 0.05, "desc": "5% chance to completely evade a hit."},
]

var _player: Player = null

func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS
	hide()

func show_upgrade(player: Player) -> void:
	_player = player
	title_label.text = "— CHOOSE AN UPGRADE —"
	_build_items()
	show()
	get_tree().paused = true

func _build_items() -> void:
	for child in item_container.get_children():
		child.queue_free()
	var pool: Array = UPGRADES.duplicate()
	pool.shuffle()
	for i: int in range(mini(3, pool.size())):
		var upgrade: Dictionary = pool[i]
		var btn := Button.new()
		btn.text = upgrade["label"] + "\n" + upgrade["desc"]
		btn.custom_minimum_size = Vector2(170, 90)
		btn.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
		btn.pressed.connect(func() -> void: _on_selected(upgrade))
		item_container.add_child(btn)

func _on_selected(upgrade: Dictionary) -> void:
	_apply(upgrade["stat"], upgrade["amount"])
	upgrade_chosen.emit(upgrade["stat"], upgrade["amount"])
	hide()
	get_tree().paused = false

func _apply(stat: String, amount: float) -> void:
	if _player == null:
		return
	match stat:
		"extra_arrows":
			for child in _player.get_children():
				if child is ArrowWeapon:
					(child as ArrowWeapon).extra_arrows = mini((child as ArrowWeapon).extra_arrows + 1, 4)
		"pierce":
			for child in _player.get_children():
				if child is ArrowWeapon:
					(child as ArrowWeapon).arrow_pierce += 1
		"fire_rate":
			for child in _player.get_children():
				if child is Weapon:
					(child as Weapon).fire_rate = minf(5.0, (child as Weapon).fire_rate + amount)
		"arrow_speed":
			for child in _player.get_children():
				if child is ArrowWeapon:
					(child as ArrowWeapon).projectile_speed += amount
		"damage_flat":
			for child in _player.get_children():
				if child is Weapon:
					(child as Weapon).damage += int(amount)
		"max_health":
			_player.max_health += int(amount)
			_player.health = mini(_player.health + int(amount), _player.max_health)
			_player.health_changed.emit(_player.health, _player.max_health)
		"armor":
			_player.armor += int(amount)
		"speed":
			_player.speed += amount
		"dodge_chance":
			_player.dodge_chance = minf(0.75, _player.dodge_chance + amount)
