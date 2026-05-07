class_name Pawn
extends Player

func _ready() -> void:
	max_health = 100
	speed = 140.0
	armor = 1
	dodge_chance = 0.05
	super._ready()
