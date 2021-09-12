extends Control

## references
onready var LooseWarning = $LooseProgressWarning
onready var LooseSaveWarning = $LooseSaveWarning
export (NodePath) var Game

# saved before pausing the game, used in case a save is created
var saved_image

var current_saved = false

################################################################################
##								PUBLIC
################################################################################

func add_game_node(node):
	$MenuAnimations.play("Fade")
	get_node(Game).add_child(node)
	node.connect("timeline_end", self, "_on_game_ended")
	yield($MenuAnimations, "animation_finished")
	$MainMenu.hide()
	$SubMenus.hide()
	$MenuAnimations.play("reset")

func is_game_playing() -> bool:
	return bool(get_node(Game).get_child_count())

func pause_game():
	current_saved = false
	get_node(Game).hide()
	$MenuMusic.playing = true
	get_tree().paused = true

func resume_game():
	get_node(Game).show()
	$MenuMusic.playing = false
	get_tree().paused = false

################################################################################
##								PRIVATE
################################################################################

func _ready():
	show()

# look for right click input to show the SAVE MENU
func _input(event):
	if event is InputEventMouseButton and event.pressed and event.button_index == BUTTON_RIGHT:
		if not ($MainMenu.visible or $SubMenus.visible):
			# Retrieve the save screenshot
			saved_image = get_tree().get_root().get_texture().get_data()
			saved_image.flip_y()
			
			pause_game()
			$SubMenus.open_save_menu()

################################################################################
##							IN-GAME BUTTONS
################################################################################

func _on_game_ended(_something):
	yield(get_tree().create_timer(0.2), "timeout")
	$MainMenu.open()
	$MenuMusic.play()
	$MenuAnimations.play("Fade")
	show()

func _on_Ingame_Save_Button_pressed():
	# Retrieve the save screenshot
	saved_image = get_tree().get_root().get_texture().get_data()
	saved_image.flip_y()
	
	pause_game()
	$SubMenus.open_save_menu()


func _on_Ingame_Load_Button_pressed():
	# Retrieve the save screenshot
	saved_image = get_tree().get_root().get_texture().get_data()
	saved_image.flip_y()
	
	pause_game()
	$SubMenus.open_load_menu()


func _on_Ingame_Settings_Button_pressed():
	# Retrieve the save screenshot
	saved_image = get_tree().get_root().get_texture().get_data()
	saved_image.flip_y()
	
	pause_game()
	$SubMenus.open_settings_menu()
