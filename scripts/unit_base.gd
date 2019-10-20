extends Spatial

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

# Called when the node enters the scene tree for the first time.
var body
var mesh
func _ready():
	if has_node("StaticBody"):
		body = $StaticBody
	elif has_node("KinematicBody"):
		body = $KinematicBody
	mesh = $MeshInstance

func pending():
	print('pending')
	setAlpha(0.5)
	
func init():
	print('init')
	setAlpha(1.0)
	
func _onHover():
	print('hover')

func destroy():
	print('destroy')
	queue_free()
	
func setAlpha(alpha):
	var material = mesh.get_surface_material(0)
	var r = material.albedo_color.r
	var g = material.albedo_color.g
	var b = material.albedo_color.b
	material.albedo_color = Color(r, g, b, alpha)
	mesh.set_surface_material(0, material)
	