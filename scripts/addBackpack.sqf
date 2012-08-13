_player = (_this select 1);
_type = (_this select 3) select 0;

if (wcwithACE == 1) then {
	removeBackpack _player;
	_ruckName = [_player] call ACE_fnc_FindRuck;
	if (_player hasWeapon _ruckName) then {
		_player removeWeapon _ruckName;
	};
	[_player, "BTH"] call ACE_fnc_RemoveGear;

	if (!(_type == "")) then 
	{
		_player addWeapon _type;
		hintSilent "You picked up the backpack. Any previous backpacks were discarded.";
	} else 
	{
		hintSilent "Backpack dropped.";
	};
} else {
	removeBackpack _player;
	sleep 0.5;
	if (!(_type == "")) then 
	{
		_player addBackpack _type;
		hintSilent "You picked up the backpack. Any previous backpacks were discarded.";
	} else 
	{
		hintSilent "Backpack dropped.";
	};	
};
