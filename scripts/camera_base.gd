extends Spatial

const MOVE_MARGIN = 20
const MOVE_SPEED = 50

var move_vec = Vector3.ZERO
var move_angle = 0.0
var move_multiplier = 1.0

const ray_length = 1000
onready var arm = $CameraArm
onready var pivot = $CameraArm/Pivot
onready var cam = $CameraArm/Pivot/Camera

var camera_rotate = false
var camera_drag = false
var target_zoom = 20
var smooth_zoom = target_zoom
var ZOOM_SPEED = 10
var target_cam_pos = Vector3.ZERO
var motion = Vector3.ZERO
var gui

func _ready():
	gui = get_node('/root/Spatial/GUI')
	gui.connect('_input_button', self, '_on_input_button')
	gui.connect('_input_motion', self, '_on_input_motion')
	
	var space_state = get_world().direct_space_state
	var result = space_state.intersect_ray(Vector3(0,0,0), Vector3.UP * 1000)
	print('raycast')
	print(result)
	if result:
		arm.translate(result.position)
	
	target_cam_pos = cam.get_transform().origin
	print(target_cam_pos)

func _process(delta):
	var m_pos = get_viewport().get_mouse_position()
	calc_move(m_pos, delta)
	if Input.is_action_just_pressed("main_command"):
		move_all_units(m_pos)
		self.transform
	
	# zoom
	smooth_zoom = lerp(smooth_zoom, target_zoom, ZOOM_SPEED * delta)
	print('_1_')
	print(smooth_zoom)
	print(target_zoom - cam.get_transform().origin.z)
	print('_2_')
	if target_zoom - smooth_zoom > 0.05:
		
		motion = cam.get_transform().origin - Vector3(0,smooth_zoom,smooth_zoom)
		print('- - - - - - - - - - - -', motion)
		#cam.transform = 
		cam.translate(motion)
		return
		#cam.translate_object_local(Vector3(0,0,1) * delta * 100)
		print('target: ', target_cam_pos)
		print('position: ', cam.get_transform().origin)
		var targetVector = (cam.get_transform().origin - target_cam_pos).normalized()
		print('vector: ', targetVector)
		motion -= targetVector
		motion = motion * MOVE_SPEED * delta
		print('motion: ', motion)
	#cam.origin = cam.origin.linear_interpolate(Vector3(-0.5,0.25,-0.5), delta)
	

func calc_move(m_pos, delta):
	if camera_drag:
		return
		
	var v_size = get_viewport().size
	var _move_vec = Vector3.ZERO
	
	if m_pos.x < MOVE_MARGIN:
		_move_vec.z += 1
	if m_pos.y < MOVE_MARGIN:
		_move_vec.x -= 1
	if m_pos.x > v_size.x - MOVE_MARGIN:
		_move_vec.z -= 1
	if m_pos.y > v_size.y - MOVE_MARGIN:
		_move_vec.x += 1
	
	if _move_vec == Vector3.ZERO:
		if move_multiplier > 0.0:
			move_multiplier -= delta * 25
	else:
		move_vec = _move_vec
		move_multiplier += delta * 15
		
	if move_multiplier < 0.0:
		move_multiplier = 0.0
	if move_multiplier > 10.0:
		move_multiplier = 10.0
		
	if move_multiplier > 0.0 and move_vec != Vector3.ZERO:
		move_vec = move_vec.normalized()
		move_angle = delta * MOVE_SPEED / 100.0 * move_multiplier
		move(move_vec, move_angle)
		
func move(move_vec, move_angle):
	self.rotate_object_local(move_vec.normalized(), move_angle)

func move_all_units(m_pos):
	var result = raycast_from_mouse(m_pos, 1)
	if result:
		#get_tree().call_group("units", "move_to", result.position)
		print(result)
		print(result.collider.get_parent().get_meta("normal"))
		print(result.collider.get_parent().get_meta("center"))

func raycast_from_mouse(m_pos, collision_mask):
	var ray_start = cam.project_ray_origin(m_pos)
	var ray_end = ray_start + cam.project_ray_normal(m_pos) * ray_length
	var space_state = get_world().direct_space_state
	return space_state.intersect_ray(ray_start, ray_end, [], collision_mask)
	
func _on_input_button(event):
	if event.button_index == 4:
		target_zoom -= 1
		if target_zoom < 1:
			target_zoom = 1
		#target_cam_pos -= Vector3(0,1,1)
		#if target_cam_pos.z < 1:
		#	target_cam_pos = Vector3(0,1,1)
	elif event.button_index == 5:
		target_zoom += 1
		if target_zoom > 35:
			target_zoom = 35
		#target_cam_pos += Vector3(0,1,1)
		#if target_cam_pos.z > 35:
		#	target_cam_pos = Vector3(0,35,35)
	if event.button_index == 2 and event.pressed:
		camera_rotate = true
	else:
		camera_rotate = false
	if event.button_index == 3 and event.pressed:
		camera_drag = true
	else:
		camera_drag = false
		
func _on_input_motion(event):
	if camera_rotate:
		# pivot
		pivot.rotate_object_local(Vector3(-1, 0, 0), event.relative[1] / 100.0)
		if pivot.rotation_degrees.x < -45:
			pivot.rotate_x(deg2rad(abs(pivot.rotation_degrees.x) - 45))
		if pivot.rotation_degrees.x > 45:
			pivot.rotate_x(deg2rad(45 - pivot.rotation_degrees.x))
		# rotate
		rotate_object_local(Vector3(0, -1, 0), event.relative[0] / 100.0)
	if camera_drag:
		var x = event.relative[0]
		var z = event.relative[1]
		move_vec = Vector3(-z,0,x)
		move_angle = 0.05
		move(move_vec, move_angle)
		