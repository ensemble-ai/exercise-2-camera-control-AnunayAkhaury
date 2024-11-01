class_name LerpSmoothingTargetLockCamera
extends CameraControllerBase

@export var follow_speed: float = 7.5
@export var catchup_speed: float = 2.0
@export var leash_distance: float = 10.0
@export var catchup_delay_duration: float = 2.0
var time_since_stopped: float = 0.0
var timer_running: bool = false
var waiting: bool = false

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
	var target_position = target.global_position + Vector3(0.0, dist_above_target, 0.0)
	var distance_to_target = global_position.distance_to(target_position)

	if target.velocity == Vector3(0, 0, 0):
		time_since_stopped += _delta
		if time_since_stopped >= catchup_delay_duration:
			global_position = global_position.lerp(target_position, catchup_speed * _delta)
			if global_position.distance_to(target_position) < 0.5:
				time_since_stopped = 0.0
	elif target.is_hyper_speed:
		global_position = global_position.lerp(
			target_position + (direction_3d * leash_distance),
			(target.HYPER_SPEED / 5) * _delta
		)
	else:
		if distance_to_target <= leash_distance:
			global_position = global_position.lerp(
				target_position + (direction_3d * leash_distance),
				follow_speed * _delta
			)
		else:
			global_position = global_position.lerp(target_position, follow_speed * 2 * _delta)
			
		
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
