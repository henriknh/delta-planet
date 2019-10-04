shader_type spatial;

uniform sampler2D crater;
uniform sampler2D normalmap;
uniform sampler2D noise;

uniform vec4 color_dirt : hint_color = vec4(0.97, 0.75, 0.33, 1.0);
uniform vec4 color_mountain : hint_color = vec4(0.97, 0.75, 0.33, 1.0);

varying vec2 vertex_position;

float height(vec2 position) {
	float height = texture(crater, position).x - 0.5; //divide by the size of the PlaneMesh
	if(height < 0.0) {
		return 0.0;
	} else {
		return min(max(height, 0), 0.02);
	}
}

void vertex() {
	vertex_position = VERTEX.xz;
	float height = height(vertex_position);
	VERTEX.y = height;
	if(height == 0.0) {
		COLOR = color_dirt;
	} else if(height < 0.01) {
		COLOR = color_dirt * color_mountain;
	} else {
		COLOR = color_mountain;
	}
	//NORMAL = VERTEX;
}

void fragment(){
	NORMALMAP = texture(normalmap, vertex_position).xyz;
	ALBEDO = COLOR.xyz;
}