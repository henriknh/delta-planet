extends Spatial

var camera = null
var gui

var curr_spawn_type = null
var selected = null
var ray_length = 1000

func _ready():
	camera = get_node('/root/Spatial/CameraBase/CameraArm/Pivot/Camera')
	gui = get_node('/root/Spatial/GUI')
	
	gui.connect('_spawn_create', self, '_on_create')
	gui.connect('_spawn_cancel', self, '_on_cancel')
	gui.connect('_input_button', self, '_on_input_button')
	gui.connect('_input_motion', self, '_on_input_motion')
		
func _on_input_button(event):
	if selected:
		if event.pressed and event.button_index == 1:
			print(event)
			finish()
		elif event.pressed and event.button_index != 1:
			gui._on_spawn_cancel()

func _on_input_motion(event):
	if selected:
		move()

func _on_create(spawn_type):
	if selected:
		_on_cancel()
	
	if spawn_type && spawn_type != curr_spawn_type:
		var scene = load('res://assets/prefabs/%s.tscn' % spawn_type)
		var scene_instance = scene.instance()
		scene_instance.set_translation(Vector3(0,-10000000,0))
		add_child(scene_instance)
		selected = scene_instance
		curr_spawn_type = spawn_type
		selected.pending()
		
func _on_cancel():
	print('_on_cancel')
	if selected:
		selected.destroy()
		selected = null
		curr_spawn_type = null

func finish():
	selected.init()
	selected = null
	curr_spawn_type = null
	
func move():	
	var m_pos = get_viewport().get_mouse_position()
	var ray_start = camera.project_ray_origin(m_pos)
	var ray_end = ray_start + camera.project_ray_normal(m_pos) * ray_length
	var space_state = get_world().direct_space_state
	var result = space_state.intersect_ray(ray_start, ray_end, [], 1)
	
	print(result)
	if result:
		var position = result.collider.get_parent().get_meta('center')
		selected.set_translation(position)
		
		var n1norm = selected.transform.basis.y.normalized()
		var n2norm = result.collider.get_parent().get_meta('normal').normalized()
		
		var cosa = n1norm.dot(n2norm)
		var alpha = acos(cosa)
		var axis = n1norm.cross(n2norm)
		axis = axis.normalized()
		
		if !is_nan(alpha):
			selected.transform = selected.transform.rotated(axis, alpha)