/* will array of random gear return ["head_gear","goggle","uniform","vest","backpack","weapon","ammo","scope"] */

params[ "_isList"];

_baseScope = [];
_wpScope = (configFile >> "cfgWeapons") call BIS_fnc_getCfgSubClasses;
{
	if (getnumber (configFile >> "cfgWeapons" >> _x >> "scope") == 2) then {
		_itemType = _x call bis_fnc_itemType;
		if (((_itemType select 0) == "Item") && ((_itemType select 1) == "AccessorySights")) then {
			_baseName = _x	call BIS_fnc_baseWeapon;
			if (!(_baseName in _baseScope)) then {
				_baseScope = _baseScope + [_baseName];
			};
		};
	};

} foreach _wpScope;

_baseWeapons = [];
_wpList = (configFile >> "cfgWeapons") call BIS_fnc_getCfgSubClasses;
{
	if (getnumber (configFile >> "cfgWeapons" >> _x >> "scope") == 2) then {
		_itemType = _x call bis_fnc_itemType;
		if (((_itemType select 0) == "Weapon") && (((_itemType select 1) != "Launcher") or ((_itemType select 1) != "MissileLauncher") or ((_itemType select 1) != "RocketLauncher"))) then {
			_baseName = _x	call BIS_fnc_baseWeapon;
			if (!(_baseName in _baseWeapons)) then {
				_baseWeapons = _baseWeapons + [_baseName];
			};
		};
	};

} foreach _wpList;

_baseGoggles = [];
_gogglesList = (configfile >> "CfgGlasses") call BIS_fnc_getCfgSubClasses;
{
	if (getnumber (configFile >> "CfgGlasses" >> _x >> "scope") == 2) then {
		_itemType = _x call bis_fnc_itemType;
		if (((_itemType select 0) == "Equipment") && ((_itemType select 1) == "Glasses")) then {
			_baseName = _x call BIS_fnc_baseWeapon;
			if (!(_baseName in _baseGoggles)) then {
				_baseGoggles = _baseGoggles + [_baseName];
			};
		};
	};

} foreach _gogglesList;

_baseVest = [];
_VestList = (configfile >> "cfgWeapons") call BIS_fnc_getCfgSubClasses;

{
	if (getnumber (configFile >> "cfgWeapons" >> _x >> "scope") == 2) then {
		_itemType = _x call bis_fnc_itemType;
		if (((_itemType select 0) == "Equipment") && ((_itemType select 1) == "Vest")) then {
			_baseName = _x call BIS_fnc_baseWeapon;
			if (!(_baseName in _baseVest)) then {
				_baseVest = _baseVest + [_baseName];
			};
		};
	};

} foreach _VestList;

_baseUniform = [];
_UniformList = (configfile >> "cfgWeapons") call BIS_fnc_getCfgSubClasses;

{
	if (getnumber (configFile >> "cfgWeapons" >> _x >> "scope") == 2) then {
		_itemType = _x call bis_fnc_itemType;
		if (((_itemType select 0) == "Equipment") && ((_itemType select 1) == "Uniform")) then {
			_baseName = _x call BIS_fnc_baseWeapon;
			if (!(_baseName in _baseUniform)) then {
				_baseUniform = _baseUniform + [_baseName];
			};
		};
	};

} foreach _UniformList;


_baseBackPack = [];
_BackPackList = (configfile >> "CfgVehicles") call BIS_fnc_getCfgSubClasses;

{
	if (getnumber (configFile >> "CfgVehicles" >> _x >> "scope") == 2) then {
		_itemType = _x call bis_fnc_itemType;
		if (((_itemType select 0) == "Equipment") && ((_itemType select 1) == "Backpack")) then {
			_baseName = _x call BIS_fnc_baseWeapon;
			if (!(_baseName in _baseBackPack)) then {
				_baseBackPack = _baseBackPack + [_baseName];
			};
		};
	};

} foreach _BackPackList;

_baseHelm = [];
_HelmList = (configfile >> "cfgWeapons") call BIS_fnc_getCfgSubClasses;

{
	if (getnumber (configFile >> "cfgWeapons" >> _x >> "scope") == 2) then {
		_itemType = _x call bis_fnc_itemType;
		if (((_itemType select 0) == "Equipment") && ((_itemType select 1) == "Headgear")) then {
			_baseName = _x call BIS_fnc_baseWeapon;
			if (!(_baseName in _baseHelm)) then {
				_baseHelm = _baseHelm + [_baseName];
			};
		};
	};

} foreach _HelmList;

private _random_gears = [];

if (_isList) then {
_all_ammo = [];
_random_gears = [_baseHelm,_baseGoggles,_baseUniform,_baseVest,_baseBackPack,_baseWeapons,_all_ammo,_baseScope];


} else {

_random_weapon = (_baseWeapons call BIS_fnc_selectRandom);
_weapon_ammo_list = getArray (configFile >> "CfgWeapons" >> _random_weapon >> "magazines");
_weapon_ammo = _weapon_ammo_list call BIS_fnc_selectRandom;

_random_gears = [(_baseHelm call BIS_fnc_selectRandom),(_baseGoggles call BIS_fnc_selectRandom),(_baseUniform call BIS_fnc_selectRandom),(_baseVest call BIS_fnc_selectRandom),(_baseBackPack call BIS_fnc_selectRandom),_random_weapon, _weapon_ammo ,(_baseScope call BIS_fnc_selectRandom)];


};

_random_gears;

