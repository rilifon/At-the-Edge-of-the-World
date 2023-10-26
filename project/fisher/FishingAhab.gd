extends AnimatedSprite

const TEST_AR = [
	preload("res://loot/loot1.tres"),
	preload("res://loot/loot2.tres"),
	preload("res://loot/loot3.tres"),
	preload("res://loot/loot4.tres"),
	preload("res://loot/loot5.tres"),
	preload("res://loot/loot6.tres"),
	preload("res://loot/loot7.tres"),
	preload("res://loot/loot8.tres"),
	preload("res://loot/loot9.tres"),
	preload("res://loot/loot10.tres")
]

onready var fish_spawner := $FishSpawner
onready var translator_sprite := $YogsuvianTranslator

func _ready():
	play()
	test()


func test():
	position = Vector2(257, 313)
	$YogsuvianTranslator.show()
	$YogsuvianTranslator.play("on")


func _unhandled_input(event):
	if event.is_action_pressed("skip"):
		TEST_AR.shuffle()
		fish(TEST_AR[0])


func fish(loot):
	fish_spawner.spawn_fish(loot)


func display_translator():
	translator_sprite.show()
	translator_sprite.play("off")


func set_translator_on(on: bool):
	translator_sprite.play("on" if on else "off")
