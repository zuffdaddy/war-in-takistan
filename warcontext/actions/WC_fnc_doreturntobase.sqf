	// -----------------------------------------------
	// Author:  code34 nicolas_boiteux@yahoo.fr
	// -----------------------------------------------

	if (wcUseCarrier == 1) then {
		_temp_lhd_pos = getMarkerPos "respawn_west";
		player setPosASL [_temp_lhd_pos select 0, _temp_lhd_pos select 1, LHD_deck_height + 0.5];
		//player setDir _lhd_direction + _objDir;
	} else {
		player setpos getmarkerpos "respawn_west";
	};
