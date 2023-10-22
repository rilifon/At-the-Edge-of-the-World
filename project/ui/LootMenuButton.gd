extends Button


func _ready():
	rect_pivot_offset = rect_size / 2


func _process(_delta):
	if is_hovered():
		rect_scale = lerp(rect_scale, Vector2(1.2, 1.2), .7)
	else:
		rect_scale = lerp(rect_scale, Vector2(1, 1), .7)
