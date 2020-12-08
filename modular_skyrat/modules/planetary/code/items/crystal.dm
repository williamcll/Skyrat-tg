/obj/item/anomalous_sliver
	name = "anomalous sliver"
	icon = 'modular_skyrat/modules/planetary/icons/items/crystal.dmi'
	icon_state = "sliver"
	w_class = WEIGHT_CLASS_TINY
	grind_results = list(/datum/reagent/crystal_powder=20)
	var/anom_type
	var/chem_reactant
	var/research_reactant
	var/power = 20

/obj/item/anomalous_sliver/throw_impact(atom/hit_atom, datum/thrownthing/throwingdatum)
	. = ..()
	if(!.) //if it wasn't caught
		visible_message("<span class='warning'>[src] flashes and shatters!</span>",
		"<span class='hear'>You hear something shatter!</span>")
		var/turf/our_T = get_turf(src)
		var/obj/ash = new /obj/effect/decal/cleanable/ash(our_T)
		ash.color = color
		playsound(src, "shatter", 50, TRUE)
		anomaly_crystal_effect(our_T, anom_type, power)
		do_sparks(1, TRUE, src)
		qdel(src)

/obj/item/anomalous_sliver/sliver/Initialize()
	. = ..()
	icon_state = "sliver[rand(1,4)]"

/obj/item/anomalous_sliver/on_grind()
	. = ..()
	grind_results = list()
	reagents = new()
	reagents.add_reagent(/datum/reagent/crystal_powder, power, list("type"=anom_type,"color"=color,"chem_react"=chem_reactant,"res_react"=research_reactant))

/obj/item/anomalous_sliver/crystal
	name = "anomalous crystal"
	icon = 'modular_skyrat/modules/planetary/icons/items/crystal.dmi'
	icon_state = "crystal"
	w_class = WEIGHT_CLASS_SMALL
	grind_results = list(/datum/reagent/crystal_powder=200)
	power = 100
	var/slivers_remaining = 5

/obj/item/anomalous_sliver/crystal/Initialize()
	. = ..()
	anom_type = rand(1,ANOM_CRYSTAL_EFFECTS_IN_TOTAL)
	chem_reactant = pick(1,2)
	color = "#[random_color()]"

/obj/item/anomalous_sliver/crystal/attackby(obj/item/I, mob/user, params)
	if(I.get_sharpness() && user.Adjacent(src))
		to_chat(user, "<span class='notice'>You carefully slice a piece off of [src]...</span>")
		if(do_mob(user, src, 4 SECONDS))
			if(prob(70))
				to_chat(user, "<span class='notice'>You succeed, slicing a sliver off of [src].</span>")
				splinter_off()
			else
				to_chat(user, "<span class='warning'>You mess up and the crystal flashes briefly!</span>")
				do_sparks(1, TRUE, src)
				slivers_remaining--
				power -= 20
				anomaly_crystal_effect(get_turf(src), anom_type, 20)
			return TRUE
		return FALSE
	else
		return ..()

/obj/item/anomalous_sliver/crystal/proc/splinter_off()
	var/obj/item/anomalous_sliver/sliver/ACS = new(get_turf(src))
	ACS.color = color
	ACS.anom_type = anom_type
	ACS.chem_reactant = chem_reactant
	ACS.research_reactant = research_reactant
	slivers_remaining--
	power -= 20
	if(slivers_remaining <= 0)
		visible_message("<span class='warning'>[src] breaks!</span>")
		qdel(src)
	return ACS
