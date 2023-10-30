extends Node

var run = null
var continue_game = false
var last_time_saved = false

func _notification(what):
	if what == MainLoop.NOTIFICATION_WM_QUIT_REQUEST:
		save_profile()


func save_and_quit():
	save_game()
	get_tree().quit()


func save_game():
	save_profile()
	save_run()


func load_game():
	load_profile()


func load_profile():
	var profile_file = File.new()

	if not profile_file.file_exists("user://profile.save"):
		push_warning("Profile file not found. Starting a new profile file.")
		save_profile()
		
	var err = profile_file.open("user://profile.save", File.READ)
	if err != OK:
		push_error("Error trying to open profile whilst loading:" + str(err))
		
	while profile_file.get_position() < profile_file.get_len():
		# Get the saved dictionary from the next line in the save file
		var data = parse_json(profile_file.get_line())
		Profile.set_save_data(data)
		break
		
	profile_file.close()


func save_profile():
	var profile_data = Profile.get_save_data()

	#Now save directly on official profile.save
	var profile_file = File.new()
	var err = profile_file.open("user://profile.save", File.WRITE)
	if err != OK:
		push_error("Error trying to open profile whilst saving:" + str(err))
	profile_file.store_line(to_json(profile_data))
	profile_file.close()


func current_run_exists():
	return not not run


func set_current_run(run_ref):
	run = run_ref


func run_file_exists():
	var run_file = File.new()
	return run_file.file_exists("user://run.save")


func delete_run_file():
	var run_file = File.new()
	if run_file.file_exists("user://run.save"):
		var dir = Directory.new()
		dir.remove("user://run.save")
	else:
		#Run file not found. Aborting deletion.
		return


func save_run():
	assert(run, "Run reference invalid.")
	var run_file = File.new()
	var err = run_file.open("user://run.save", File.WRITE)
	if err != OK:
		push_error("Error trying to open run file whilst saving:" + str(err))
	var run_data = run.get_save_data()
	last_time_saved = run_data.time
	run_file.store_line(to_json(run_data))
	run_file.close()


func load_run():
	var run_file = File.new()
	if not run_file.file_exists("user://run.save"):
		push_error("Run file not found. Aborting load.")
		return
	var err = run_file.open("user://run.save", File.READ)
	if err != OK:
		push_error("Error trying to run file whilst loading:" + str(err))
	assert(run, "Run reference invalid.")
	while run_file.get_position() < run_file.get_len():
		var data = parse_json(run_file.get_line())
		run.set_save_data(data)
		last_time_saved = data.time
		
	run_file.close()
