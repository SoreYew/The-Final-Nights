//Stores several modifiers in a way that isn't cleared by changing species
/datum/physiology
	/// Multiplier to brute damage received.
	/// IE: A brute mod of 0.9 = 10% less brute damage.
	/// Only applies to damage dealt via [apply_damage][/mob/living/proc/apply_damage] unless factored in manually.
	var/brute_mod = 1
	/// Multiplier to burn damage received
	var/burn_mod = 1
	/// Multiplier to toxin damage received
	var/tox_mod = 1
	/// Multiplier to oxygen damage received
	var/oxy_mod = 1
	/// Multiplier to clone damage received
	var/clone_mod = 1
	/// Multiplier to stamina damage received
	var/stamina_mod = 1
	/// Multiplier to brain damage received
	var/brain_mod = 1

	/// Multiplier to damage taken from high / low pressure exposure, stacking with the brute modifier
	var/pressure_mod = 1
	/// Multiplier to damage taken from high temperature exposure, stacking with the burn modifier
	var/heat_mod = 1
	/// Multiplier to damage taken from low temperature exposure, stacking with the toxin modifier
	var/cold_mod = 1

	/// Flat damage reduction from taking damage
	/// Unlike the other modifiers, this is not a multiplier.
	/// IE: DR of 10 = 10% less damage.
	var/damage_resistance = 0

	var/siemens_coeff = 1 	// resistance to shocks

	var/stun_mod = 1      	// % stun modifier
	var/bleed_mod = 1     	// % bleeding modifier
	var/datum/armor/armor 	// internal armor datum

	var/hunger_mod = 1		//% of hunger rate taken per tick.

/datum/physiology/New()
	armor = new
