extends Spatial


onready var functions = preload("res://scripts/Functions.gd").new()

enum PLANET_SIZE {
	small = 2,
	medium = 3,
	large = 4
}

func create_tri(corners):
	var normal = -functions.calc_surface_normal_newell_method(corners)
	var center = functions.center_tri(corners)
	
	var tmpTri = ImmediateGeometry.new()
	tmpTri.begin(Mesh.PRIMITIVE_TRIANGLES)
	tmpTri.set_normal(normal)
	for corner in corners:
		tmpTri.add_vertex(corner)
	tmpTri.end()
	
	var mat = SpatialMaterial.new()
	mat.vertex_color_use_as_albedo = true
	mat.albedo_color = Color.red
	tmpTri.material_override = mat
	tmpTri.cast_shadow = true
	
	var body = StaticBody.new()
	var shape = ConcavePolygonShape.new()
	shape.set_faces(corners)
	var owner_id = body.create_shape_owner(body)
	body.shape_owner_add_shape(owner_id, shape)
	tmpTri.add_child(body)
	
	tmpTri.set_meta("normal", normal)
	tmpTri.set_meta("center", center)
	
	add_child(tmpTri)

func create_mesh(lla1, lla2, lla3, curr_division):
		if curr_division == 0:
			var corners = PoolVector3Array()
			corners.append(functions.lla_to_xyz(lla1))
			corners.append(functions.lla_to_xyz(lla2))
			corners.append(functions.lla_to_xyz(lla3))
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
				create_mesh(corners[i[0] - 1], corners[i[1] - 1], corners[i[2] - 1], next_division)

func _ready():
	print(PLANET_SIZE)
	create_planet(PLANET_SIZE.small)
	
func create_planet(subdivisions=PLANET_SIZE.small):
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

	create_mesh(lla2, lla3, lla7, subdivisions)
	create_mesh(lla2, lla6, lla3, subdivisions)
	create_mesh(lla6, lla11, lla3, subdivisions)
	create_mesh(lla3, lla11, lla12, subdivisions)
	create_mesh(lla3, lla12, lla7, subdivisions)
	create_mesh(lla8, lla7, lla12, subdivisions)
	create_mesh(lla9, lla7, lla8, subdivisions)
	create_mesh(lla9, lla2, lla7, subdivisions)
	create_mesh(lla10, lla2, lla9, subdivisions)
	create_mesh(lla10, lla6, lla2, subdivisions)
	create_mesh(lla10, lla5, lla6, subdivisions)
	create_mesh(lla5, lla11, lla6, subdivisions)
	create_mesh(lla11, lla5, lla4, subdivisions)
	create_mesh(lla11, lla4, lla12, subdivisions)
	create_mesh(lla12, lla4, lla8, subdivisions)
	create_mesh(lla1, lla9, lla8, subdivisions)
	create_mesh(lla1, lla10, lla9, subdivisions)
	create_mesh(lla5, lla10, lla1, subdivisions)
	create_mesh(lla5, lla1, lla4, subdivisions)
	create_mesh(lla4, lla1, lla8, subdivisions)