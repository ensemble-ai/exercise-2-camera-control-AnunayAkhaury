class_name PositionLockCamera
extends CameraControllerBase

func _ready() -> void:
	super()
	position = target.position

func _process(_delta: float) -> void:
	if !current:
		return
		
	super(_delta)
	global_position = target.global_position + Vector3(0.0, dist_above_target, 0.0)
	
	if draw_camera_logic:
		draw_logic()

func draw_logic() -> void:
	var cross_size = 5.0
	var mesh_instance := MeshInstance3D.new()
	var immediate_mesh := ImmediateMesh.new()
	var material := ORMMaterial3D.new()

	material.shading_mode = BaseMaterial3D.SHADING_MODE_UNSHADED
	material.albedo_color = Color(1, 1, 1) 

	mesh_instance.mesh = immediate_mesh
	mesh_instance.cast_shadow = GeometryInstance3D.SHADOW_CASTING_SETTING_OFF

	# Start drawing the cross lines
	immediate_mesh.surface_begin(Mesh.PRIMITIVE_LINES, material)

	# Horizontal line
	immediate_mesh.surface_add_vertex(Vector3(-cross_size / 2, 0, 0))  
	immediate_mesh.surface_add_vertex(Vector3(cross_size / 2, 0, 0))   

	# Vertical line
	immediate_mesh.surface_add_vertex(Vector3(0, 0, -cross_size / 2)) 
	immediate_mesh.surface_add_vertex(Vector3(0, 0, cross_size / 2))   

	immediate_mesh.surface_end()

	add_child(mesh_instance)
	
	if target:
		mesh_instance.global_transform = Transform3D.IDENTITY
		mesh_instance.global_position = target.global_position

	await get_tree().process_frame
	mesh_instance.queue_free()
