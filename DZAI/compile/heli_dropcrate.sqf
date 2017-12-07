if (!isNil "DZAI_crate_items") then {
	[getpos _this] spawn { //Spawn loot crate
		private ["_pos","_box","_chute","_objectID","_num","_item","_tool","_smoketype","_smoke"];
		_pos = _this select 0;
		_box = "DZ_MedBox" createVehicle _pos;
		_objectID = str(round(random 999999));
		_box setVariable ["ObjectID", _objectID, true];
		_box setVariable ["ObjectUID", _objectID, true];
		_box setVariable ["permaLoot",true];
		dayz_serverObjectMonitor set [count dayz_serverObjectMonitor, _box];
		clearweaponcargoglobal _box;
		clearmagazinecargoglobal _box;

		_chute = createVehicle ["ParachuteMediumEast", _pos, [], 0, "FLY"];
		_box attachTo [_chute, [0,0,-0.5]];

		if (sunOrMoon != 1) then {
			_smoketype = "RoadFlare";
		} else {
			_smoketype = ["SmokeShellGreen","SmokeShellRed","SmokeShellYellow","SmokeShellPurple","SmokeShellBlue","SmokeShellOrange"] call BIS_fnc_selectRandom;
		};
		_smoke = _smoketype createVehicle (getPos _box);
		_smoke attachTo [_box, [0,0,0]];
		if (sunOrMoon != 1) then {
			PVDZ_obj_RoadFlare = [_smoke,0];
			publicVariable "PVDZ_obj_RoadFlare";
		};


		_num = floor(random 10);
		for "_i" from 0 to _num do {
			_item = DZAI_crate_items call BIS_fnc_selectRandom;
			_box addMagazineCargoGlobal [_item,1];
		};
		_num = floor(random 4);
		for "_i" from 0 to _num do {
			_tool = DZAI_crate_tools call BIS_fnc_selectRandom;
			_box addWeaponCargoGlobal [_tool,1];
		};

		if (DZAI_debugLevel > 0) then {diag_log format ["DZAI Debug: AI helicopter %1 spawned a crate", _this];};

		_box spawn {//wait for box lands, and detach avobe ground
			private ["_box"];
			_box = _this;
			sleep 5;
			while {(getPos _box) select 2 > 1} do {
				sleep 5;
			};
			detach _box;
			_box setpos [(getpos _box) select 0, (getpos _box) select 1, 0];
		};

		sleep 1200;
		deleteVehicle _chute;
		deleteVehicle _box;
	};
};