#define FOSSIL_TYPE_FLORA 1
#define FOSSIL_TYPE_FAUNA 2

//ORE STUFF
GLOBAL_LIST_EMPTY(ore_nodes_by_z_level)

GLOBAL_LIST_EMPTY(planet_dict_by_z_level)

//Defines for metal density scanner
#define METAL_DENSITY_NONE 0
#define METAL_DENSITY_LOW 1
#define METAL_DENSITY_MEDIUM 2
#define METAL_DENSITY_HIGH 3

//Anomalous crystal effects
#define ANOM_CRYSTAL_FIRE 1
#define ANOM_CRYSTAL_EMP 2
#define ANOM_CRYSTAL_GRAVITATIONAL 3
#define ANOM_CRYSTAL_EXPLOSIVE 4
#define ANOM_CRYSTAL_RESIN_FOAM 5
#define ANOM_CRYSTAL_NITROUS_OXIDE 6
#define ANOM_CRYSTAL_RADIATION 7
#define ANOM_CRYSTAL_MEDICAL_FOAM 8
#define ANOM_CRYSTAL_TOXIN_FOAM 9
#define ANOM_CRYSTAL_ELECTRIC 10
#define ANOM_CRYSTAL_FROST_VAPOUR 11
//MAKE SURE TO UPDATE THIS!!
#define ANOM_CRYSTAL_EFFECTS_IN_TOTAL 11

#define ANOM_CRYSTAL_CHEM_REACT_ACID 1
#define ANOM_CRYSTAL_CHEM_REACT_AMMONIA 2

//SPECTROMETER DESCRIPTION DEFINES
#define SPECTROMETER_CRYSTAL_POWDER "The powder seems to be emitting exotic energy, and kept sparkling during the scan.<BR>Unknown reactions were happening when the powder was subjected to UV light.<BR>Deteriorating the powder could prove to get better results."

//SEED STRUCTURE TRAITS
#define SEED_FLORA_AGITATIVE (1<<0) //Does all sorts of fun stuff, based off the seed's plant, DANGEROUS
#define SEED_FLORA_LOW_HANGING (1<<1) //Will make the produce drop on the floor when the structure is walked by, makes squishy and slippery effects fun
#define SEED_FLORA_CALTROPS (1<<2) //Acts as a caltrop, much like lavaland cactus
