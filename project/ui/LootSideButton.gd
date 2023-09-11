extends Button

const HOVER_SCALE = 1.1
const SCALE_SPEED = 3

var mouse_hover

func _process(dt):
	if mouse_hover and not disabled and visible:
		rect_scale.x = min(rect_scale.x + SCALE_SPEED*dt, HOVER_SCALE)
		rect_scale.y = min(rect_scale.y + SCALE_SPEED*dt, HOVER_SCALE)
	else:
		rect_scale.x = max(rect_scale.x - SCALE_SPEED*dt, 1.0)
		rect_scale.y = max(rect_scale.y - SCALE_SPEED*dt, 1.0)


func mouse_entered():
	if not disabled and visible:
		AudioManager.play_sfx("hover_button")
		mouse_hover = true


func mouse_exited():
	if not disabled and visible:
		AudioManager.play_sfx("hover_button")
		mouse_hover = false
