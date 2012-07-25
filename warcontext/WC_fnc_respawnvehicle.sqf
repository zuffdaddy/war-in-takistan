	// -----------------------------------------------
	// Author: team  code34 nicolas_boiteux@yahoo.fr
	// warcontext - Description:
	// respawn vehicle at their original position
	// Context: server side
	// Xeno respawn reworks
	// -----------------------------------------------
	if (!isServer) exitWith{};

	private [
		"_vehicle", 
		"_delay", 
		"_startpos", 
		"_startdir", 
		"_type", 
		"_disabled", 
		"_vehiclename",
		"_westside",
		"_idleTime",
		"_name",
		"_objets_charges"
	];
	
	_vehicle = _this select 0;
	if(format["%1", _vehicle] == "any") exitWith{};
	_delay = _this select 1;

if (wcUseCarrier == 1) then {
	_startpos = getposasl _vehicle;	// at sea level
} else {
	_startpos = getposatl _vehicle;	// at terrain level
};
	_startdir = getdir _vehicle;
	_type = typeof _vehicle;
	_vehiclename = vehicleVarName _vehicle;
	_idleTime = 0;

	if(wcwithrandomfuel == 1) then {
		_vehicle setfuel random 0.5; 
		_vehicle setVehicleAmmo random 0.5;
	};

	WC_fnc_initializevehicle = {
		_vehicle = _this select 0;

	
		if(wcCustomVehicleHandleDamage == 1) then {
			_vehicle removeAllEventHandlers "HandleDamage";
			_vehicle addEventHandler ['HandleDamage', {
				if (_this select 2 > wcdammagethreshold) then {
					(_this select 0) removeAllEventHandlers "HandleDamage";
					if((_this select 2) + (getdammage (_this select 0)) > 0.9) then {
						(_this select 0) setdamage 1;
					} else {
						(_this select 0) setdamage ((getdammage(_this select 0)) + (_this select 2));
					};
				};
			}];
		};

		_vehicle addEventHandler ['Fired', '
			private ["_name"];
			if!(wcdetected) then {
				if((getmarkerpos "rescue") distance (position player) < 400) then {
					wcalerttoadd = random (10);
					["wcalerttoadd", "server"] call WC_fnc_publicvariable;
				};
			};
			wcammoused = wcammoused + 1;
		'];
	};

	[_vehicle] call WC_fnc_initializevehicle;

	// if simulation vehicles not respawn
	if(wckindofgame == 2) exitwith {};

	while {true} do {
		if (count (crew _vehicle) == 0) then {
			_idleTime = _idleTime + 1;
			_disabled = (if (damage _vehicle >= 1.0) then {true} else {false});
			if ((locked _vehicle) and !(_disabled) and (alive _vehicle)) then {
				_idleTime = 0;
			};
			if (_disabled || !(alive _vehicle) || ((_idleTime > 1800) and (getpos _vehicle distance _startpos > 10))) then {
				//sleep wctimetogarbagedeadbody;
				sleep 30; // respawn timer
				_vehicle setpos [0,0,0];
				_vehicle setdamage 1;
				_objets_charges = _vehicle getVariable "R3F_LOG_objets_charges";
				clearVehicleInit _vehicle;
				deletevehicle _vehicle;
				sleep 0.5;
				_vehicle = _type createvehicle _startpos;
				if (wcUseCarrier == 1) then {
					_vehicle setposasl _startpos;	// at sea level
				} else {
					_vehicle setposatl _startpos;	// at terrain level
				};
				_vehicle setdir _startdir;
				_vehicle setvehiclevarname _vehiclename;
				_vehicle setvehicleinit format["this setvehiclevarname '%1';", _vehiclename];
				processinitcommands;
				_vehicle setvariable ["R3F_LOG_objets_charges", _objets_charges, true];
				_idleTime = 0;
				_name= getText (configFile >> "CfgVehicles" >> _type >> "DisplayName");
				diag_log format["WARCONTEXT: RESPAWN VEHICLE %1", _name];
				[_vehicle] call WC_fnc_initializevehicle;
			};
		}else{
			_idleTime = 0;
		};
		sleep 1;
	};