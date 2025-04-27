extends Node

const ENTRYPOINT := "https://raw.githubusercontent.com/Elfiawesome/battle-things/refs/heads/main/server/"

@onready var sprite_2d: Sprite2D = $Sprite2D

var http_req: HTTPRequest = HTTPRequest.new()

func _ready() -> void:
	add_child(http_req)
	http_req.request_completed.connect(_on_request_completed)
	http_req.request(ENTRYPOINT + "asset/leaf.png")

func _on_request_completed(result: int, response_code: int, headers: PackedStringArray, body: PackedByteArray) -> void:
	var image := Image.new()
	image.load_png_from_buffer(body)
	var image_texture := ImageTexture.create_from_image(image)
	sprite_2d.texture = image_texture
