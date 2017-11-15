//--- Classic camera script, enhanced by Karel Moricky, 2010/03/19
// ripped + modified by nomisum for gruppe adler 2017

private ["_pX", "_pY", "_pZ"];

params ["_pos", "_vectorDir", "_vectorUp"];

_pX = _pos select 0;
_pY = _pos select 1;
_pZ = _pos select 2;

if (!isNil "BIS_DEBUG_CAM") exitwith {};

//--- Is FLIR available
if (isnil "BIS_DEBUG_CAM_ISFLIR") then {
	BIS_DEBUG_CAM_ISFLIR = isclass (configfile >> "cfgpatches" >> "A3_Data_F");
};

BIS_DEBUG_CAM_MAP = false;
BIS_DEBUG_CAM_VISION = 0;
BIS_DEBUG_CAM_FOCUS = 0;
BIS_DEBUG_CAM_COLOR = ppEffectCreate ["colorCorrections", 1600];
if (isnil "BIS_DEBUG_CAM_PPEFFECTS") then {
	BIS_DEBUG_CAM_PPEFFECTS = [
		[1, 1, -0.01, [1.0, 0.6, 0.0, 0.005], [1.0, 0.96, 0.66, 0.55], [0.95, 0.95, 0.95, 0.0]],
		[1, 1.02, -0.005, [0.0, 0.0, 0.0, 0.0], [1, 0.8, 0.6, 0.65],  [0.199, 0.587, 0.114, 0.0]],
		[1, 1.15, 0, [0.0, 0.0, 0.0, 0.0], [0.5, 0.8, 1, 0.5],  [0.199, 0.587, 0.114, 0.0]],
		[1, 1.06, -0.01, [0.0, 0.0, 0.0, 0.0], [0.44, 0.26, 0.078, 0],  [0.199, 0.587, 0.114, 0.0]]
	];
};

//--- Undefined
if (typename _this != typename objnull) then {_this = cameraon};

private ["_local"];
_local = "camera" camCreate [_pX, _pY, _pZ];
BIS_DEBUG_CAM = _local;
_local camCommand "MANUAL ON";
_local camCommand "INERTIA ON";
_local cameraEffect ["INTERNAL", "BACK"];
showCinemaBorder false;
BIS_DEBUG_CAM setVectorDir _vectorDir;
BIS_DEBUG_CAM setVectorUp _vectorUp;

_mapIconEH = ((findDisplay 12) displayCtrl 51) ctrlAddEventHandler ["Draw", '
    (_this select 0) drawIcon [
        gettext (configfile >> "RscDisplayCamera" >> "iconCamera"),
        [0,1,1,1],
		position BIS_DEBUG_CAM,
		32,
		32,
		direction BIS_DEBUG_CAM,
		"",
		1
    ];

'];

//--- Key Down
_keyDown = (finddisplay 46) displayaddeventhandler ["keydown","
	_key = _this select 1;
	_ctrl = _this select 3;

	if (_key in (actionkeys 'nightvision')) then {
		BIS_DEBUG_CAM_VISION = BIS_DEBUG_CAM_VISION + 1;
		if (BIS_DEBUG_CAM_ISFLIR) then {
					_vision = BIS_DEBUG_CAM_VISION % 4;
			switch (_vision) do {
				case 0: {
					camusenvg false;
					call compile 'false SetCamUseTi 0';
				};
				case 1: {
					camusenvg true;
					call compile 'false SetCamUseTi 0';
				};
				case 2: {
					camusenvg false;
					call compile 'true SetCamUseTi 0';
				};
				case 3: {
					camusenvg false;
					call compile 'true SetCamUseTi 1';
				};
			};
		} else {
			_vision = BIS_DEBUG_CAM_VISION % 2;
			switch (_vision) do {
				case 0: {
					camusenvg false;
				};
				case 1: {
					camusenvg true;
				};
			};
		};
	};

	if (_key in (actionkeys 'showmap')) then {
		if (BIS_DEBUG_CAM_MAP) then {
			openmap [false,false];
			BIS_DEBUG_CAM_MAP = false;
		} else {
			openmap [true,true];
			BIS_DEBUG_CAM_MAP = true;
			mapanimadd [0,0.1,position BIS_DEBUG_CAM];
			mapanimcommit;
		};
	};

	if (_key == 55) then {
		_worldpos = screentoworld [.5,.5];
		if (_ctrl) then {
			vehicle player setpos _worldpos;
		} else {
			copytoclipboard str _worldpos;
		};
	};
	if (_key == 83 && !isnil 'BIS_DEBUG_CAM_LASTPOS') then {
		BIS_DEBUG_CAM setpos BIS_DEBUG_CAM_LASTPOS;
	};

	if (_key == 41) then {
		BIS_DEBUG_CAM_COLOR ppeffectenable false;
	};
	if (_key >= 2 && _key <= 11) then {
		_id = _key - 2;
		if (_id < count BIS_DEBUG_CAM_PPEFFECTS) then {
			BIS_DEBUG_CAM_COLOR ppEffectAdjust (BIS_DEBUG_CAM_PPEFFECTS select _id);
			BIS_DEBUG_CAM_COLOR ppEffectCommit 0;
			BIS_DEBUG_CAM_COLOR ppeffectenable true;
		};
	};
"];

_map_mousebuttonclick = ((finddisplay 12) displayctrl 51) ctrladdeventhandler ["mousebuttonclick","
	_button = _this select 1;
	_ctrl = _this select 5;
	if (_button == 0) then {
		_x = _this select 2;
		_y = _this select 3;
		_worldpos = (_this select 0) posscreentoworld [_x,_y];
		if (_ctrl) then {
			_veh = vehicle player;
			_veh setpos [_worldpos select 0,_worldpos select 1,position _veh select 2];
		} else {
			BIS_DEBUG_CAM setpos [_worldpos select 0,_worldpos select 1,position BIS_DEBUG_CAM select 2];
		};
	};
"];




//Wait until destroy is forced or camera auto-destroyed.
[_local,_keyDown,_map_mousebuttonclick, _mapIconEH] spawn {
	private ["_local","_keyDown","_map_mousebuttonclick","_lastpos", "_lastVectorUp", "_lastVectorDir"];

	params ["_local", "_keyDown", "_map_mousebuttonclick", "_mapIconEH"];

	waituntil {
		if (!isnull BIS_DEBUG_CAM) then {
				_lastpos = position BIS_DEBUG_CAM; 
				_lastVectorUp = vectorUp BIS_DEBUG_CAM;
				_lastVectorDir = vectorDir BIS_DEBUG_CAM;
			};
		isNull BIS_DEBUG_CAM
	};

	player cameraEffect ["TERMINATE", "BACK"];
	BIS_DEBUG_CAM = nil;
	BIS_DEBUG_CAM_MAP = nil;
	BIS_DEBUG_CAM_VISION = nil;
	camDestroy _local;
	BIS_DEBUG_CAM_LASTPOS = _lastpos;
	BIS_DEBUG_CAM_VECTORUP = _lastVectorUp;
	BIS_DEBUG_CAM_VECTORDIR = _lastVectorDir;

	ppeffectdestroy BIS_DEBUG_CAM_COLOR;
	(finddisplay 46) displayremoveeventhandler ["keydown",_keyDown];
	((findDisplay 12) displayCtrl 51) ctrlRemoveEventHandler ["Draw",_mapIconEH];
	((finddisplay 12) displayctrl 51) ctrlremoveeventhandler ["mousebuttonclick",_map_mousebuttonclick];

};