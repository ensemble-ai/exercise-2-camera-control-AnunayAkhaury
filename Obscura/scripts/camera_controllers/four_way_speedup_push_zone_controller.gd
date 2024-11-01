class_name FourWaySpeedupPushZoneCamera
extends CameraControllerBase


@export var push_ratio:float = 0.6
@export var pushbox_top_left:Vector2 = Vector2(-30, -30)
@export var pushbox_bottom_right:Vector2 = Vector2(30, 30) 
@export var speedup_zone_top_left:Vector2 = Vector2(-10, -10)
@export var speedup_zone_bottom_right:Vector2 = Vector2(10, 10)
@export var box_width:float = 10.0
@export var box_height:float = 10.0

func _ready() -> void:
	super()
	position = target.position
	

func _process(delta: float) -> void:
	super(delta)
	if !current:
		return
	
	if draw_camera_logic:
		draw_logic()
	
	var tpos = target.global_position + Vector3(0.0, dist_above_target, 0.0)
	var cpos = global_position
	var pushbox_width = pushbox_bottom_right.x - pushbox_top_left.x
	var pushbox_height = pushbox_bottom_right.y - pushbox_top_left.y
	var speed_frame_left_edge = global_position.x + speedup_zone_top_left.x
	var speed_frame_right_edge = global_position.x + speedup_zone_bottom_right.x
	var speed_frame_top_edge = global_position.z + speedup_zone_top_left.y
	var speed_frame_bottom_edge = global_position.z + speedup_zone_bottom_right.y
	#boundary checks
	#left
	if tpos.x >= speed_frame_left_edge and tpos.x <= speed_frame_right_edge and tpos.z >= speed_frame_top_edge and tpos.z <= speed_frame_bottom_edge :
		return
	else:
		global_position = global_position.lerp(tpos, push_ratio * delta)
		
	var diff_between_left_edges = (tpos.x - target.WIDTH / 2.0) - (cpos.x - pushbox_width / 2.0)
	if diff_between_left_edges < 0:
		global_position.x += diff_between_left_edges
	# right
	var diff_between_right_edges = (tpos.x + target.WIDTH / 2.0) - (cpos.x + pushbox_width / 2.0)
	if diff_between_right_edges > 0:
		global_position.x += diff_between_right_edges
	# top
	var diff_between_top_edges = (tpos.z - target.HEIGHT / 2.0) - (cpos.z - pushbox_height / 2.0)
	if diff_between_top_edges < 0:
		global_position.z += diff_between_top_edges
	# bottom
	var diff_between_bottom_edges = (tpos.z + target.HEIGHT / 2.0) - (cpos.z + pushbox_height / 2.0)
	if diff_between_bottom_edges > 0:
		global_position.z += diff_between_bottom_edges
		



func draw_logic() -> void:
	var mesh_instance := MeshInstance3D.new()
	var immediate_mesh := ImmediateMesh.new()
	var material := ORMMaterial3D.new()
	var pushbox_width = pushbox_bottom_right.x - pushbox_top_left.x
	var pushbox_height = pushbox_bottom_right.y - pushbox_top_left.y
	var speed_zone_width = speedup_zone_bottom_right.x - speedup_zone_top_left.x
	var speed_zone_height = speedup_zone_bottom_right.y - speedup_zone_top_left.y
	
	mesh_instance.mesh = immediate_mesh
	mesh_instance.cast_shadow = GeometryInstance3D.SHADOW_CASTING_SETTING_OFF
	
	var left:float = -pushbox_width / 2
	var right:float = pushbox_width / 2
	var top:float = -pushbox_height / 2
	var bottom:float = pushbox_height / 2
	
	var speed_left:float = -speed_zone_width / 2
	var speed_right:float = speed_zone_width / 2
	var speed_top:float = -speed_zone_height / 2
	var speed_bottom:float = speed_zone_height / 2
	
	immediate_mesh.surface_begin(Mesh.PRIMITIVE_LINES, material)
	immediate_mesh.surface_add_vertex(Vector3(right, 0, top))
	immediate_mesh.surface_add_vertex(Vector3(right, 0, bottom))
	
	immediate_mesh.surface_add_vertex(Vector3(right, 0, bottom))
	immediate_mesh.surface_add_vertex(Vector3(left, 0, bottom))
	
	immediate_mesh.surface_add_vertex(Vector3(left, 0, bottom))
	immediate_mesh.surface_add_vertex(Vector3(left, 0, top))
	
	immediate_mesh.surface_add_vertex(Vector3(left, 0, top))
	immediate_mesh.surface_add_vertex(Vector3(right, 0, top))

	immediate_mesh.surface_add_vertex(Vector3(speed_right, 0, speed_top))
	immediate_mesh.surface_add_vertex(Vector3(speed_right, 0, speed_bottom))
	
	immediate_mesh.surface_add_vertex(Vector3(speed_right, 0, speed_bottom))
	immediate_mesh.surface_add_vertex(Vector3(speed_left, 0, speed_bottom))
	
	immediate_mesh.surface_add_vertex(Vector3(speed_left, 0, speed_bottom))
	immediate_mesh.surface_add_vertex(Vector3(speed_left, 0, speed_top))
	
	immediate_mesh.surface_add_vertex(Vector3(speed_left, 0, speed_top))
	immediate_mesh.surface_add_vertex(Vector3(speed_right, 0, speed_top))
	immediate_mesh.surface_end()

	material.shading_mode = BaseMaterial3D.SHADING_MODE_UNSHADED
	material.albedo_color = Color.BLACK
	
	add_child(mesh_instance)
	mesh_instance.global_transform = Transform3D.IDENTITY
	mesh_instance.global_position = Vector3(global_position.x, target.global_position.y, global_position.z)
	
	await get_tree().process_frame
	mesh_instance.queue_free()
