/*
DEBUG BALL HANDLER
Every 1 sec:
- Displays appropriate coloured debug ball depending on unit's suppression state
- Hides balls for unsuppressed or injured units
- Removes balls from dead units (!)
- Places markers on map indicating unit status
*/

tpwcas_fnc_debug = 
	{
	private ["_ball", "_marker", "_level", "_x", "_ball_level","_color"];
	
	while { true } do
		{
			{
			if ( local _x ) then 
				{
				if( isNil { _x getVariable "tpwcas_debug_ball" } ) then
					{
					_ball = createVehicle ["Sign_sphere25cm_EP1", [(random 15),(random 15),1], [], 0, "NONE"];
					_ball setObjectTexture [0,"#(argb,8,8,3)color(0.99,0.99,0.99,0.7,ca)"];  // white
					if ( tpwcas_multi_player ) then 
						{
							_nul = ["suppressDebug", [_x, _ball, 0]] call CBA_fnc_globalEvent;
						};
					_color = "ColorWhite";					
					if( (side _x) getFriend WEST < 0.6 ) then 
						{ _color = "ColorRed"; 
						} 
					else 
						{
						_color = "ColorBlue"; 
						};
					
					_marker = createMarker[ format["tpwcas_markers_%1", _x], position _x];
					_marker setMarkerShape "ICON";
					_marker setMarkerType "mil_triangle";
					_marker setMarkerColor _color;
					
					_x setVariable ["tpwcas_ball_state", 0];
					_x setVariable ["tpwcas_debug_ball", _ball ];
					_x setVariable ["tpwcas_debug_marker", _marker ];
					}
				else
					{
					_ball = _x getVariable "tpwcas_debug_ball";
					_marker = _x getVariable "tpwcas_debug_marker";
					};

				_marker setMarkerPos (position _x);
					
				if( fleeing _x) then 
					{
					_marker setMarkerType "mil_dot";
					}
				else
					{
					_marker setMarkerType "mil_triangle";
					_marker setMarkerDir (getDir _x);
					};
				
				if( !( isNull _x ) && alive _x ) then // better to double check for unit being alive ...
					{
					_ball = _x getVariable "tpwcas_debug_ball";
					_level = _x  getVariable ["tpwcas_supstate", 0];
					_ball_level = _x getVariable ["tpwcas_ball_state", 0];
				
				if !( _level == _ball_level ) then 
					{
					switch ( true ) do
						{
						case ( fleeing _x ): 
							{  
							_ball setObjectTexture [0,"#(argb,8,8,3)color(0.0,0.0,0.0,0.9,ca)"];  // black
							if ( tpwcas_multi_player ) then 
								{
								["suppressDebug", [_x, _ball, 1]] call CBA_fnc_globalEvent;
								};
							detach _ball;
							_ball attachTo [_x,[0,0,2]]; 
							};
						
						case ( _level == 0 ): 
							{  
							detach _ball;
							_ball setPosATL [0,0,1];
							};
						
						case ( _level == 1 ): 
							{  
							_ball setObjectTexture [0,"#(argb,8,8,3)color(0.1,0.9,0.1,0.7,ca)"];  // green
							if ( tpwcas_multi_player ) then 
								{
								_msg = format["'suppressDebug' trigger sent for unit [%1] - value [%2] - ball [%3]", _x, 2, _ball];
								[ _msg, 9 ] call bdetect_fnc_debug;
								_nul = ["suppressDebug", [_x, _ball, 2]] call CBA_fnc_globalEvent;
								};
							detach _ball;
							_ball attachTo [_x,[0,0,2]]; 
							};
						
						case ( _level == 2): 
							{  
							_ball setObjectTexture [0,"#(argb,8,8,3)color(0.9,0.9,0.1,0.7,ca)"]; //yellow
							if ( tpwcas_multi_player ) then 
								{
								_nul = ["suppressDebug", [_x, _ball, 3]] call CBA_fnc_globalEvent;
								};
							detach _ball;
							_ball attachTo [_x,[0,0,2]]; 
							};
						
						case ( _level == 3 ): 
							{  
							_ball setObjectTexture [0,"#(argb,8,8,3)color(0.9,0.1,0.1,0.7,ca)"]; //red  
							if ( tpwcas_multi_player ) then 
								{
								_nul = ["suppressDebug", [_x, _ball, 4]] call CBA_fnc_globalEvent;
								};
							detach _ball;
							_ball attachTo [_x,[0,0,2]]; 
							};
						};
						
						_x setVariable ["tpwcas_ball_state", _level];
						
					};
				};
									
				if ( lifestate _x != "ALIVE" ) then
					{ 
					_ball = _x getVariable "tpwcas_debug_ball";				
					detach _ball;
					_ball setPosATL [(random 15),(random 15),0];
					};
				};	
			} foreach allunits;
			
			{
				if( (local _x) && !( isNil { _x getVariable "tpwcas_debug_ball" } ) ) then
				{
					deleteVehicle ( _x getVariable "tpwcas_debug_ball" );
					deleteMarker( _x getVariable "tpwcas_debug_marker" );
				};
				
			} foreach allDead;

			sleep 1;
		};
	};

			