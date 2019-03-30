params ["_unit","_qty"];



if ((handgunWeapon _unit) != "") then {
	_ammo_pistol  = getArray (configFile >> "CfgWeapons" >> (handgunWeapon _unit) >> "magazines");
	{
		_unit addMagazines [_x,_qty];
	} forEach _ammo_pistol;
};

if ((primaryWeapon _unit) != "") then {
	_ammo_weapon = getArray (configFile >> "CfgWeapons" >> (primaryWeapon _unit) >> "magazines");
	{
		_unit addMagazines [_x,_qty];
	} forEach _ammo_weapon;
};