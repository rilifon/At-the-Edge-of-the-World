extends AnimatedSprite

onready var fish_spawner := $FishSpawner
onready var translator_sprite := $YogsuvianTranslator

func _ready():
	play()
	if Global.remove_distortion:
		display_translator()


func fish(loot):
	fish_spawner.spawn_fish(loot)


func display_translator():
	translator_sprite.show()
	translator_sprite.play("off")


func set_translator_on(on: bool):
	if translator_sprite.visible:
		translator_sprite.play("on" if on else "off")
