extends Reference


var functions = load("res://scripts/planet_functions.gd").new()

static func create_tri(immGeo, corners, is_preview = false):
	var functions = load("res://scripts/planet_functions.gd").new()
	var normal = -functions.calc_surface_normal_newell_method(corners)
	var center = functions.center_tri(corners)
	
	immGeo.set_normal(normal)
	for corner in corners:
		immGeo.add_vertex(corner)
		
	if not is_preview and false:
		var body = StaticBody.new()
		var shape = ConcavePolygonShape.new()
		shape.set_faces(corners)
		var owner_id = body.create_shape_owner(body)
		body.shape_owner_add_shape(owner_id, shape)
		immGeo.add_child(body)
	
		body.set_meta("normal", normal)
		body.set_meta("center", center)

static func create_mesh(immGeo, scale, lla1, lla2, lla3, curr_division, is_preview):
		var functions = load("res://scripts/planet_functions.gd").new()
		if curr_division == 0:
			var corners = PoolVector3Array()
			corners.append(functions.lla_to_xyz(lla1) * scale)
			corners.append(functions.lla_to_xyz(lla2) * scale)
			corners.append(functions.lla_to_xyz(lla3) * scale)
			create_tri(immGeo, corners, is_preview)
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
				create_mesh(immGeo, scale, corners[i[0] - 1], corners[i[1] - 1], corners[i[2] - 1], next_division, is_preview)

	
static func create(size, is_preview, biome):
	var immGeo = ImmediateGeometry.new()
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

	create_mesh(immGeo, size, lla2, lla3, lla7, size, is_preview)
	create_mesh(immGeo, size, lla2, lla6, lla3, size, is_preview)
	create_mesh(immGeo, size, lla6, lla11, lla3, size, is_preview)
	create_mesh(immGeo, size, lla3, lla11, lla12, size, is_preview)
	create_mesh(immGeo, size, lla3, lla12, lla7, size, is_preview)
	create_mesh(immGeo, size, lla8, lla7, lla12, size, is_preview)
	create_mesh(immGeo, size, lla9, lla7, lla8, size, is_preview)
	create_mesh(immGeo, size, lla9, lla2, lla7, size, is_preview)
	create_mesh(immGeo, size, lla10, lla2, lla9, size, is_preview)
	create_mesh(immGeo, size, lla10, lla6, lla2, size, is_preview)
	create_mesh(immGeo, size, lla10, lla5, lla6, size, is_preview)
	create_mesh(immGeo, size, lla5, lla11, lla6, size, is_preview)
	create_mesh(immGeo, size, lla11, lla5, lla4, size, is_preview)
	create_mesh(immGeo, size, lla11, lla4, lla12, size, is_preview)
	create_mesh(immGeo, size, lla12, lla4, lla8, size, is_preview)
	create_mesh(immGeo, size, lla1, lla9, lla8, size, is_preview)
	create_mesh(immGeo, size, lla1, lla10, lla9, size, is_preview)
	create_mesh(immGeo, size, lla5, lla10, lla1, size, is_preview)
	create_mesh(immGeo, size, lla5, lla1, lla4, size, is_preview)
	create_mesh(immGeo, size, lla4, lla1, lla8, size, is_preview)
	
	var shader_planet = null
	match biome:
		Enums.PLANET_BIOME.ROCK:
			shader_planet = load("res://assets/shaders/planet_rock.tres")
		Enums.PLANET_BIOME.TERRA:
			shader_planet = load("res://assets/shaders/planet_terra.tres")
		Enums.PLANET_BIOME.ICE:
			shader_planet = load("res://assets/shaders/planet_ice.tres")
	immGeo.material_override = shader_planet
	immGeo.cast_shadow = true
	immGeo.end()
	
	#add_child(immGeo)
	
	return immGeo
	