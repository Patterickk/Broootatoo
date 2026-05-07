extends Control

const CHARACTERS: Array[Dictionary] = [
	{
		"id": "warrior",
		"name": "Warrior",
		"desc": "Melee specialist\nHP: 150  Armor: 2\nSword sweep (AOE)"
	},
	{
		"id": "lancer",
		"name": "Lancer",
		"desc": "Defensive expert\nHP: 120  Armor: 5\nLong spear thrust"
	},
	{
		"id": "archer",
		"name": "Archer",
		"desc": "Precision sniper\nHP: 80  Dodge: 10%\nRanged arrows"
	},
	{
		"id": "pawn",
		"name": "Pawn",
		"desc": "Balanced fighter\nHP: 100  Armor: 1\nAxe area attack"
	},
]

@onready var char_buttons: HBoxContainer = $BG/VBox/CharButtons
@onready var diff_label: Label = $BG/VBox/DiffLabel
@onready var diff_row: HBoxContainer = $BG/VBox/DiffButtons

func _ready() -> void:
	_build_char_buttons()
	_build_diff_buttons()
	_refresh_diff_label()

func _build_char_buttons() -> void:
	for data: Dictionary in CHARACTERS:
		var btn := Button.new()
		btn.text = data["name"] + "\n\n" + data["desc"]
		btn.custom_minimum_size = Vector2(190, 160)
		btn.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
		btn.pressed.connect(func() -> void: _start(data["id"]))
		char_buttons.add_child(btn)

func _build_diff_buttons() -> void:
	var entries: Array = [
		{"label": "Easy",   "mode": GameManager.Difficulty.EASY},
		{"label": "Normal", "mode": GameManager.Difficulty.NORMAL},
		{"label": "Hard",   "mode": GameManager.Difficulty.HARD},
	]
	for entry: Dictionary in entries:
		var btn := Button.new()
		btn.text = entry["label"]
		btn.custom_minimum_size = Vector2(110, 36)
		btn.pressed.connect(func() -> void: _set_diff(entry["mode"]))
		diff_row.add_child(btn)

func _set_diff(mode: GameManager.Difficulty) -> void:
	GameManager.set_difficulty(mode)
	_refresh_diff_label()

func _refresh_diff_label() -> void:
	var names: Array[String] = ["Easy", "Normal", "Hard"]
	diff_label.text = "Difficulty:  " + names[GameManager.difficulty]

func _start(char_id: String) -> void:
	GameManager.selected_character = char_id
	get_tree().change_scene_to_file("res://scenes/game.tscn")
