class_name OrcBasic
extends Enemy

func _ready() -> void:
	max_health = 40
	speed = 75.0
	armor = 0
	damage = 10
	xp_value = 10
	attack_cooldown = 1.2
	super._ready()
