/* [player , ["B_CargoNet_01_ammo_F"],["B_Heli_Transport_03_unarmed_F"]] call FUNmission_fnc_supplyDrop; */


null = _this spawn {

	params[ "_caller","_list_box","_list_heli"];

	// set pos spawn and group heli
	_spawn_pos = [[[position _caller, 1000]],[[position _caller, 900]]] call BIS_fnc_randomPos;
	_heli_group = createGroup [civilian, true];

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

	// spawn drop box on other schedule
	[_caller,_list_box,_drop_pos] spawn {

	params[ "_caller","_list_box" , "_drop_pos"];

	_para = createVehicle ["B_Parachute_02_F", _drop_pos, [], 0, ""];
	_para addEventHandler ["Hit", {
		params ["_unit", "_source", "_damage", "_instigator"];
		deleteVehicle _unit;
	}];

	_reward_box = createVehicle [(_list_box call BIS_fnc_selectRandom), _drop_pos, [], 0];
 	_reward_box attachTo [_para,[0,0,0]];
 
	// clear the cargo
	clearItemCargoGlobal _reward_box;
	clearWeaponCargoGlobal _reward_box;
	clearMagazineCargoGlobal _reward_box;
	clearBackpackCargoGlobal _reward_box;

	_random_gears = [false] call FUNMission_fnc_randomGears;
	_reward_box addItemCargo [(_random_gears select 0), 1];
	_reward_box addItemCargo [(_random_gears select 1), 1];
	_reward_box addItemCargo [(_random_gears select 2), 1];
	_reward_box addItemCargo [(_random_gears select 3), 1];
	_reward_box addBackpackCargo [(_random_gears select 4), 1];
	_reward_box addItemCargoGlobal[(_random_gears select 5),1];
	_reward_box addItemCargoGlobal[(_random_gears select 6),15];
	_reward_box addItemCargoGlobal[(_random_gears select 7),1];
	
	WaitUntil {((((position _reward_box) select 2) < 0.6) || (isNil "_para"))};
	detach _reward_box;
	_reward_box SetVelocity [0,0,-5];           
	sleep 0.3;
	_reward_box setPos [(position _reward_box) select 0, (position _reward_box) select 1, 1];
	_reward_box SetVelocity [0,0,0];

	"SmokeShellRed" createVehicle position _reward_box;
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