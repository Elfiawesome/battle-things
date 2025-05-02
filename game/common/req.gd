class_name Req extends Node

const SERVER_BASE_PATH := "https://raw.githubusercontent.com/Elfiawesome/battle-things/refs/heads/main/server/"
const SERVER_ASSET_PATH := "https://raw.githubusercontent.com/Elfiawesome/battle-things/refs/heads/main/server/asset/"

var cached_images: Dictionary[String, ImageTexture] = {}

func get_image_asset(asset_file: String, callable: Callable) -> void:
	if asset_file in cached_images:
		callable.call(cached_images.get(asset_file))
		return
	var http_req: HTTPRequest = HTTPRequest.new()
	add_child(http_req)
	http_req.request_completed.connect(
		func(_result: int, _response_code: int, _headers: PackedStringArray, body: PackedByteArray) -> void:
			print("result: %s response_code: %s asset_file: %s" % [_result, _response_code, asset_file])
			var image := Image.new()
			image.load_png_from_buffer(body)
			var image_texture := ImageTexture.create_from_image(image)
			http_req.queue_free()
			
			cached_images[asset_file] = image_texture
			callable.call(image_texture)
	)
	http_req.request(SERVER_ASSET_PATH + asset_file)
