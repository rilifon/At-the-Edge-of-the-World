extends Sprite

export var spawned_fish_scene: PackedScene


func spawn_fish(loot):
	var new_fish := spawned_fish_scene.instance()
	new_fish.texture = loot.image
	new_fish.position.x = rand_range(-32, 32)
	new_fish.rotation_degrees = rand_range(-90, 90)
	add_child(new_fish)
