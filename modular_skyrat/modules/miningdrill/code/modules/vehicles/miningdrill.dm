#define CHANNEL_MININGDRILL_ENGINE 1000

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
	var/power_usage = 0
	var/fuel_1 = 0
	var/fuel_2 = 0
	var/engine_status = 0 //0 - off 1 - on 2 - broken 3 - overload
	var/obj/item/stock_parts/cell/bluespace/battery = new /obj/item/stock_parts/cell/bluespace
	var/enginetype = "D" //D - diesel, P - plasma, U - Uranium, B - Bluespace
	var/drill_status = FALSE
	var/lights = FALSE
	var/speed = 4

	//Sound vars
	var/engine_sound_length = 4 SECONDS
	var/last_enginesound_time
	var/last_enginesound_time_load
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
	initialize_controller_action_type(/datum/action/vehicle/sealed/miningdrill/toggle_engine_rpm, VEHICLE_CONTROL_DRIVE)
	initialize_controller_action_type(/datum/action/vehicle/sealed/miningdrill/toggle_lights, VEHICLE_CONTROL_DRIVE)

/obj/vehicle/sealed/miningdrill/proc/update_icons()
	cut_overlays()
	switch(engine_status)
		if(0)
			add_overlay("engine_[enginetype]_off")
		if(1)
			add_overlay("engine_[enginetype]_on")
		if(2)
			add_overlay("engine_broken")

	if(drill_status)
		add_overlay("drill_on")
	else
		add_overlay("drill_off")

	if(electrics)
		add_overlay("electrics_on")

	if(lights)
		add_overlay("lights_on")

/obj/vehicle/sealed/miningdrill/mob_try_exit(mob/M, mob/user, silent = FALSE) //TODO - locking doors
	mob_exit(M, silent)
	return TRUE

/obj/vehicle/sealed/attacked_by(obj/item/I, mob/living/user)
	user.revive()
	if(!I.force)
		return
	if(occupants[user])
		to_chat(user, "<span class='notice'>Your attack bounces off \the [src]'s padded interior.</span>")
		return
	return ..()

/obj/vehicle/sealed/miningdrill/attack_hand(mob/living/user)
	. = ..()

/obj/vehicle/sealed/miningdrill/after_move()
	engine_load = FALSE
	..()

/obj/vehicle/sealed/miningdrill/driver_move(mob/user, direction)
	if(engine_status != 1)
		engine_load = FALSE
		return FALSE

	var/datum/component/riding/R = GetComponent(/datum/component/riding)
	R.handle_ride(user, direction)

	if(world.time < last_enginesound_time_load + engine_sound_length)
		return FALSE

	last_enginesound_time_load = world.time

	playsound(src, engine_running_sound_load[engine_rpm], 70, FALSE, 20, SOUND_FALLOFF_EXPONENT, CHANNEL_MININGDRILL_ENGINE)

	return TRUE

/obj/vehicle/sealed/miningdrill/process()

	use_power(power_usage)

	if(engine_status != 1)
		return FALSE

	if(engine_load)
		engine_load = FALSE
		return FALSE

	if(world.time < last_enginesound_time + engine_sound_length)
		return FALSE

	last_enginesound_time = world.time

	playsound(src, engine_running_sound[engine_rpm], 70, 0, 10, SOUND_FALLOFF_EXPONENT, CHANNEL_MININGDRILL_ENGINE)

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

/datum/action/vehicle/sealed/miningdrill/toggle_engine_rpm
	name = "Toggle Engine RPM"
	desc = "Select the engine RPM."
	background_icon_state = "bg_tech_blue"
	icon_icon = 'modular_skyrat/modules/miningdrill/icons/buttons/buttons.dmi'
	button_icon_state = "engine_rpm"

/datum/action/vehicle/sealed/miningdrill/toggle_engine_rpm/Trigger()
	var/obj/vehicle/sealed/miningdrill/M = vehicle_entered_target
	M.toggle_rpm()

/datum/action/vehicle/sealed/miningdrill/toggle_lights
	name = "Toggle Lights"
	desc = "Turn off and on the lights."
	background_icon_state = "bg_tech_blue"
	icon_icon = 'modular_skyrat/modules/miningdrill/icons/buttons/buttons.dmi'
	button_icon_state = "lights_toggle"

/datum/action/vehicle/sealed/miningdrill/toggle_lights/Trigger()
	var/obj/vehicle/sealed/miningdrill/M = vehicle_entered_target
	M.toggle_lights()

/obj/vehicle/sealed/miningdrill/proc/toggle_electrics(off, on)
	if(off)
		electrics = FALSE
		return FALSE
	if(battery.charge <= power_usage)
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
	if(!electrics && !engine_status)
		visible_message("Ancillary power offline!")
		return FALSE
	if(engine_status == 2)
		visible_message("The engine sputters and whines.")
		return FALSE
	if(engine_status == 0)
		start_engine()
	else
		stop_engine()

/obj/vehicle/sealed/miningdrill/proc/start_engine()
	visible_message("The engine roars to life as the guages read nominal.")
	power_usage += (100 * engine_rpm)
	playsound()
	playsound(src, engine_start_sound, rand(50,60), 0, 10, SOUND_FALLOFF_EXPONENT, CHANNEL_MININGDRILL_ENGINE)
	var/direction = prob(50) ? -1 : 1
	animate(src, pixel_x = pixel_x + 2 * direction, time = 1, easing = QUAD_EASING | EASE_OUT)
	animate(pixel_x = pixel_x - (2 * 2 * direction), time = 1)
	animate(pixel_x = pixel_x + 2 * direction, time = 1, easing = QUAD_EASING | EASE_IN)
	addtimer(CALLBACK(src, .proc/engine_on), 3 SECONDS)

/obj/vehicle/sealed/miningdrill/proc/stop_engine()
	visible_message("The engine starts to spin down, the guages reading offline.")
	power_usage -= (100 * engine_rpm)
	engine_status = 0
	playsound(src, engine_stop_sound, rand(50,60), 0, 10, SOUND_FALLOFF_EXPONENT, CHANNEL_MININGDRILL_ENGINE)
	update_icons()

/obj/vehicle/sealed/miningdrill/proc/engine_on()
	engine_status = 1
	update_icons()

/obj/vehicle/sealed/miningdrill/proc/toggle_rpm()
	engine_rpm++
	if(engine_rpm > 4)
		engine_rpm = 1

	switch(engine_rpm)
		if(1)
			speed = 4
		if(2)
			speed = 3.5
		if(3)
			speed = 3
		if(4)
			speed = 2

	var/datum/component/riding/D = LoadComponent(/datum/component/riding)
	D.vehicle_move_delay = speed
	D.slowvalue = 0

	visible_message("The RMP guage shows setting [engine_rpm].")

/obj/vehicle/sealed/miningdrill/proc/toggle_lights()
	if(!electrics)
		visible_message("The lights dimly flicker.")
		return FALSE
	visible_message("The lights activate.")
	lights = TRUE
	update_icons()
	return TRUE

/obj/vehicle/sealed/miningdrill/proc/use_power(amount)
	if(battery.use(amount))
		return 1
	toggle_electrics(TRUE)
	return 0

/obj/vehicle/sealed/miningdrill/proc/get_charge()
	if(get_charge() && battery)
		return max(0, battery.charge)

/obj/vehicle/sealed/miningdrill/proc/stop_sound_channel(chan)
	SEND_SOUND(src, sound(null, repeat = 0, wait = 0, channel = chan))




#undef CHANNEL_MININGDRILL_ENGINE
