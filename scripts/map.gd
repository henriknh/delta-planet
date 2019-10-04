extends MeshInstance

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.
	var noise = OpenSimplexNoise.new()
	
	noise.seed = 0
	noise.octaves = 4
	noise.period = 20.0
	noise.persistence = 0.8
	
	var map_size = 10
	
	for y in range(10):
		var line = ''
		for x in range(10):
			var pos = Vector2(x - map_size/2, y - map_size/2)
			line += str(noise.get_noise_2dv(pos))
		#print(line)
		
	
	var st = SurfaceTool.new()

	st.begin(Mesh.PRIMITIVE_TRIANGLES)
	
	# Prepare attributes for add_vertex.
	st.add_normal(Vector3(0, 0, 1))
	st.add_uv(Vector2(0, 0))
	# Call last for each vertex, adds the above attributes.
	st.add_vertex(Vector3(0, 1, 2))
	st.add_normal(Vector3(0, 0, -1));
	st.add_color(Color(1, 0, 0, 1));
	st.add_vertex(Vector3(-1, 0, 0));
	
	
	st.add_normal(Vector3(0, 0, 1))
	st.add_uv(Vector2(0, 1))
	st.add_vertex(Vector3(2, 1, 2))
	
	st.add_normal(Vector3(0, 0, 1))
	st.add_uv(Vector2(1, 1))
	st.add_vertex(Vector3(2, 1, 0))
	
	st.add_normal(Vector3(0, 0, 1))
	st.add_uv(Vector2(1, 1))
	st.add_vertex(Vector3(0, 2, 0))
	
	st.index()
	
	st.generate_normals()
	st.generate_tangents()
	
	# Commit to a mesh.
	mesh = st.commit()
	#make_cube()

var array_quad_vertices = [];
var array_quad_indices = [];
 
var dictionary_check_quad_vertices = {};
 
const CUBE_SIZE = 0.5;

func make_cube():
	array_quad_vertices = [];
	array_quad_indices = [];
	dictionary_check_quad_vertices = {};
	
	var result_mesh = Mesh.new();
	var surface_tool = SurfaceTool.new();
	
	surface_tool.begin(Mesh.PRIMITIVE_TRIANGLES);
	
	var vert_north_topright = Vector3(-CUBE_SIZE, CUBE_SIZE, CUBE_SIZE);
	var vert_north_topleft = Vector3(CUBE_SIZE, CUBE_SIZE, CUBE_SIZE);
	var vert_north_bottomleft = Vector3(CUBE_SIZE, CUBE_SIZE, -CUBE_SIZE);
	var vert_north_bottomright = Vector3(-CUBE_SIZE, CUBE_SIZE, -CUBE_SIZE);
	
	var vert_south_topright = Vector3(-CUBE_SIZE, -CUBE_SIZE, CUBE_SIZE);
	var vert_south_topleft = Vector3(CUBE_SIZE, -CUBE_SIZE, CUBE_SIZE);
	var vert_south_bottomleft = Vector3(CUBE_SIZE, -CUBE_SIZE, -CUBE_SIZE);
	var vert_south_bottomright = Vector3(-CUBE_SIZE, -CUBE_SIZE, -CUBE_SIZE);
	
	
	# Make the six quads for needed to make a box!
	# ============================================
	# IMPORTANT: You have to input the points in the going either clockwise, or counter clockwise
	# or the add_quad function will not work!
	
	add_quad(vert_south_topright, vert_south_topleft, vert_south_bottomleft, vert_south_bottomright);
	add_quad(vert_north_topright, vert_north_bottomright, vert_north_bottomleft, vert_north_topleft);
	
	add_quad(vert_north_bottomleft, vert_north_bottomright, vert_south_bottomright, vert_south_bottomleft);
	add_quad(vert_north_topleft, vert_south_topleft, vert_south_topright, vert_north_topright);
	
	add_quad(vert_north_topright, vert_south_topright, vert_south_bottomright, vert_north_bottomright);
	add_quad(vert_north_topleft, vert_north_bottomleft, vert_south_bottomleft, vert_south_topleft);
	# ============================================
	
	for vertex in array_quad_vertices:
		surface_tool.add_vertex(vertex);
	for index in array_quad_indices:
		surface_tool.add_index(index);
	
	surface_tool.generate_normals();
	
	result_mesh = surface_tool.commit();
	self.mesh = result_mesh;
 
 
func add_quad(point_1, point_2, point_3, point_4):
	
	var vertex_index_one = -1;
	var vertex_index_two = -1;
	var vertex_index_three = -1;
	var vertex_index_four = -1;
	
	vertex_index_one = _add_or_get_vertex_from_array(point_1);
	vertex_index_two = _add_or_get_vertex_from_array(point_2);
	vertex_index_three = _add_or_get_vertex_from_array(point_3);
	vertex_index_four = _add_or_get_vertex_from_array(point_4);
	
	array_quad_indices.append(vertex_index_one)
	array_quad_indices.append(vertex_index_two)
	array_quad_indices.append(vertex_index_three)
	
	array_quad_indices.append(vertex_index_one)
	array_quad_indices.append(vertex_index_three)
	array_quad_indices.append(vertex_index_four)
 
 
func _add_or_get_vertex_from_array(vertex):
	if dictionary_check_quad_vertices.has(vertex) == true:
		return dictionary_check_quad_vertices[vertex];
    
	else:
		array_quad_vertices.append(vertex);
		
		dictionary_check_quad_vertices[vertex] = array_quad_vertices.size()-1;
		return array_quad_vertices.size()-1;
