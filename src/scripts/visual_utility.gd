extends Node

func add_transparent_border(input_texture: Texture2D) -> ImageTexture:

	var original_image: Image = input_texture.get_image()
	
	var bordered_image = Image.create(
		original_image.get_width() + 2, original_image.get_height() + 2,
		 false, Image.FORMAT_RGBA8)
		
	bordered_image.blit_rect(original_image, Rect2(Vector2.ZERO, original_image.get_size()), Vector2(1, 1))

	var new_texture = ImageTexture.new()
	new_texture.set_image(bordered_image)

	return new_texture
