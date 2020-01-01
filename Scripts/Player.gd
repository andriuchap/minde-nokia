extends KinematicBody2D

var velocity = Vector2(0,0);

var is_jumping = false;
var wants_to_jump = false;
var jump_frame_num = 0;
var was_grounded = false;

export(int) var jump_speed = -2;
export(int) var max_jump_frame_num = 5;

export(AudioStreamSample) var jump_sound;
export(AudioStreamSample) var land_sound;

func _ready():
	pass # Replace with function body.

func _physics_process(delta):
	var moving = false;
	velocity = Vector2(0,4);
	
	if Input.is_action_pressed("ui_left"):
		moving = true;
		$PlayerSprite.scale.x = -1;
		velocity.x = -1;
	elif Input.is_action_pressed("ui_right"):
		moving = true;
		$PlayerSprite.scale.x = 1;
		velocity.x = 1;
	
	if Input.is_action_just_pressed("ui_up"):
		wants_to_jump = true;
	
	if is_on_floor() and wants_to_jump:
		velocity.y = jump_speed;
		is_jumping = true;
		wants_to_jump = false
		jump_frame_num = 0;
		_play_sound(jump_sound);
	elif is_jumping and Input.is_action_pressed("ui_up"):
		if jump_frame_num < max_jump_frame_num:
			velocity.y = jump_speed;
			jump_frame_num += 1;
		else:
			is_jumping = false;
			velocity.y = 0;
		
	move_and_slide(velocity / delta, Vector2.UP);
	
	if is_on_floor() and !was_grounded:
		_play_sound(land_sound);
	
	was_grounded = is_on_floor();
	
	var position_offset = Vector2(fmod(position.x, 1.0), fmod(position.y, 1.0));
	
	if position_offset.x < 0.5:
		position_offset.x = -position_offset.x
	else:
		position_offset.x = 1.0 - position_offset.x
	
	if position_offset.y < 0.5:
		position_offset.y = -position_offset.y
	else:
		position_offset.y = 1.0 - position_offset.y
	
	$PlayerSprite.position = position_offset;
		
	_process_anim_state(moving, !is_on_floor(), velocity.y <= 0);
	
func _process_anim_state(moving, in_air, rising):
	$PlayerAnims["parameters/conditions/air"] = in_air;
	$PlayerAnims["parameters/conditions/ground"] = !in_air;
	
	$PlayerAnims["parameters/conditions/moving"] = moving;
	$PlayerAnims["parameters/conditions/standing"] = !moving;
	
	$PlayerAnims["parameters/conditions/rising"] = rising;
	$PlayerAnims["parameters/conditions/falling"] = !rising;
	
func _play_sound(sound):
	var main_audio_player = get_tree().get_current_scene().get_node("MainAudioPlayer");
	print(main_audio_player);
	main_audio_player.stream = sound;
	main_audio_player.play();
	