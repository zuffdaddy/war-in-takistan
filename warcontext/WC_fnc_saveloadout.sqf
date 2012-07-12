	// -----------------------------------------------
	// Author: team  code34 nicolas_boiteux@yahoo.fr
	// warcontext - save loadout
	// -----------------------------------------------


	if (isDedicated) exitWith {};

	private [
		"_magazines", 
		"_weapons", 
		"_hasruck", 
		"_hasruckace", 
		"_ruckmags", 
		"_ruckweapons", 
		"_rucktype", 
		"_enemy", 
		"_sacados_avant_mort", 
		"_backpack", 
		"_weapononback",
		"_playerInvoked"
	];
	
	if (count _this > 2) then {
		_playerInvoked = _this select 3;
		if !(isNil ("_playerInvoked")) then {
			if (_playerInvoked) then {
				wcSavedLoadoutManually = true;
			};
		};
	};

	wcmagazines = magazines player;
	wcweapons = weapons player;

	wchasruck = false;
	wchasruckace = false;

	wcruckmags = [];
	wcruckweapons = [];
	wcweapononback = [];
	wcbackpack = [];
	wcrucktype = [];

	if!(isnull (unitBackpack player)) then {
		wchasruck = true;
		wcbackpack = unitBackpack player;
		wcrucktype = typeof wcbackpack;
		wcruckmags = getMagazineCargo wcbackpack;
		wcruckweapons = getWeaponCargo wcbackpack;
	};

	
	if(wcwithACE == 1) then {
		wcweapononback = player getvariable "ACE_weapononback";
		if (player call ace_sys_ruck_fnc_hasRuck) then {
			wcrucktype = player call ACE_Sys_Ruck_fnc_FindRuck;
			wcruckmags = player getvariable "ACE_RuckMagContents";
			wcruckweapons = player getvariable "ACE_RuckWepContents";
			wchasruckace = true;
		};
	};
