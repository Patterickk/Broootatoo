class_name ArrowWeapon
extends Weapon

@export var arrow_scene: PackedScene

var extra_arrows: int = 0
var arrow_pierce: int = 0

func fire(target: Node2D) -> void:
	if arrow_scene == null:
		return
	var count: int = 1 + extra_arrows
	var base_dir: Vector2 = (target.global_position - global_position).normalized()
	var spread: float = deg_to_rad(12.0)
	for i: int in range(count):
		var offset: float = (float(i) - float(count - 1) / 2.0) * spread
		var arrow: Arrow = arrow_scene.instantiate() as Arrow
		get_tree().current_scene.add_child(arrow)
		arrow.global_position = global_position
		arrow.launch(base_dir.rotated(offset), damage, projectile_speed, arrow_pierce)
