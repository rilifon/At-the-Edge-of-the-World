extends CanvasLayer

onready var shader_rect = $ShaderRect

const BG = 0
const FG = 1

export(Array, Array, Color) var palettes = [
	[Color.black, Color.white],
	[Color("#0b1000"), Color("#a4b26f")], #The Night - lospec
	[Color("#002f40"), Color("#ffd500")], #Gato Roboto Urine - lospec
	[Color("#3e232c"), Color("#edf6d6")], #Pixel ink - lospec
	[Color("#29161d"), Color("#fa9495")], #Gato Roboto Chewed Gum - lospec
	[Color.red, Color.black],
]
export var transition_duration := .5

var curr_palette := 0
var curr_bg := Color.black
var curr_fg := Color.white
var transition_timer : float


func _ready():
	set_process(false)
	randomize()
	curr_palette = randi()%palettes.size()

func _process(delta):
	var bg_color = palettes[curr_palette][BG]
	var fg_color = palettes[curr_palette][FG]
	
	if transition_timer < transition_duration:
		var weight = transition_timer / transition_duration
		bg_color = lerp(curr_bg, bg_color, weight)
		fg_color = lerp(curr_fg, fg_color, weight)
		transition_timer += delta
	else:
		set_process(false)
	
	shader_rect.material.set_shader_param("bg_color", bg_color)
	shader_rect.material.set_shader_param("fg_color", fg_color)


func change_to(palette: int):
	curr_bg = shader_rect.material.get_shader_param("bg_color")
	curr_fg = shader_rect.material.get_shader_param("fg_color")
	curr_palette = palette
	transition_timer = 0
	set_process(true)
