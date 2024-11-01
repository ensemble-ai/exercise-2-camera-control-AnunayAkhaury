class_name LerpSmoothingTargetLockCamera
extends CameraControllerBase

@export var follow_speed: float = 7.5
@export var catchup_speed: float = 1.0
@export var leash_distance: float = 10.0
@export var catchup_delay_duration: float = 2.0
var time_since_stopped: float = 0.0

func _ready() -> void:
	super()
	set_process_priority(0)
	position = target.position
	
func _process(_delta: float) -> void:
	if !current:
		return
	
	super(_delta)
	var input_direction = Vector2(
		Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left"),
		Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
	).normalized()
	var direction_3d = Vector3(input_direction.x, 0.0, input_direction.y)
	var t_pos = target.global_position + Vector3(0.0, dist_above_target, 0.0)
	var distance_to_target = global_position.distance_to(t_pos)

	var c_pos = global_position  
	var effective_speed = follow_speed
	if target.velocity == Vector3(0, 0, 0):
		time_since_stopped += _delta
		if time_since_stopped >= catchup_delay_duration:
			c_pos = t_pos
			effective_speed = catchup_speed
		else:
			c_pos = global_position
			effective_speed = 0
	else:
		time_since_stopped = 0.0
		if distance_to_target > leash_distance:
			c_pos = t_pos
			effective_speed = follow_speed * 2
		else:
			c_pos = t_pos + (direction_3d * leash_distance)
			effective_speed = follow_speed

	if target.is_hyper_speed:
		effective_speed = (target.HYPER_SPEED / 5)

	global_position = global_position.lerp(c_pos, effective_speed * _delta)

			
		
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

	immediate_mesh.surface_begin(Mesh.PRIMITIVE_LINES, material)

	immediate_mesh.surface_add_vertex(Vector3(-cross_size / 2, 0, 0))  
	immediate_mesh.surface_add_vertex(Vector3(cross_size / 2, 0, 0))   

	immediate_mesh.surface_add_vertex(Vector3(0, 0, -cross_size / 2)) 
	immediate_mesh.surface_add_vertex(Vector3(0, 0, cross_size / 2))   

	immediate_mesh.surface_end()

	add_child(mesh_instance)
	
	mesh_instance.global_transform = Transform3D.IDENTITY
	mesh_instance.global_position = Vector3(global_position.x, target.global_position.y, global_position.z)

	await get_tree().process_frame
	mesh_instance.queue_free()
