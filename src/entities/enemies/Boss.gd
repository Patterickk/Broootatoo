class_name Boss
extends Enemy

func _ready() -> void:
	max_health = 600
	speed = 55.0
	armor = 3
	damage = 25
	xp_value = 200
	attack_cooldown = 1.5
	super._ready()
