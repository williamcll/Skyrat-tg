#define SPECTRAL_SCAN_HYPERSPECTRAL 1
#define SPECTRAL_SCAN_SPECTROMETER 2

/obj/machinery/rnd/hyperspectral
	name = "hyperspectral imager"
	desc = "A specialised, complex analysis machine. Has a spectrometer and a hyperspectral imager installed."
	icon = 'modular_skyrat/modules/planetary/icons/machinery/hyperspectral.dmi'
	icon_state = "hyperspectral"
	light_power = 0.75
	light_color = LIGHT_COLOR_GREEN
	circuit = /obj/item/circuitboard/machine/hyperspectral
	console_link = FALSE
	var/scan_type = SPECTRAL_SCAN_HYPERSPECTRAL
	var/scan_progress = 0

/obj/machinery/rnd/hyperspectral/process()
	if (machine_stat & (NOPOWER | BROKEN))
		return
	if(!busy || !loaded_item)
		return

	scan_progress++
	if(scan_progress<10)
		return

	scan_progress = 0
	busy = FALSE
	set_light(0)
	STOP_PROCESSING(SSobj, src)
	update_icon()
	var/my_turf = get_turf(src)
	playsound(my_turf, 'sound/items/poster_being_created.ogg', 100, 1)
	var/obj/item/paper/P = new /obj/item/paper(my_turf)
	switch(scan_type)
		if(SPECTRAL_SCAN_HYPERSPECTRAL)
			P.name = "[loaded_item.name] hyperspectral scan"
			P.info = "<CENTER><B>[uppertext(loaded_item.name)] HYPERSPECTRAL SCAN</B></CENTER><BR>"
			var/special = FALSE
			if(istype(loaded_item, /obj/item/anomalous_sliver))
				special = TRUE
				var/obj/item/anomalous_sliver/AS = loaded_item
				if(AS.anom_type == ANOM_CRYSTAL_GRAVITATIONAL) //Gravitational messes with the machine readings, flavorful
					P.info += "ERROR!"
				else
					var/constructed_string = "Inconsistent and high energy signatures detected!<BR>"
					switch(AS.anom_type)
						if(ANOM_CRYSTAL_FIRE)
							constructed_string += "There seems to be an internal fire inside the crystal."
						if(ANOM_CRYSTAL_EMP)
							constructed_string += "The crystal is showing electromagnetic properties."
						if(ANOM_CRYSTAL_ELECTRIC)
							constructed_string += "Electrical currents seem to flow through the crystal."
						if(ANOM_CRYSTAL_RADIATION)
							constructed_string += "The crystal is emitting radioactive energies."
						if(ANOM_CRYSTAL_EXPLOSIVE)
							constructed_string += "The crystal is filled with unstable energy."
						if(ANOM_CRYSTAL_RESIN_FOAM)
							constructed_string += "The crystal seems capable of absorbing energy."
						if(ANOM_CRYSTAL_FROST_VAPOUR)
							constructed_string += "Internal temperature of the crystal is sub-zero."
						else
							constructed_string += "The crystal is filled with unknown energies."
					P.info += constructed_string
				if(!special)
					P.info += "Detected energy signatures 100% consistent with standard background readings."

		if(SPECTRAL_SCAN_SPECTROMETER)
			P.name = "[loaded_item.name] spectroscopic analysis"
			P.info = "<CENTER><B>[uppertext(loaded_item.name)] SPECTROSCOPIC ANALYSIS</B></CENTER><BR>"
			var/special = FALSE
			//If it's an reagent container containing reagents, we try and scan them instead
			if(istype(loaded_item, /obj/item/reagent_containers) && loaded_item.reagents && loaded_item.reagents.total_volume)
				var/list/cached_reagents = loaded_item.reagents.reagent_list
				for(var/reagent in cached_reagents)
					var/datum/reagent/R = reagent
					if(R.data["spectrometer"])
						//Sample dilluted with other stuff, obfuscate the result
						if(R.volume*1.5 < loaded_item.reagents.total_volume)
							P.info += "There are detected phonemenas in the chemical sample, however the impurity of the sample makes them hard to analyze."
						else
							P.info += "[R.name] in the chemical sample is displaying phenomenas:<BR>[R.data["spectrometer"]]"
						special= TRUE
						break
			if(!special)
				P.info += "Spectral components of scanned item show no phenomenons."
	P.update_icon()

/obj/machinery/rnd/hyperspectral/update_icon()
	overlays.Cut()
	if (machine_stat & (NOPOWER | BROKEN))
		return
	overlays += "hyperspectral_on"

	if (busy)
		if(SPECTRAL_SCAN_HYPERSPECTRAL)
			overlays += "hyperspectral_active2"
		else
			overlays += "hyperspectral_active"

/obj/machinery/rnd/hyperspectral/Insert_Item(obj/item/I, mob/user)
	if(user.a_intent != INTENT_HARM)
		if(!is_insertion_ready(user))
			return TRUE
		if(!user.transferItemToLoc(I, src))
			return TRUE
		loaded_item = I
		to_chat(user, "<span class='notice'>You load [I] into [src].</span>")
		return TRUE

/obj/machinery/rnd/hyperspectral/ui_interact(mob/user)
	var/list/dat = list("<center>")
	if(!busy)
		dat += "<b>Loaded Item:</b> [loaded_item ? "[loaded_item.name] <a href='?src=[REF(src)];pref=eject'>Eject</a>" : "nothing"]"
		dat += "<BR><a [loaded_item ? "href='?src=[REF(src)];pref=hyperspectral'" : "class='linkOff'"]>Hyperspectral image scan</a>"
		dat += "<BR><a [loaded_item ? "href='?src=[REF(src)];pref=spectrometer'" : "class='linkOff'"]>Spectroscopic analysis</a>"
		dat += "<BR><a href='?src=[REF(src)];pref=refresh'>Refresh</a>"
	else
		dat += "<b>Scan in progress...</b>"
		dat += "<BR><a href='?src=[REF(src)];pref=refresh'>Refresh</a>"

	var/datum/browser/popup = new(user, "hyperspectral","Hyperspectral Imager", 400, 400, src)
	popup.set_content(dat.Join("<br>"))
	popup.open()
	onclose(user, "hyperspectral")

/obj/machinery/rnd/hyperspectral/Topic(href, href_list)
	if(..())
		return
	if(href_list["pref"])
		switch(href_list["pref"])
			if("hyperspectral")
				DoScan(SPECTRAL_SCAN_HYPERSPECTRAL)

			if("spectrometer")
				DoScan(SPECTRAL_SCAN_SPECTROMETER)

			if("eject")
				if(!busy && loaded_item)
					loaded_item.forceMove(get_turf(src))
					loaded_item = null

		updateUsrDialog()

/obj/machinery/rnd/hyperspectral/proc/DoScan(type)
	if(busy || !loaded_item)
		return
	busy = TRUE
	scan_type = type
	set_light(2)
	START_PROCESSING(SSobj, src)
	update_icon()

/obj/item/circuitboard/machine/hyperspectral
	name = "Hyperspectral Imager (Machine Board)"
	icon_state = "science"
	build_path = /obj/machinery/rnd/hyperspectral
	req_components = list(
		/obj/item/stock_parts/scanning_module = 3)

#undef SPECTRAL_SCAN_HYPERSPECTRAL
#undef SPECTRAL_SCAN_SPECTROMETER
