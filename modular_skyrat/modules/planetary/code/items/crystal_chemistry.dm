/datum/reagent/crystal_powder
	data = list("type"=null,"color"=null,"chem_react"=null,"res_react"=null)
	name = "Crystal Powder"
	taste_description = "powdered orangeade"
	taste_mult = 1.3

/datum/reagent/crystal_powder/on_merge(list/_data)
	data = _data.Copy()

/datum/reagent/crystal_powder/on_new(list/data)
	if(istype(data) && data["color"])
		color = data["color"]

/datum/reagent/analysis/proc/Get_Analysis()
	return ""

/datum/reagent/analysis/crystal_analysis_sample
	data = list("type"=null,"color"=null,"chem_react"=null,"res_react"=null)
	name = "Crystal Analysis Sample"
	color = "#8f7a96"

//The reactions are done in such an odd way to make sure that data is properly retained
/datum/chemical_reaction/crystal_atomization
	results = list(/datum/reagent/crystal_powder = 19.5)
	required_reagents = list(/datum/reagent/crystal_powder = 19.5, /datum/reagent/uranium = 20)

/datum/chemical_reaction/crystal_atomization/on_reaction(datum/reagents/holder, created_volume)
	var/data
	var/datum/reagent/powd = holder.has_reagent(/datum/reagent/crystal_powder)
	if(powd)
		data = powd.data.Copy()
		data["good_sample"] = TRUE
	holder.remove_reagent(/datum/reagent/crystal_powder, 20)
	holder.add_reagent(/datum/reagent/analysis/crystal_analysis_sample, 20 , data)
	if(data)
		anomaly_crystal_effect(get_turf(holder.my_atom), data["type"], created_volume)
	
/datum/chemical_reaction/crystal_basic_corrosion
	results = list(/datum/reagent/crystal_powder = 19.5)
	required_reagents = list(/datum/reagent/crystal_powder = 19.5, /datum/reagent/ammonia = 20)

/datum/chemical_reaction/crystal_basic_corrosion/on_reaction(datum/reagents/holder, created_volume)
	var/data
	var/datum/reagent/powd = holder.has_reagent(/datum/reagent/crystal_powder)
	if(powd)
		data = powd.data.Copy()
		if(data["chem_react"] == ANOM_CRYSTAL_CHEM_REACT_AMMONIA)
			data["good_sample"] = TRUE
	holder.remove_reagent(/datum/reagent/crystal_powder, 20)
	holder.add_reagent(/datum/reagent/analysis/crystal_analysis_sample, 20 , data)

/datum/chemical_reaction/crystal_acid_corrosion
	results = list(/datum/reagent/crystal_powder = 19.5)
	required_reagents = list(/datum/reagent/crystal_powder = 19.5, /datum/reagent/toxin/acid = 20)

/datum/chemical_reaction/crystal_acid_corrosion/on_reaction(datum/reagents/holder, created_volume)
	var/data
	var/datum/reagent/powd = holder.has_reagent(/datum/reagent/crystal_powder)
	if(powd)
		data = powd.data.Copy()
		if(data["chem_react"] == ANOM_CRYSTAL_CHEM_REACT_ACID)
			data["good_sample"] = TRUE
	holder.remove_reagent(/datum/reagent/crystal_powder, 20)
	holder.add_reagent(/datum/reagent/analysis/crystal_analysis_sample, 20 , data)
