/obj/item/anomalous_crystal
	name = "anomalous crystal"
	icon = 'modular_skyrat/modules/planetary/icons/items/crystal.dmi'
	icon_state = "crystal"
	w_class = WEIGHT_CLASS_SMALL
	var/anom_type
	var/chem_reactant
	var/research_reactant
	var/splinters_remaining = 10


/obj/item/anomalous_crystal/Initialize()
	. = ..()
	if(!anom_type)
		anom_type = rand(1,ANOM_CRYSTAL_EFFECTS_IN_TOTAL)
	color = "#[random_color()]"

/obj/item/anomalous_crystal/throw_impact(atom/hit_atom, datum/thrownthing/throwingdatum)
	. = ..()
	if(!.) //if it wasn't caught
		visible_message("<span class='warning'>[src] shatters!</span>",
		"<span class='hear'>You hear something shatter!</span>")
		var/turf/our_T = get_turf(hit_atom)
		var/obj/ash = new /obj/effect/decal/cleanable/ash(our_T)
		ash.color = color
		playsound(src, "shatter", 50, TRUE)
		anomaly_crystal_effect(our_T, anom_type, splinters_remaining*20)
		qdel(src)

/obj/item/anomalous_crystal/on_grind()
	. = ..()

/obj/item/anomalous_crystal_splinter
	name = "anomalous crystal splinter"
	icon = 'modular_skyrat/modules/planetary/icons/items/crystal.dmi'
	icon_state = "splinter"
	w_class = WEIGHT_CLASS_TINY
	var/anom_type
	var/chem_reactant
	var/research_reactant

/obj/item/anomalous_crystal_splinter/Initialize()
	. = ..()
	icon_state = "splinter[rand(1,4)]"

/obj/item/anomalous_crystal_splinter/on_grind()
	. = ..()

/proc/anomaly_crystal_effect(turf/T, anom_type, anom_pow)
	switch(anom_type)
		if(ANOM_CRYSTAL_FIRE)
			var/gas_power = anom_pow/10
			T.atmos_spawn_air("o2=[gas_power];plasma=[gas_power];TEMP=600")

/datum/reagent/crystal_powder
	data = list("type"=null,"color"=null"chem_react"=null,"res_react"=null)
	name = "Crystal Powder"
	taste_description = "powdered orangeade"
	taste_mult = 1.3

/datum/reagent/crystal_powder/on_new(list/data)
	if(istype(data) && data["color"])
		color = data["color"]
