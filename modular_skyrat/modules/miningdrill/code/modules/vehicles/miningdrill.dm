/obj/vehicle/sealed/miningdrill
	name = "Mobile Mining Rig"
	desc = "A huge machine capable of drilling out huge amounts of rock."
	icon = 'modular_skyrat/modules/miningdrill/icons/obj/vehicle/miningdrill96.dmi'
	icon_state = "miningdrill"
	max_integrity = 5000
	armor = list("melee" = 50, "bullet" = 25, "laser" = 20, "energy" = 0, "bomb" = 50, "bio" = 0, "rad" = 0, "fire" = 60, "acid" = 60)
	are_legs_exposed = FALSE
	key_type = /obj/item/key
	integrity_failure = 0.5
	max_occupants = 4
	move_force = MOVE_FORCE_VERY_STRONG
	move_resist = MOVE_FORCE_EXTREMELY_STRONG
	var/static/mutable_appearance/atvcover
	//Performance Vars
	var/hydraulic_pressure = 0
	var/engine_rpm = 1
	var/engine_load = FALSE
	var/electrics = FALSE
	var/fuel_1 = 0
	var/fuel_2 = 0
	var/engine_status = 0 //0 - off 1 - on 2 - broken 3 - overload
	var/obj/item/stock_parts/cell/bluespace/battery = new /obj/item/stock_parts/cell/bluespace
	var/enginetype = "D" //D - diesel, P - plasma, U - Uranium, B - Bluespace
	var/drill_status = FALSE
	var/lights = FALSE
	var/speed = 4

	//Sound vars
	var/engine_sound_length = 4
	var/last_enginesound_time
	var/engine_start_sound = 'modular_skyrat/modules/miningdrill/sound/engine/engine_start.ogg'
	var/engine_stop_sound = 'modular_skyrat/modules/miningdrill/sound/engine/engine_stop.ogg'
	var/engine_running_sound = list('modular_skyrat/modules/miningdrill/sound/engine/engine_rpm_00.ogg',
	'modular_skyrat/modules/miningdrill/sound/engine/engine_rpm_33.ogg',
	'modular_skyrat/modules/miningdrill/sound/engine/engine_rpm_66.ogg',
	'modular_skyrat/modules/miningdrill/sound/engine/engine_rpm_99.ogg')
	var/engine_running_sound_load = list('modular_skyrat/modules/miningdrill/sound/engine/engine_rpm_00_load.ogg',
	'modular_skyrat/modules/miningdrill/sound/engine/engine_rpm_33_load.ogg',
	'modular_skyrat/modules/miningdrill/sound/engine/engine_rpm_66_load.ogg',
	'modular_skyrat/modules/miningdrill/sound/engine/engine_rpm_99_load.ogg')

/obj/vehicle/sealed/miningdrill/Initialize()
	. = ..()
	var/matrix/T = new
	T.Translate(-32, -32)
	transform = T

	var/datum/component/riding/D = LoadComponent(/datum/component/riding)
	D.vehicle_move_delay = speed
	D.slowvalue = 0

	update_icons()

	START_PROCESSING(SSobj, src)

/obj/vehicle/sealed/miningdrill/Destroy()
	. = ..()
	STOP_PROCESSING(SSobj, src)

/obj/vehicle/sealed/miningdrill/generate_actions()
	. = ..()
	initialize_controller_action_type(/datum/action/vehicle/sealed/remove_key, VEHICLE_CONTROL_DRIVE)
	initialize_controller_action_type(/datum/action/vehicle/sealed/miningdrill/toggle_electrics, VEHICLE_CONTROL_DRIVE)
	initialize_controller_action_type(/datum/action/vehicle/sealed/miningdrill/toggle_engine, VEHICLE_CONTROL_DRIVE)

/obj/vehicle/sealed/miningdrill/proc/update_icons()
	cut_overlays()
	switch(engine_status)
		if(0)
			add_overlay("engine_[enginetype]_off")
		if(1)
			add_overlay("engine_[enginetype]_on")
		if(2)
			add_overlay("engine_broken")

	if(electrics)
		add_overlay("lights_on")

	if(lights)
		add_overlay("lights_on")

/obj/vehicle/sealed/mniningdrill/mob_try_exit(mob/M, mob/user, silent = FALSE) //TODO - locking doors
	mob_exit(M, silent)
	return TRUE

/obj/vehicle/sealed/attacked_by(obj/item/I, mob/living/user)
	if(!I.force)
		return
	if(occupants[user])
		to_chat(user, "<span class='notice'>Your attack bounces off \the [src]'s padded interior.</span>")
		return
	return ..()

/obj/vehicle/sealed/attack_hand(mob/living/user)
	. = ..()

/obj/vehicle/sealed/miningdrill/driver_move(mob/user, direction)
	if(engine_status != 1)
		return FALSE

	var/datum/component/riding/R = GetComponent(/datum/component/riding)
	R.handle_ride(user, direction)
	engine_load = TRUE
	return TRUE

/obj/vehicle/sealed/miningdrill/process()
	if(engine_status != 1)
		return FALSE

	if(world.time < last_enginesound_time + engine_sound_length)
		return FALSE

	last_enginesound_time = world.time


	if(engine_load)
		playsound(src, engine_running_sound_load[engine_rpm], 50, TRUE)
		engine_load = FALSE
	else
		playsound(src, engine_running_sound[engine_rpm], 50, TRUE)
	return TRUE

//ACTIONS
/datum/action/vehicle/sealed/miningdrill/toggle_electrics
	name = "Toggle Electrics"
	desc = "Turn off and on the ancillary power systems."
	background_icon_state = "bg_tech_blue"
	icon_icon = 'modular_skyrat/modules/miningdrill/icons/buttons/buttons.dmi'
	button_icon_state = "electrics_toggle"

/datum/action/vehicle/sealed/miningdrill/toggle_electrics/Trigger()
	var/obj/vehicle/sealed/miningdrill/M = vehicle_entered_target
	M.toggle_electrics()

/datum/action/vehicle/sealed/miningdrill/toggle_engine
	name = "Toggle Engine"
	desc = "Turn off and on the main engine system."
	background_icon_state = "bg_tech_blue"
	icon_icon = 'modular_skyrat/modules/miningdrill/icons/buttons/buttons.dmi'
	button_icon_state = "engine_toggle"

/datum/action/vehicle/sealed/miningdrill/toggle_engine/Trigger()
	var/obj/vehicle/sealed/miningdrill/M = vehicle_entered_target
	M.toggle_engine()


/obj/vehicle/sealed/miningdrill/proc/toggle_electrics()
	if(battery.charge <= 0)
		visible_message("Battery power too low!")
		electrics = FALSE
		return FALSE
	if(electrics)
		visible_message("The controls and guages all shut down as you turn off the power.")
		electrics = FALSE
		update_icons()
	else
		visible_message("The controls and guages all come to life as your turn on the power.")
		electrics = TRUE
		update_icons()

/obj/vehicle/sealed/miningdrill/proc/toggle_engine()
	if(!electrics)
		visible_message("Ancillary power offline!")
		return FALSE
	if(engine_status == 2)
		visible_message("The engine sputters and whines.")
		return FALSE
	if(engine_status == 0)
		visible_message("The engine roars to life as the guages read nominal.")
		engine_status = 1
		playsound(src, pick(engine_start_sound), rand(50,60), 0, 10, 0)
		update_icons()
	else
		visible_message("The engine starts to spin down, the guages reading offline")
		engine_status = 0
		playsound(src, engine_stop_sound, rand(50,60), 0, 10, 0)
		update_icons()

