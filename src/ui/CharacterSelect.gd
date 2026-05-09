extends Control

@onready var diff_label: Label = $VBox/DiffLabel
@onready var diff_row: HBoxContainer = $VBox/DiffButtons

func _ready() -> void:
	_build_diff_buttons()
	_refresh_diff_label()

func _build_diff_buttons() -> void:
	var modes: Array = [
		{"label": "Easy",   "mode": GameManager.Difficulty.EASY},
		{"label": "Normal", "mode": GameManager.Difficulty.NORMAL},
		{"label": "Hard",   "mode": GameManager.Difficulty.HARD},
	]
	for entry: Dictionary in modes:
		var btn := Button.new()
		btn.text = entry["label"]
		btn.custom_minimum_size = Vector2(120, 44)
		var m: GameManager.Difficulty = entry["mode"]
		btn.pressed.connect(func() -> void: _set_diff(m))
		diff_row.add_child(btn)

func _set_diff(mode: GameManager.Difficulty) -> void:
	GameManager.set_difficulty(mode)
	_refresh_diff_label()

func _refresh_diff_label() -> void:
	var names: Array[String] = ["Easy", "Normal", "Hard"]
	diff_label.text = "Difficulty:  " + names[GameManager.difficulty]

func _play() -> void:
	GameManager.selected_character = "archer"
	get_tree().change_scene_to_file("res://scenes/game.tscn")
