_heap = _this;

if ("rb_backpack_5" isKindOf "Bag_Base_EP1") then {
	_heap addAction ["Take Camelbak Hawg", "scripts\addBackpack.sqf", ["rb_backpack_5"]];
};
_heap addAction ["Take ACU Pack", "scripts\addBackpack.sqf", ["US_Assault_Pack_EP1"]];
_heap addAction ["Take Large Coyote Pack", "scripts\addBackpack.sqf", ["US_Backpack_EP1"]];
_heap addAction ["Take Patrol Pack", "scripts\addBackpack.sqf", ["US_Patrol_Pack_EP1"]];
_heap addAction ["Take ALICE Pack", "scripts\addBackpack.sqf", ["TK_ALICE_Pack_EP1"]];
_heap addAction ["Take Taki Assault Pack", "scripts\addBackpack.sqf", ["TK_Assault_Pack_EP1"]];
_heap addAction ["Take Czech Rucksack", "scripts\addBackpack.sqf", ["CZ_Backpack_EP1"]];
_heap addAction ["Remove Backpack", "scripts\addBackpack.sqf", [""]];