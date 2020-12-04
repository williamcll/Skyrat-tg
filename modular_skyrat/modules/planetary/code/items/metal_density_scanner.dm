/obj/item/metal_density_scanner
	name = "metal density scanner"
	desc = "A handheld device used for detecting and measuring density of nearby metals."
	icon = 'modular_skyrat/modules/planetary/icons/items/metal_scanner.dmi'
	icon_state = "mds_off"
	inhand_icon_state = "multitool"
	lefthand_file = 'icons/mob/inhands/equipment/tools_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/equipment/tools_righthand.dmi'
	w_class = WEIGHT_CLASS_SMALL
	slot_flags = ITEM_SLOT_BELT
	var/turned_on = FALSE
	var/last_scan = METAL_DENSITY_NONE

/obj/item/metal_density_scanner/update_icon_state()
	if(!turned_on)
		icon_state = "mds_off"
	else
		icon_state = "mds_on[last_scan]"

/obj/item/metal_density_scanner/Destroy()
	turn_off()
	return ..()

/obj/item/metal_density_scanner/proc/turn_on()
	turned_on = TRUE
	do_scan()
	update_icon()
	START_PROCESSING(SSobj, src)

/obj/item/metal_density_scanner/proc/turn_off()
	turned_on = FALSE
	update_icon()
	STOP_PROCESSING(SSobj, src)

/obj/item/metal_density_scanner/proc/do_scan()
	var/turf/my_turf = get_turf(src)
	var/datum/ore_node/ON = GetOreNodeInScanRange(my_turf)
	if(ON)
		last_scan = ON.GetScannerDensity(my_turf)
	else
		last_scan = METAL_DENSITY_NONE
	update_icon()

/obj/item/metal_density_scanner/process()
	do_scan()

/obj/item/metal_density_scanner/examine(mob/user)
	. = ..()
	if(!turned_on)
		return
	switch(last_scan)
		if(METAL_DENSITY_NONE)
			. += "<span class='notice'>Not recieving any feedback.</span>"
		if(METAL_DENSITY_LOW)
			. += "<span class='notice'>Metal density levels are low.</span>"
		if(METAL_DENSITY_MEDIUM)
			. += "<span class='notice'>Metal density levels are medium.</span>"
		if(METAL_DENSITY_HIGH)
			. += "<span class='boldnotice'>Metal density levels are high.</span>"

/obj/item/metal_density_scanner/attack_self(mob/user)
	if(turned_on)
		turn_off()
	else
		turn_on()
	playsound(user, turned_on ? 'sound/weapons/magin.ogg' : 'sound/weapons/magout.ogg', 20, TRUE)
	update_icon()
	to_chat(user, "<span class='notice'>[icon2html(src, user)] You switch [turned_on ? "on" : "off"] [src].</span>")
