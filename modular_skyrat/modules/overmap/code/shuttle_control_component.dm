/datum/overmap_shuttle_controller
	var/mob/living/mob_controller
	var/obj/docking_port/mobile/shuttle
	var/datum/overmap_object/shuttle/overmap_obj

	var/datum/action/innate/quit_control/quit_control_button
	var/datum/action/innate/stop_shuttle/stop_shuttle_button
	var/datum/action/innate/try_dock/try_dock_button
	var/busy = FALSE

	var/datum/shuttle_freeform_docker/freeform_docker

/datum/overmap_shuttle_controller/New(obj/docking_port/mobile/passed_shuttle)
	shuttle = passed_shuttle
	quit_control_button = new
	quit_control_button.target = src
	stop_shuttle_button = new
	stop_shuttle_button.target = src
	try_dock_button = new
	try_dock_button.target = src

/datum/overmap_shuttle_controller/proc/SetController(mob/living/our_guy)
	if(mob_controller)
		RemoveCurrentControl()
	AddControl(our_guy)

/datum/overmap_shuttle_controller/proc/AddControl(mob/living/our_guy)
	mob_controller = our_guy
	RegisterSignal(mob_controller, COMSIG_CLICKON, .proc/ControllerClick)
	mob_controller.client.perspective = EYE_PERSPECTIVE
	mob_controller.client.eye = shuttle.my_overmap_object.my_visual
	mob_controller.update_parallax_contents()
	quit_control_button.Grant(mob_controller)
	try_dock_button.Grant(mob_controller)
	stop_shuttle_button.Grant(mob_controller)

/datum/overmap_shuttle_controller/proc/RemoveCurrentControl()
	UnregisterSignal(mob_controller, COMSIG_CLICKON)
	mob_controller.client.perspective = MOB_PERSPECTIVE
	mob_controller.client.eye = mob_controller
	mob_controller.update_parallax_contents()
	quit_control_button.Remove(mob_controller)
	try_dock_button.Remove(mob_controller)
	stop_shuttle_button.Remove(mob_controller)
	mob_controller = null

/datum/overmap_shuttle_controller/proc/ControllerClick(datum/source, atom/A, params)
	SIGNAL_HANDLER
	message_admins("WE CLICKED ON [A]")
	if(A.z != shuttle.my_overmap_object.current_system.z_level)
		message_admins("WE CLICKED ON A WRONG Z LEVEL")
		return
	shuttle.my_overmap_object.CommandMove(A.x,A.y)
	return COMSIG_CANCEL_CLICKON

/datum/action/innate/try_dock
	name = "Try Dock"
	icon_icon = 'icons/mob/actions/actions_silicon.dmi'
	button_icon_state = "slime_down"

/datum/action/innate/try_dock/Trigger()
	var/datum/overmap_shuttle_controller/OSC = target
	var/datum/overmap_object/OO = OSC.shuttle.my_overmap_object
	var/list/z_levels = list()
	var/list/nearby_objects = OO.current_system.GetObjectsInRadius(OO.x,OO.y,1)
	var/list/freeform_z_levels = list()
	for(var/i in nearby_objects)
		var/datum/overmap_object/IO = i
		for(var/level in IO.related_levels)
			var/datum/space_level/iterated_space_level = level
			z_levels["[iterated_space_level.z_value]"] = TRUE
			freeform_z_levels["[iterated_space_level.name] - Freeform"] = iterated_space_level.z_value

	var/list/docks = list()
	var/list/options = params2list(OSC.shuttle.possible_destinations)
	for(var/i in SSshuttle.stationary)
		var/obj/docking_port/stationary/iterated_dock = i
		if(z_levels["[iterated_dock.z]"] && (iterated_dock.id in options))
			docks[iterated_dock.name] = iterated_dock

	for(var/i in docks)
		var/obj/docking_port/stationary/iterated_dock = docks[i]
		message_admins("dock: [iterated_dock.id]")

	message_admins(nearby_objects.len)

	var/choice = input(usr, "Where shall you dock?", "Shuttle Docking") as null|anything in docks+freeform_z_levels
	if(!choice)
		return
	if(freeform_z_levels[choice])
		var/z_level = freeform_z_levels[choice]
		OSC.freeform_docker = new /datum/shuttle_freeform_docker(OSC, usr, z_level)		
		return
	var/obj/docking_port/stationary/chosen_dock = docks[choice]

	switch(SSshuttle.moveShuttle(OSC.shuttle.id, chosen_dock.id, 1))
		if(0)
			message_admins("we did it")
			OSC.busy = TRUE
			OSC.RemoveCurrentControl()
			QDEL_NULL(OSC.shuttle.my_overmap_object)
			return TRUE
		if(1)
			message_admins("we didnt do it")
		else
			message_admins("error")


