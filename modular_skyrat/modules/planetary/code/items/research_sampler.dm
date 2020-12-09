/obj/item/storage/box/evidence/sample
	name = "sample bag box"
	desc = "A box claiming to contain sample bags."

/obj/item/core_sampler
	name = "core sampler"
	desc = "Used to extract samples out of alien items of interest."
	icon = 'modular_skyrat/modules/planetary/icons/items/sampler.dmi'
	icon_state = "sampler"
	w_class = WEIGHT_CLASS_SMALL
	var/obj/item/extracted_sample


/obj/item/core_sampler/Destroy()
	if (extracted_sample)
		qdel(extracted_sample)
		extracted_sample = null
	..()

/obj/item/core_sampler/examine(mob/user)
	. = ..()
	to_chat(user, "<span class='info'>This one [extracted_sample ? "has a sample stored inside. Just use the sampler to extract it." : "is empty. Use on an object of interest to extract a sample."].</span>")

/obj/item/core_sampler/attack_self(mob/user)
	if(extracted_sample)
		playsound(src, 'sound/items/deconstruct.ogg', 50, TRUE)
		to_chat(user, "<span class='notice'>You eject the sample.</span>")
		var/success = 0
		if(istype(src.loc, /mob))
			var/mob/M = src.loc
			success = M.put_in_inactive_hand(extracted_sample)
		if(!success)
			extracted_sample.forceMove(get_turf(src))
		extracted_sample = null
		icon_state = "sampler"
	else
		to_chat(user, "<span class='warning'>The research sampler is empty.</span>")

/obj/item/core_sampler/proc/on_sample_extracted(mob/user, obj/item/sample)
	sample.forceMove(src)
	extracted_sample = sample
	icon_state = "sampler-full"
	to_chat(user, "<span class='notice'>You extract a [sample].</span>")
	playsound(src, "sound/items/crank.ogg", 30, TRUE)
