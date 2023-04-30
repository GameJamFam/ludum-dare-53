shader_type canvas_item;

const float speed = 3.0;

void fragment() {
	// Place fragment code here.
	vec2 new_uv = vec2(UV.x + TIME * speed, UV.y);
	COLOR = texture(TEXTURE, new_uv);
}
