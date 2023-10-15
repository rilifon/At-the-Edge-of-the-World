extends Button

const HOVER_SCALE = Vector2(1.2, 1.2)
const SPIN_SPEED = 60

func _process(delta):
	if is_hovered():
		rect_scale = lerp(rect_scale, HOVER_SCALE, .5)
		rect_rotation += SPIN_SPEED * delta
	else:
		rect_scale = lerp(rect_scale, Vector2(1, 1), .5)
		rect_rotation = lerp(rect_rotation, 0, .5)
