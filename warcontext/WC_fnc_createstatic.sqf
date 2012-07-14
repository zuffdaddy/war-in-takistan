	// -----------------------------------------------
	// Author:  code34 nicolas_boiteux@yahoo.fr
	// warcontext -  Createstatic in houses
	// -----------------------------------------------
	
	private [
		"_arrayofpos", 
		"_buildings", 
		"_location", 
		"_position", 
		"_index", 
		"_vehicle", 
		"_staticclass", 
		"_static", 
		"_ammobox", 
		"_count"
	];

	_position = _this select 0;

RUFS_ProbeSurface = {
	private ["_pos", "_bball", "_probe", "_zi", "_zf", "_zdiff", "_vel", "_hasSurface"];
	_pos = _this select 0;
	_zi = _pos select 2;
	_bball = "Rabbit"; // our furry little friend
	_probe = _bball createVehicle _pos;
	_probe setpos _pos;
	_vel = -60;
	_probe setVelocity [0, 0 , -60]; // force the object to crash downward
	while {_vel > 0.1 && _vel < -0.1} do {
		_vel = velocity _probe select 2;
	};
	_zf = getposATL _probe select 2;
	_zdiff = _zi - _zf;
	// find difference in height
	if (_zdiff > 0.5 || _zdiff < -1) then {
		_hasSurface = false;
		//hint "surface unsuitable";
	} else {
		_hasSurface = true;
		//hint "surface suitable";
	};
	deletevehicle _probe;
	// output result
	_hasSurface
};

RUFS_BuildingTop = {
private ["_building", "_dimensions", "_center", "_positionSUB", "_x", "_y", "_z"];
_building = _this select 0;
_dimensions = boundingBox _building;
_center = boundingCenter _building; // center of the building

//if ((typeName _building) != "OBJECT") then {
//hint "NO BUILDING EXISTS";
//};

// x and y extremes of bounding box
_xmin = ((_dimensions select 0) select 0);
_ymin = ((_dimensions select 0) select 1);
_xmax = ((_dimensions select 1) select 0);
_ymax = ((_dimensions select 1) select 1);

_midx = (_xmax / 2) - 1;
_midy = (_ymax / 2) - 1;


_xC = _center select 0;
_yC = _center select 1;
_z = ((_dimensions select 1) select 2); // height

//player sidechat format ["center: %1 isflat: %2", _center, _isFlat];
// adjust this position for any elevation changes (building on top of hill for example)
_positionSUB = [(getposATL _building select 0) + (sin (random 360)) * (random _midx), (getposATL _building select 1) + (cos (random 360)) * (random _midy), (getposATL _building select 2) + _z];


//_mark = createMarker ["la", _positionSUB];
//_mark setMarkerType "Dot";

// Output
_positionSUB
};

	_buildings = nearestObjects [_position, ["House"], 350];
	_arrayofpos = [];

//	{
//		if(getdammage _x < 0.4) then {
//			_index = 0;
//			while { format ["%1", _x buildingPos _index] != "[0,0,0]" } do {
//				_position = _x buildingPos _index;
//				if (_position select 2 > 1) then {
//					_arrayofpos = _arrayofpos + [_position];
//				};
//				_index = _index + 1;
//				sleep 0.05;
//			};
//		};
//	}foreach _buildings;

	{
		_suitablePosition = false;
		if(getdammage _x < 0.4) then {
			_index = 0;
			while { (!_suitablePosition) } do {
				_position = [_x] call RUFS_BuildingTop;
				_suitablePosition = [_position] call RUFS_ProbeSurface;
				_index = _index + 1;
				sleep 0.05;
			};
			//if (_index <= 5) then {
				_arrayofpos = _arrayofpos + [_position];
				//diag_log format ["%1", _position];
			//};
		};
	}foreach _buildings;

	_count = 0;
	_staticclass = ["AGS_TK_INS_EP1", "KORD_TK_EP1", "DSHkM_Mini_TriPod_TK_INS_EP1", "DSHKM_TK_GUE_EP1", "KORD_high_TK_EP1", "Metis_TK_EP1", "SPG9_TK_INS_EP1"];
	{
		if(random 1 > 0.95) then {
			_static = _staticclass call BIS_fnc_selectRandom;
			_vehicle = _static createVehicle _x;
			_vehicle setposatl _x;
			wcgarbage = [_vehicle] spawn WC_fnc_vehiclehandler;

			if((position _vehicle) select 2 < 0.4) then {
				deletevehicle _vehicle;
			} else {
				wcvehicles = wcvehicles + [_vehicle];
				_count = _count + 1;
			};
		};
	}foreach _arrayofpos;

	diag_log format["WARCONTEXT: GENERATE %1 STATICS", _count];

	