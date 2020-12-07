/obj/item/anomalous_crystal
	name = "anomalous crystal"
	icon = 'modular_skyrat/modules/planetary/icons/items/crystal.dmi'
	icon_state = "crystal"
	w_class = WEIGHT_CLASS_SMALL
	grind_results = list(/datum/reagent/crystal_powder=200)
	var/anom_type
	var/chem_reactant
	var/research_reactant
	var/slivers_remaining = 10

/obj/item/anomalous_crystal/proc/sliver_off()
	var/obj/item/anomalous_crystal_sliver/ACS = new(get_turf(src))
	ACS.color = color
	ACS.anom_type = anom_type
	ACS.chem_reactant = chem_reactant
	ACS.research_reactant = research_reactant
	slivers_remaining--
	if(slivers_remaining <= 0)
		visible_message("<span class='warning'>[src] breaks!</span>")
		qdel(src)
	return ACS

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
		anomaly_crystal_effect(our_T, anom_type, slivers_remaining*20)
		qdel(src)

/obj/item/anomalous_crystal/on_grind()
	. = ..()
	grind_results = list()
	reagents = new()
	reagents.add_reagent(/datum/reagent/crystal_powder, 20*slivers_remaining, list("type"=anom_type,"color"=color,"chem_react"=chem_reactant,"res_react"=research_reactant))

/obj/item/anomalous_crystal_sliver
	name = "anomalous crystal sliver"
	icon = 'modular_skyrat/modules/planetary/icons/items/crystal.dmi'
	icon_state = "sliver"
	w_class = WEIGHT_CLASS_TINY
	grind_results = list(/datum/reagent/crystal_powder=20)
	var/anom_type
	var/chem_reactant
	var/research_reactant

/obj/item/anomalous_crystal_sliver/Initialize()
	. = ..()
	icon_state = "sliver[rand(1,4)]"

/obj/item/anomalous_crystal_sliver/on_grind()
	. = ..()
	grind_results = list()
	reagents = new()
	reagents.add_reagent(/datum/reagent/crystal_powder, 20, list("type"=anom_type,"color"=color,"chem_react"=chem_reactant,"res_react"=research_reactant))

/proc/anomaly_crystal_effect(turf/T, anom_type, anom_pow)
	switch(anom_type)
		if(ANOM_CRYSTAL_FIRE)
			var/gas_power = anom_pow/10
			T.atmos_spawn_air("o2=[gas_power];plasma=[gas_power];TEMP=600")

/datum/reagent/crystal_powder
	data = list("type"=null,"color"=null,"chem_react"=null,"res_react"=null)
	name = "Crystal Powder"
	taste_description = "powdered orangeade"
	taste_mult = 1.3

/datum/reagent/crystal_powder/on_new(list/data)
	if(istype(data) && data["color"])
		color = data["color"]

/datum/reagent/analysis/proc/Get_Analysis()
	return ""

/datum/reagent/analysis/crystal_analysis_sample
	data = list("type"=null,"color"=null,"chem_react"=null,"res_react"=null)
	name = "Crystal Analysis Sample"
	color = "#8f7a96"

/datum/chemical_reaction/crystal_atomization
	results = list(/datum/reagent/analysis/crystal_analysis_sample = 20)
	required_reagents = list(/datum/reagent/crystal_powder = 20, /datum/reagent/uranium = 20)

/datum/chemical_reaction/crystal_atomization/on_reaction(datum/reagents/holder, created_volume)
	
