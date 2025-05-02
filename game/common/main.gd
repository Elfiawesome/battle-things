extends Node

@onready var sprite_2d: Sprite2D = $Sprite2D
@onready var texture_rect: TextureRect = $CanvasLayer/TextureRect

var req: Req
var timer := Timer.new()

func _ready() -> void:
	req = Req.new()
	add_child(req)
	
	_on_timer()
	add_child(timer)
	timer.start(.5)
	timer.timeout.connect(_on_timer)

func _on_timer() -> void:
	var image_list := [
		"bagdle.png",
		"batts.png",
		"chain.png",
		"chandelier.png",
		"dark_matter.png",
		"end_of_the_day_cup.png",
		"fire.png",
		"keyboard.png",
		"king_of_snake.png",
		"leaf.png",
		"nature_ghost_soul.png",
		"nior.png",
		"pen.png",
		"sampan.png",
		"threeheaddragon.png",
		"usb_charger.png",
	]
	req.get_image_asset(image_list.pick_random(),
		func(texture: ImageTexture) -> void:
			#sprite_2d.texture = texture
			texture_rect.texture = texture
	)
