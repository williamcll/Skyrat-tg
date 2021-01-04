/datum/overmap_shuttle_controller
	var/mob/living/mob_controller
	var/obj/docking_port/mobile/shuttle
	var/datum/overmap_object/shuttle/overmap_obj

	var/datum/action/innate/quit_control/quit_control_button
	var/datum/action/innate/stop_shuttle/stop_shuttle_button
	var/datum/action/innate/try_dock/try_dock_button
	var/busy = FALSE

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
	for(var/i in nearby_objects)
		var/datum/overmap_object/IO = i
		for(var/level in IO.related_levels)
			var/datum/space_level/iterated_space_level = level
			z_levels["[iterated_space_level.z_value]"] = TRUE

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

	var/choice = input(usr, "Where shall you dock?", "Shuttle Docking") as null|anything in docks
	if(!choice)
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
