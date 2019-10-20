extends Spatial


onready var functions = preload("res://scripts/Functions.gd").new()
onready var shader_planet = preload("res://assets/shaders/planet.tres")
onready var shader_outline = preload("res://assets/shaders/outline.tres")
onready var shader_outline_script = preload("res://assets/shaders/outline_script.tres")

enum PLANET_SIZE {
	small = 2,
	medium = 3,
	large = 4
}
export(PLANET_SIZE) var planet_size = PLANET_SIZE.small

var immGeo = ImmediateGeometry.new()

func create_tri(corners):
	var normal = -functions.calc_surface_normal_newell_method(corners)
	var center = functions.center_tri(corners)
	
	immGeo.set_normal(normal)
	for corner in corners:
		immGeo.add_vertex(corner)
	
	var body = StaticBody.new()
	var shape = ConcavePolygonShape.new()
	shape.set_faces(corners)
	var owner_id = body.create_shape_owner(body)
	body.shape_owner_add_shape(owner_id, shape)
	immGeo.add_child(body)
	
	#tmpTri.set_meta("normal", normal)
	#tmpTri.set_meta("center", center)

func create_mesh(scale, lla1, lla2, lla3, curr_division):
		if curr_division == 0:
			var corners = PoolVector3Array()
			corners.append(functions.lla_to_xyz(lla1) * scale)
			corners.append(functions.lla_to_xyz(lla2) * scale)
			corners.append(functions.lla_to_xyz(lla3) * scale)
			create_tri(corners)
		else:
			var corner1 = lla1
			var corner2 = functions.mid_point(lla1, lla2)
			var corner3 = lla2
			var corner4 = functions.mid_point(lla2, lla3)
			var corner5 = lla3
			var corner6 = functions.mid_point(lla3, lla1)
			var corners = [corner1, corner2, corner3, corner4, corner5, corner6]
			var order = [[1, 2, 6], [2, 4, 6], [2, 3, 4], [4, 5, 6]]
			for i in order:
				var next_division = curr_division - 1
				create_mesh(scale, corners[i[0] - 1], corners[i[1] - 1], corners[i[2] - 1], next_division)

func _ready():
	print('Planet size: ', planet_size)
	create_planet(planet_size)
	
func create_planet(scale=PLANET_SIZE.small):
	
	immGeo = ImmediateGeometry.new()
	
	immGeo.begin(Mesh.PRIMITIVE_TRIANGLES)
	
	var lla1 = Vector3(0, -58.5, 0)
	var lla2 = Vector3(0, 58.5, 0)
	var lla3 = Vector3(180, 58.5, 0)
	var lla4 = Vector3(180, -58.5, 0)
	var lla5 = Vector3(90, -31.5, 0)
	var lla6 = Vector3(90, 31.5, 0)
	var lla7 = Vector3(-90, 31.5, 0)
	var lla8 = Vector3(-90, -31.5, 0)
	var lla9 = Vector3(-31.5, 0, 0)
	var lla10 = Vector3(31.5, 0, 0)
	var lla11 = Vector3(148.5, 0, 0)
	var lla12 = Vector3(-148.5, 0, 0)

	create_mesh(scale, lla2, lla3, lla7, scale)
	create_mesh(scale, lla2, lla6, lla3, scale)
	create_mesh(scale, lla6, lla11, lla3, scale)
	create_mesh(scale, lla3, lla11, lla12, scale)
	create_mesh(scale, lla3, lla12, lla7, scale)
	create_mesh(scale, lla8, lla7, lla12, scale)
	create_mesh(scale, lla9, lla7, lla8, scale)
	create_mesh(scale, lla9, lla2, lla7, scale)
	create_mesh(scale, lla10, lla2, lla9, scale)
	create_mesh(scale, lla10, lla6, lla2, scale)
	create_mesh(scale, lla10, lla5, lla6, scale)
	create_mesh(scale, lla5, lla11, lla6, scale)
	create_mesh(scale, lla11, lla5, lla4, scale)
	create_mesh(scale, lla11, lla4, lla12, scale)
	create_mesh(scale, lla12, lla4, lla8, scale)
	create_mesh(scale, lla1, lla9, lla8, scale)
	create_mesh(scale, lla1, lla10, lla9, scale)
	create_mesh(scale, lla5, lla10, lla1, scale)
	create_mesh(scale, lla5, lla1, lla4, scale)
	create_mesh(scale, lla4, lla1, lla8, scale)
	
	immGeo.material_override = shader_planet
	immGeo.cast_shadow = true
	immGeo.end()
	immGeo.set_name('planet')
	add_child(immGeo)
	
	
	
	var mesh = MeshInstance.new()
	mesh.mesh = SphereMesh.new()
	mesh.set_scale(Vector3(scale*50, scale*50, scale*50))
	mesh.set_name('preview')
	mesh.material_override = shader_planet
	add_child(mesh)
	
	add_to_group('planets')