extends Node
## نقطه‌ی شروع: تم سراسری، سوئیچ بین منو و بازی، دکمه‌ی بازگشت اندروید.

const UI = preload("res://scripts/ui.gd")
const MenuScript = preload("res://scripts/main_menu.gd")
const GameScript = preload("res://scripts/game.gd")

var menu = null
var game = null


func _ready():
	process_mode = Node.PROCESS_MODE_ALWAYS
	get_window().theme = UI.make_theme()
	get_tree().set_auto_accept_quit(false)
	_show_menu()


func _show_menu():
	if game != null:
		game.queue_free()
		game = null
	get_tree().paused = false
	menu = MenuScript.new()
	add_child(menu)
	menu.start_game.connect(_start_game)


func _start_game():
	if menu != null:
		menu.queue_free()
		menu = null
	game = GameScript.new()
	game.exit_requested.connect(_show_menu)
	add_child(game)


func _notification(what):
	if what == NOTIFICATION_WM_GO_BACK_REQUEST:
		if game != null:
			game.on_back()
		else:
			get_tree().quit()
	elif what == NOTIFICATION_WM_CLOSE_REQUEST:
		Global.save_game()
		get_tree().quit()