/datum/action/innate/quit_control
	name = "Quit Control"
	icon_icon = 'icons/mob/actions/actions_silicon.dmi'
	button_icon_state = "slime_down"

/datum/action/innate/quit_control/Trigger()
	var/datum/overmap_shuttle_controller/OSC = target
	OSC.RemoveCurrentControl()

/datum/action/innate/stop_shuttle
	name = "Stop Shuttle"
	icon_icon = 'icons/mob/actions/actions_silicon.dmi'
	button_icon_state = "slime_down"

/datum/action/innate/stop_shuttle/Trigger()
	var/datum/overmap_shuttle_controller/OSC = target
	OSC.shuttle.my_overmap_object.StopMove()

/mob/camera/ai_eye/remote/shuttle_freeform
	visible_icon = FALSE
	use_static = USE_STATIC_NONE
	var/list/placement_images = list()
	var/list/placed_images = list()

/mob/camera/ai_eye/remote/shuttle_freeform/setLoc(T)
	..()
	var/datum/shuttle_freeform_docker/docker = origin
	if(docker)
		docker.checkLandingSpot()

/mob/camera/ai_eye/remote/shuttle_freeform/update_remote_sight(mob/living/user)
	user.sight = BLIND|SEE_TURFS
	user.lighting_alpha = LIGHTING_PLANE_ALPHA_INVISIBLE
	user.sync_lighting_plane_alpha()
	return TRUE

/datum/shuttle_freeform_docker
	var/mob/camera/ai_eye/remote/shuttle_freeform/eyeobj
	var/datum/overmap_shuttle_controller/my_controller
	var/datum/action/innate/camera_off/off_action = new
	var/datum/action/innate/camera_jump/jump_action = new
	var/datum/action/innate/shuttledocker_rotate/rotate_action = new
	var/datum/action/innate/shuttledocker_place/place_action = new
	var/view_range = 0
	var/x_offset = 0
	var/y_offset = 0
	var/list/whitelist_turfs = list(/turf/open/space, /turf/open/floor/plating, /turf/open/lava)
	var/see_hidden = FALSE
	var/designate_time = 0
	var/turf/designating_target_loc
	var/jammed = FALSE
	var/obj/docking_port/stationary/my_port //the custom docking port placed by this console
	var/obj/docking_port/mobile/shuttle_port //the mobile docking port of the connected shuttle
	var/shuttleId = ""
	var/shuttlePortId = ""
	var/shuttlePortName = "custom location"
	var/z_level

	var/mob/current_user

	var/direction = NORTH

	var/should_supress_view_changes = FALSE

	var/list/placement_images = list()
	var/list/placed_images = list()

/datum/shuttle_freeform_docker/New(datum/overmap_shuttle_controller/passed_controller, mob/user, z)
	my_controller = passed_controller
	z_level = z
	current_user = user
	whitelist_turfs = typecacheof(whitelist_turfs)
	StartCameraView()

/datum/shuttle_freeform_docker/proc/CreateEye()
	eyeobj = new()
	eyeobj.origin = src
	var/obj/docking_port/mobile/my_shuttle = my_controller.shuttle
	eyeobj.setDir(my_shuttle.dir)
	var/turf/origin = locate(my_shuttle.x + x_offset, my_shuttle.y + y_offset, my_shuttle.z)
	for(var/V in my_shuttle.shuttle_areas)
		var/area/A = V
		for(var/turf/T in A)
			if(T.z != origin.z)
				continue
			var/image/I = image('icons/effects/alphacolors.dmi', origin, "red")
			var/x_off = T.x - origin.x
			var/y_off = T.y - origin.y
			I.loc = locate(origin.x + x_off, origin.y + y_off, origin.z) //we have to set this after creating the image because it might be null, and images created in nullspace are immutable.
			I.layer = ABOVE_NORMAL_TURF_LAYER
			I.plane = 0
			I.mouse_opacity = MOUSE_OPACITY_TRANSPARENT
			placement_images[I] = list(x_off, y_off)

