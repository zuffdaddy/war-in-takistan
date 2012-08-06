	// -----------------------------------------------
	// Author: Xeno rework by  code34 nicolas_boiteux@yahoo.fr
	// warcontext - Repair vehicle
	// -----------------------------------------------
	if!(isserver) exitwith {};

	private [
		"_config", 
		"_config2", 
		"_count",
		"_countother", 
		"_i",
		"_magazines",
		"_object",
		"_type", 
		"_removed",
		"_text"
		];

	_list	 	= _this select 0;

	{
		if((_x iskindof "Landvehicle") or (_x iskindof "Air")) then {
			//if((getposatl _x) select 2 < 2.5) then {
				_object = _x;
			//};
		};
	}foreach _list;

	sleep 1;

	//diag_log "servicing type: " + str(typeof _object);
	//if (_object isKindOf "MV22") then {
	//	_handle = [_object] execVM "f2f_modules\f2f_alss\f2f_exe\f2f_exe_vecInit_clrWeps.sqf";
	//	waitUntil {scriptDone _handle};
	//	_text = "";
	//	_item = "120Rnd_CMFlare_Chaff_Magazine";
	//	_text = _text + format["this addMagazine '%1';", _item];
	//	_item = "CMFlareLauncher";
	//	_text = _text + format["this addWeapon '%1';", _item];
	//	diag_log _text;
	//	_object setVehicleInit _text;
	//	processInitCommands;
	//};

	if (!alive _object) exitWith {};
	_object setVehicleInit "this setVariable [""selections"", []];this setVariable [""gethit"", []];";
	processInitCommands;
	
	_type = typeof _object;
	_object setVehicleInit "this vehicleChat ""Servicing... Please stand by..."";";
	processInitCommands;
	//sleep ceil(random(5));

	_type = typeOf _object;
	_magazines = getArray(configFile >> "CfgVehicles" >> _type >> "magazines");

	if (!alive _object) exitWith {};
	_object setVehicleInit "this vehicleChat ""Reloading weapons ..."";";
	processInitCommands;
	//sleep ceil(random(5));

	if (count _magazines > 0) then {
		_text = "";
		_removed = [];
		{
			if (!(_x in _removed)) then {
				_text = _text + format["this removeMagazines '%1';", _x];
				_removed = _removed + [_x];
			};
		} forEach _magazines;
		{
			_text = _text + format["this addMagazine '%1';", _x];
		} forEach _magazines;
		_text = _text + "this setVehicleAmmo 1;";
		_object setVehicleInit _text;
		processInitCommands;
	};

	_count = count (configFile >> "CfgVehicles" >> _type >> "Turrets");
	if (_count > 0) then {
		_text = "";
		for "_i" from 0 to (_count - 1) do {
			_config = (configFile >> "CfgVehicles" >> _type >> "Turrets") select _i;
			_magazines = getArray(_config >> "magazines");
			_removed = [];
			{
				if (!(_x in _removed)) then {
					_text = _text + (format["this removeMagazinesTurret ['%1',[%2]];", _x, _i]);
					_removed = _removed + [_x];
				};
			} forEach _magazines;
			{
				_text = _text + (format["this addMagazineTurret ['%1',[%2]];", _x, _i]);
			} forEach _magazines;

		};
		_object setVehicleInit _text;
		processInitCommands;
	};


	if (!alive _object) exitWith {};
	//sleep ceil(random(5));
	if (!alive _object) exitWith {};
	_object setVehicleInit "this vehicleChat ""Repairing...""; this setDamage 0;";
	processInitCommands;
	//sleep ceil(random(5));
	_object setVehicleInit "this vehicleChat ""Refueling..."";";
	processInitCommands;
	//sleep ceil(random(5));
	_object setVehicleInit "this vehicleChat ""Vehicle is ready"";this setfuel 1;";
	processInitCommands;
	