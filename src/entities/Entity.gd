class_name Entity
extends CharacterBody2D

signal health_changed(current: int, maximum: int)
signal died

@export var max_health: int = 100
@export var speed: float = 150.0
@export var armor: int = 0
@export var dodge_chance: float = 0.0  # 0.0 – 1.0

var health: int
var is_invincible: bool = false

func _ready() -> void:
	health = max_health

# Returns true if damage was applied, false if blocked/dodged.
# Nested conditional: invincibility → dodge roll → armor reduction
func take_damage(amount: int, _source: Entity = null) -> bool:
	if is_invincible:
		return false
	else:
		if randf() < dodge_chance:
			return false
		else:
			var reduced: int = max(1, amount - armor)
			health = max(0, health - reduced)
			health_changed.emit(health, max_health)
			if health <= 0:
				die()
			return true

func heal(amount: int) -> void:
	health = min(max_health, health + amount)
	health_changed.emit(health, max_health)

func get_health_percent() -> float:
	if max_health <= 0:
		return 0.0
	return float(health) / float(max_health)

func die() -> void:
	died.emit()
	queue_free()
