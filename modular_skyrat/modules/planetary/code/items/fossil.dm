/obj/item/fossil
	name = "fossil"
	icon = 'modular_skyrat/modules/planetary/icons/items/fossils.dmi'
	icon_state = "rock_fauna_2"
	w_class = WEIGHT_CLASS_SMALL
	var/fossil_type = FOSSIL_TYPE_FLORA
	var/amber = FALSE
	var/datum/fossil/fossil_ref
	var/list/hints

/obj/item/fossil/Initialize()
	. = ..()
	//Determine what we are
	var/turf/T = get_turf(src)
	var/datum/planet_dictionary/PD = GLOB.planet_dict_by_z_level["[T.z]"]
	
	if(!PD)
		qdel(src)
		return
	if(PD.amber_fossils)
		amber = TRUE
	fossil_ref = PD.random_fossil_ref()
	if(!fossil_ref)
		qdel(src)
		return
	//Inherit stuff
	hints = fossil_ref.get_random_hints()
	//Set proper icon n stuff
	icon_state = "[amber?"amber":"rock"]_[fossil_ref.fossil_type==FOSSIL_TYPE_FLORA?"flora":"fauna"]_[rand(1,7)]"
	desc = "You see a fossil of some sort of a [fossil_ref.fossil_type==FOSSIL_TYPE_FLORA?"plant":"creature"], it is encased in [amber?"amber":"rock"]"
	name = "[amber?"amber":"rock"] fossil"

/obj/item/fossil/examine(mob/user)
	. = ..()
	//You can see hints, provided you got research vision
	if(user.research_scanner)
		for(var/hint in hints)
			to_chat(user, "<span class='notice'>[hint]</span>")
