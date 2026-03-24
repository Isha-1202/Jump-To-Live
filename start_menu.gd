extends CenterContainer

@onready var start_game_button = %StartGame

func _ready() -> void:
	start_game_button.grab_focus() 
	#这可以使用户用上下键切换开始菜单的选项
	#可以再项目设置中改变ui_up和ui_down的输入映射，使w和s键也可以控制上下
func _on_start_game_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/Game.tscn")


func _on_quit_pressed() -> void:
	get_tree().quit()
