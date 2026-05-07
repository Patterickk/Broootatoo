class_name MeleeWeapon
extends Weapon

@export var attack_radius: float = 55.0

func fire(_target: Node2D) -> void:
	for enemy: Node in get_tree().get_nodes_in_group("enemies"):
		if enemy is Node2D:
			var dist: float = global_position.distance_to((enemy as Node2D).global_position)
			if dist <= attack_radius and enemy.has_method("take_damage"):
				enemy.take_damage(damage)
