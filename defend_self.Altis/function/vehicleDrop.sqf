/* [ player ,["B_APC_Wheeled_01_cannon_F"],["B_T_VTOL_01_vehicle_F"],true]  call FUNmission_fnc_vehicleDrop; */

null = _this spawn {
	params["_caller","_side","_vehicle_list","_list_heli","_enable_crew"];

	// set pos spawn and group heli
	_spawn_pos = [[[position _caller, 1000]],[[position _caller, 900]]] call BIS_fnc_randomPos;
	_heli_group = createGroup [_side, true];

	// create heli
	_heli = createVehicle [(_list_heli call BIS_fnc_selectRandom), _spawn_pos, [], 0, "FLY"];
	createVehicleCrew _heli;
	(crew _heli) join _heli_group;

	{
		_x allowFleeing 0;
		_x disableAI "COVER";
		_x disableAI "TARGET";
		_x disableAI "AUTOTARGET";
		_x disableAI "AUTOCOMBAT";
		_x disableAI "SUPPRESSION";
		_x setCaptive 1;

	} forEach (units _heli_group);

	// set heli waypoint
	_wp_heli_1 = _heli_group addWaypoint [position _caller, 1];
	_wp_heli_1 setWaypointType "MOVE";

	waitUntil { (currentWaypoint (_wp_heli_1 select 0)) > (_wp_heli_1 select 1) };

	// update drop position
	_drop_pos = position _heli;
	_drop_pos set [2,((position _heli) select 2) - 10];

	[_caller,_side,_vehicle_list,_drop_pos,_enable_crew] spawn {

		params[ "_caller","_side","_vehicle_list" , "_drop_pos","_enable_crew"];
		_para = createVehicle ["B_Parachute_02_F", _drop_pos, [], 0, ""];
		_vehicle_spawn = createVehicle [(_vehicle_list call BIS_fnc_selectRandom), _drop_pos, [], 0];
 		_vehicle_spawn attachTo [_para,[0,0,0]];

		if (_enable_crew) then {
			createVehicleCrew _vehicle_spawn;
			_crew_group = createGroup [_side, true];
			(crew _vehicle_spawn) join _crew_group;
			_vehicle_spawn addRating -5000;

			{
				_x allowFleeing 0;
				_x setSkill 0.1;
				_x addRating -5000;

			} forEach (units _crew_group);

			_wp_veh_1 = _crew_group addWaypoint [position _caller, 1];
			_wp_veh_1 setWaypointType "MOVE";
			(driver _vehicle_spawn) doMove (position _caller);
		};

		WaitUntil {((((position _vehicle_spawn) select 2) < 0.6) || (isNil "_para"))};
		detach _vehicle_spawn;
		_vehicle_spawn SetVelocity [0,0,-5];           
		sleep 0.3;
		_vehicle_spawn setPos [(position _vehicle_spawn) select 0, (position _vehicle_spawn) select 1, 1];
		_vehicle_spawn SetVelocity [0,0,0];

		if (!_enable_crew) then {
			"SmokeShellGreen" createVehicle position _vehicle_spawn;
		};
		
	};

	// set heli waypoint
	_wp_heli_2 = _heli_group addWaypoint [_spawn_pos, 2];
	_wp_heli_2 setWaypointType "MOVE";
	_heli_group setSpeedMode "full";
	(driver _heli) doMove _spawn_pos;

	waitUntil { (currentWaypoint (_wp_heli_2 select 0)) > (_wp_heli_2 select 1) };

	// delete heli on reach waypoint
	{
		_heli deleteVehicleCrew _x;
	} forEach crew _heli;

	deleteVehicle _heli;
	
};





