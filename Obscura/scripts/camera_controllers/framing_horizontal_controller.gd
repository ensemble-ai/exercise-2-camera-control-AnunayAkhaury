class_name AutoScrollCamera
extends CameraControllerBase

@export var top_left: Vector2 = Vector2(-10, 7.5)
@export var bottom_right: Vector2 = Vector2(10, -7.5)
@export var autoscroll_speed: Vector3 = Vector3(5.0, 0.0, 0.0)  # X and Z axes (scroll speed)

func _ready() -> void:
	super()
	position = target.position
	

func _process(delta: float) -> void:
	if !current:
		return
	
	if draw_camera_logic:
		draw_logic()
	
	global_position += autoscroll_speed * delta
	var player_pos = target.global_position + Vector3(0.0, dist_above_target, 0.0)
	
	var frame_left_edge = global_position.x + top_left.x
	var frame_right_edge = global_position.x + bottom_right.x
	var frame_top_edge = global_position.z + top_left.y
	var frame_bottom_edge = global_position.z + bottom_right.y
	if player_pos.x < frame_left_edge:
			target.global_position.x = frame_left_edge
	else:
		target.global_position.x = clamp(player_pos.x, frame_left_edge, frame_right_edge)
	target.global_position.z = clamp(player_pos.z, frame_bottom_edge, frame_top_edge)
	
	

		
	super(delta)


func draw_logic() -> void:
	var mesh_instance := MeshInstance3D.new()
	var immediate_mesh := ImmediateMesh.new()
	var material := ORMMaterial3D.new()
	
	mesh_instance.mesh = immediate_mesh
	mesh_instance.cast_shadow = GeometryInstance3D.SHADOW_CASTING_SETTING_OFF
	
	var left:float = top_left.x 
	var right:float = bottom_right.x 
	var top:float = top_left.y 
	var bottom:float = bottom_right.y 
	
	immediate_mesh.surface_begin(Mesh.PRIMITIVE_LINES, material)
	immediate_mesh.surface_add_vertex(Vector3(right, 0, top))
	immediate_mesh.surface_add_vertex(Vector3(right, 0, bottom))
	
	immediate_mesh.surface_add_vertex(Vector3(right, 0, bottom))
	immediate_mesh.surface_add_vertex(Vector3(left, 0, bottom))
	
	immediate_mesh.surface_add_vertex(Vector3(left, 0, bottom))
	immediate_mesh.surface_add_vertex(Vector3(left, 0, top))
	
	immediate_mesh.surface_add_vertex(Vector3(left, 0, top))
	immediate_mesh.surface_add_vertex(Vector3(right, 0, top))
	immediate_mesh.surface_end()

	material.shading_mode = BaseMaterial3D.SHADING_MODE_UNSHADED
	material.albedo_color = Color.BLACK
	
	add_child(mesh_instance)
	mesh_instance.global_transform = Transform3D.IDENTITY
	mesh_instance.global_position = Vector3(global_position.x, target.global_position.y, global_position.z)
	
	#mesh is freed after one update of _process
	await get_tree().process_frame
	mesh_instance.queue_free()