/datum/shuttle_freeform_docker/proc/checkLandingSpot()
	var/turf/eyeturf = get_turf(eyeobj)
	if(!eyeturf)
		return SHUTTLE_DOCKER_BLOCKED
	/*
	if(!eyeturf.z || SSmapping.level_has_any_trait(eyeturf.z, locked_traits))
		return SHUTTLE_DOCKER_BLOCKED
	*/

	. = SHUTTLE_DOCKER_LANDING_CLEAR
	var/list/bounds = my_controller.shuttle.return_coords(eyeobj.x - x_offset, eyeobj.y - y_offset, eyeobj.dir)
	var/list/overlappers = SSshuttle.get_dock_overlap(bounds[1], bounds[2], bounds[3], bounds[4], eyeobj.z)
	var/list/image_cache = placement_images
	for(var/i in 1 to image_cache.len)
		var/image/I = image_cache[i]
		var/list/coords = image_cache[I]
		var/turf/T = locate(eyeturf.x + coords[1], eyeturf.y + coords[2], eyeturf.z)
		I.loc = T
		switch(checkLandingTurf(T, overlappers))
			if(SHUTTLE_DOCKER_LANDING_CLEAR)
				I.icon_state = "green"
			if(SHUTTLE_DOCKER_BLOCKED_BY_HIDDEN_PORT)
				I.icon_state = "green"
				if(. == SHUTTLE_DOCKER_LANDING_CLEAR)
					. = SHUTTLE_DOCKER_BLOCKED_BY_HIDDEN_PORT
			else
				I.icon_state = "red"
				. = SHUTTLE_DOCKER_BLOCKED

/datum/shuttle_freeform_docker/proc/checkLandingTurf(turf/T, list/overlappers)
	// Too close to the map edge is never allowed
	if(!T || T.x <= 10 || T.y <= 10 || T.x >= world.maxx - 10 || T.y >= world.maxy - 10)
		return SHUTTLE_DOCKER_BLOCKED
	// If it's one of our shuttle areas assume it's ok to be there
	if(my_controller.shuttle.shuttle_areas[T.loc])
		return SHUTTLE_DOCKER_LANDING_CLEAR
	. = SHUTTLE_DOCKER_LANDING_CLEAR
	// See if the turf is hidden from us
	var/list/hidden_turf_info
	if(!see_hidden)
		hidden_turf_info = SSshuttle.hidden_shuttle_turfs[T]
		if(hidden_turf_info)
			. = SHUTTLE_DOCKER_BLOCKED_BY_HIDDEN_PORT

	if(length(whitelist_turfs))
		var/turf_type = hidden_turf_info ? hidden_turf_info[2] : T.type
		if(!is_type_in_typecache(turf_type, whitelist_turfs))
			return SHUTTLE_DOCKER_BLOCKED

	// Checking for overlapping dock boundaries
	for(var/i in 1 to overlappers.len)
		var/obj/docking_port/port = overlappers[i]
		if(port == my_port)
			continue
		var/port_hidden = !see_hidden && port.hidden
		var/list/overlap = overlappers[port]
		var/list/xs = overlap[1]
		var/list/ys = overlap[2]
		if(xs["[T.x]"] && ys["[T.y]"])
			if(port_hidden)
				. = SHUTTLE_DOCKER_BLOCKED_BY_HIDDEN_PORT
			else
				return SHUTTLE_DOCKER_BLOCKED

/datum/shuttle_freeform_docker/proc/GrantActions()
	if(off_action)
		off_action.target = current_user
		off_action.Grant(current_user)

	if(jump_action)
		jump_action.target = current_user
		jump_action.Grant(current_user)

	if(rotate_action)
		rotate_action.target = current_user
		rotate_action.Grant(current_user)

	if(place_action)
		place_action.target = current_user
		place_action.Grant(current_user)

/datum/shuttle_freeform_docker/proc/StartCameraView()
	if(!eyeobj)
		CreateEye()
	if(!eyeobj.eye_initialized)
		var/camera_location
		var/turf/myturf = locate(round(world.maxx/2), round(world.maxy/2), z_level)
		camera_location = myturf
		eyeobj.eye_initialized = TRUE
		give_eye_control(current_user)
		eyeobj.setLoc(camera_location)

/datum/shuttle_freeform_docker/proc/give_eye_control()
	//GrantActions(current_user)
	eyeobj.eye_user = current_user
	eyeobj.name = "Camera Eye ([current_user.name])"
	current_user.remote_control = eyeobj
	current_user.reset_perspective(eyeobj)
	eyeobj.setLoc(eyeobj.loc)
	if(should_supress_view_changes)
		current_user.client.view_size.supress()
	var/list/to_add = list()
	to_add += placement_images
	to_add += placed_images
	current_user.client.images += to_add
	//current_user.client.view_size.setTo(view_range)

/datum/shuttle_freeform_docker/proc/remove_eye_control()
	//REMOVE ACTIONS
	if(current_user.client)
		current_user.reset_perspective(null)
		if(eyeobj.visible_icon && current_user.client)
			current_user.client.images -= eyeobj.user_image
		current_user.client.view_size.unsupress()

	var/list/to_remove = list()
	to_remove += placement_images
	to_remove += placed_images
	current_user.client.images -= to_remove
	//current_user.client.view_size.resetToDefault()

	eyeobj.eye_user = null
	current_user.remote_control = null
	current_user = null
	current_user.unset_machine()
	//playsound(src, 'sound/machines/terminal_off.ogg', 25, FALSE)
