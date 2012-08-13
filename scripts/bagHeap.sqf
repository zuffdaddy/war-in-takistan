_heap = _this;

//waitUntil { !isNil(wcwithACE) };

//waituntil {!isnil "bis_fnc_init"};

//_acePresent = call compile format["wcwithACE"];
//
//waitUntil { str(_acePresent) != "any" };
//
//diag_log format["_acePresent = %1", _acePresent];
//diag_log format["wcwithACE = %1", wcwithACE];

if (wcwithACE == 1) then {
	_heap addAction ["Take ACE ACU Pack", "scripts\addBackpack.sqf", ["ACE_Backpack_ACU"]];
	_heap addAction ["Take ACE Large Coyote Pack", "scripts\addBackpack.sqf", ["ACE_Backpack_US"]];
	_heap addAction ["Take ACE Patrol Pack", "scripts\addBackpack.sqf", ["ACE_Coyote_Pack_Wood"]];
	_heap addAction ["Take ACE ALICE Pack", "scripts\addBackpack.sqf", ["ACE_ALICE_Backpack"]];
	//_heap addAction ["Take Taki Assault Pack", "scripts\addBackpack.sqf", ["TK_Assault_Pack_EP1"]];
	//_heap addAction ["Take Czech Rucksack", "scripts\addBackpack.sqf", ["CZ_Backpack_EP1"]];
};

if (wcwithACE == 0) then {
	//if ("bink_usmc_ilbe" isKindOf "Bag_Base_EP1") then {
	//	_heap addAction ["Take ILBE Pack", "scripts\addBackpack.sqf", ["bink_usmc_ilbe"]];
	//};
	_heap addAction ["Take ACU Pack", "scripts\addBackpack.sqf", ["US_Assault_Pack_EP1"]];
	_heap addAction ["Take Large Coyote Pack", "scripts\addBackpack.sqf", ["US_Backpack_EP1"]];
	_heap addAction ["Take Patrol Pack", "scripts\addBackpack.sqf", ["US_Patrol_Pack_EP1"]];
	_heap addAction ["Take ALICE Pack", "scripts\addBackpack.sqf", ["TK_ALICE_Pack_EP1"]];
	_heap addAction ["Take Taki Assault Pack", "scripts\addBackpack.sqf", ["TK_Assault_Pack_EP1"]];
	_heap addAction ["Take Czech Rucksack", "scripts\addBackpack.sqf", ["CZ_Backpack_EP1"]];
};

_heap addAction ["Remove Backpack", "scripts\addBackpack.sqf", [""]];
