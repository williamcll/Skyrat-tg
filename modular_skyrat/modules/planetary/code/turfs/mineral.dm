/turf/closed/mineral/Initialize()
	. = ..()
	if(prob(2))
		AddComponent(/datum/component/turf_excavation)

/turf/open/floor/plating/dirt/jungle/wasteland/Initialize()
	. = ..()
	if(prob(4))
		AddComponent(/datum/component/turf_excavation)
