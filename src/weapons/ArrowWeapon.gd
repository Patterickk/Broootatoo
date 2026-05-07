class_name ArrowWeapon
extends Weapon

@export var arrow_scene: PackedScene

func fire(target: Node2D) -> void:
	if arrow_scene == null:
		return
	var arrow: Arrow = arrow_scene.instantiate() as Arrow
	get_tree().current_scene.add_child(arrow)
	arrow.global_position = global_position
	var dir: Vector2 = (target.global_position - global_position).normalized()
	arrow.launch(dir, damage, projectile_speed)
