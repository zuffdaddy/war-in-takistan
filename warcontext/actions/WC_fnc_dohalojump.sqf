	// -----------------------------------------------
	// Author:  code34 nicolas_boiteux@yahoo.fr
	// warcontext - call halo jump 
	// -----------------------------------------------

	["HALO Jump", "Click a position on map to jump", "You should choose the best safe position on map. Close map to abort the jump.", -1] spawn WC_fnc_playerhint;

	haloExecuted = false;
//	onMapSingleClick {
//		player setpos _pos;
//		[player, 1000] spawn bis_fnc_halo;
//		onMapSingleClick {};
//		haloExecuted = true;
//		true;
//	};
	haloExecuted = false;
	onMapSingleClick {
		player setpos _pos;
		[player, 1000] spawn bis_fnc_halo;
		onMapSingleClick {};
		haloExecuted = true;
		true;
	};
	//abortJump = false;
	[] spawn {
		openMap [true, false];
		abortJump = false;
		while {!haloExecuted} do {// and !(abortJump)
			if !(visibleMap) exitWith {
				onMapSingleClick {};
				abortJump = true;
			};
			sleep 0.1;
		};
		//onMapSingleClick{};
		if (!abortJump) then {
			wcAdvHintsHideNow = true;
			//["", "", "", -1] spawn WC_fnc_playerhint;
			//hintsilent "";
			openMap [false, false];
			_color = "FFFFFF";
			_colorGreen = "00FF00";
			_colorOrange = "FFBB00";
			_colorRed = "FF0000";
			while { alive player && vehicle player == player && isnil {player getvariable "bis_fnc_halo_terminate"} } do
			{
				_altitude = round (getPosATL player select 2);
				if (_altitude > 300) then { _color = _colorGreen; };
				if (_altitude <= 300) then { _color = _colorOrange; };
				if (_altitude <= 150) then { _color = _colorRed; };
				hintsilent parseText format["<t size='2.2'>Altitude: <t color='#%2'>%1</t></t>", _altitude, _color];
				sleep 0.05;
			};
			while { alive player && vehicle player != player && isnil {player getvariable "bis_fnc_halo_terminate"} } do
			{
				_altitude = round (getPosATL player select 2);
				if (_altitude > 300) then { _color = _colorGreen; };
				if (_altitude <= 300) then { _color = _colorOrange; };
				if (_altitude <= 150) then { _color = _colorRed; };
				hintsilent parseText format["<t size='2.2'>Altitude: <t color='#%2'>%1</t></t>", _altitude, _color];
				sleep 0.05;
			};
			hintsilent "";
		} else {
			// halo jump aborted
			[
				"HALO Jump Aborted",
				"You have aborted the HALO jump",
				"",
				10
			] spawn WC_fnc_playerhint;
		};
	};
