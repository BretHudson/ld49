#macro delta_time_seconds (delta_time / 1000000)
#macro forestWindowWidth 594
#macro forestWindowHeight 922

enum FOREST_STATE
{
	// START_BATTLE,
	INPUT,
	PLAYER_TURN,
	ENEMY_TURN,
	// FINISH_BATTLE,
	VENTURE_DEEPER,
	GAME_OVER,
	NUM,
};

enum ITEM_TYPE
{
	BUTTON,
	NUM,
};

enum WINDOWS
{
	ACTION,
	HEALTH,
	FOREST,
	NUM,
};

enum PLAYER_ACTION
{
	ATTACK,
	CALL_OUT,
	DRAW_WEAPON,
	APPROACH,
	THREATEN,
	WAVE_TORCH,
	NUM,
};

enum CHARACTER_TYPES
{
	PLAYER,
	GOLEM,
	MUMMY,
	SKELETON,
	SLIME,
	SPIDER,
	SPIRIT,
	NUM,
};

forestZoom = 6;

characterSprites = [];
characterSprites[CHARACTER_TYPES.PLAYER] = spr_enemy_skeleton;
characterSprites[CHARACTER_TYPES.GOLEM] = spr_enemy_golem;
characterSprites[CHARACTER_TYPES.MUMMY] = spr_enemy_mummy;
characterSprites[CHARACTER_TYPES.SKELETON] = spr_enemy_skeleton;
characterSprites[CHARACTER_TYPES.SLIME] = spr_enemy_slime;
characterSprites[CHARACTER_TYPES.SPIDER] = spr_enemy_spider;
characterSprites[CHARACTER_TYPES.SPIRIT] = spr_enemy_spirit;

bgX = 0;
bgY = 0;
bgSpd = 1;

menuStrings = [];
menuStrings[PLAYER_ACTION.ATTACK] = "Attack";
menuStrings[PLAYER_ACTION.CALL_OUT] = "Call Out";
menuStrings[PLAYER_ACTION.DRAW_WEAPON] = "Draw Weapon";
menuStrings[PLAYER_ACTION.APPROACH] = "Approach";
menuStrings[PLAYER_ACTION.THREATEN] = "Threaten";
menuStrings[PLAYER_ACTION.WAVE_TORCH] = "Wave Torch";

battleRound = 0;

windows = [];
windowStack = [];

bgSinElapsed = 0;
bgSinDuration = 8;
bgSinAmplitude = 100;

screenPaddingX = 96;
screenPaddingY = 32;

windowCaptionBarHeight = 49;
contentsPadding = 4;
bodyPadding = 9;
buttonW = sprite_get_width(spr_button);
buttonH = sprite_get_height(spr_button);

playerStats =
{
	type: CHARACTER_TYPES.PLAYER,
	xPos: (forestWindowWidth / forestZoom) / 2,
	yPos: (forestWindowWidth / forestZoom) / 2,
	w: 80,
	h: 120,
	curHealth: 100,
	visHealth: 100,
	maxHealth: 100,
	color: c_yellow,
};

enemyStats =
{
	type: CHARACTER_TYPES.SPIDER,
	xPos: (forestWindowWidth / forestZoom) / 2,
	yPos: (forestWindowWidth / forestZoom),
	w: 160,
	h: 100,
	curHealth: 100,
	visHealth: 100,
	maxHealth: 100,
	color: c_red,
};

forestState = 0;

playerTurnState =
{
	state: -1,
	elapsed: 0,
};

enemyTurnState =
{
	state: -1,
	elapsed: 0,
};

draggedWindow = undefined;
dragX = undefined;
dragY = undefined;

function playerAction(action)
{
	var methodState = 
	{
		id: self.id,
		action: action,
	};
	
	return method(methodState, function()
	{
		var _action = action; // From methodState
		with (id)
		{
			playerTurnState.elapsed = 0;
			playerTurnState.state = 0;
			playerTurnState.action = _action;
			forestState = FOREST_STATE.PLAYER_TURN;
		}
	});
}

function createWindow(xx, yy, w, h, title, responsive = true)
{
	var window =
	{
		xPos: xx,
		yPos: yy,
		w: w,
		h: h,
		title: title,
		responsive: responsive,
		dragX: undefined,
		dragY: undefined,
		items: [],
	};
	
	array_push(windows, window);
	array_push(windowStack, window);
	
	return window;
}

function createButton(str, onClick)
{
	var button =
	{
		xPos: -1,
		yPos: -1,
		type: ITEM_TYPE.BUTTON,
		hover: false,
		clicked: false,
		disabled: false,
		str: str,
		onClick: onClick,
	};
	
	return button;
}

function addButtonToWindow(window, button)
{
	array_push(window.items, button);
}

actionWindow = createWindow(100, 400, 401, 600, "Battle");
healthWindow = createWindow(600, 100, 401, 250, "Health");
forestWindow = createWindow(1200, 110, forestWindowWidth, forestWindowHeight, "Hero", false);

actionButtons = [];

for (var i = 0; i < PLAYER_ACTION.NUM; ++i)
{
	var actionButton = createButton(menuStrings[i], playerAction(i));
	array_push(actionButtons, actionButton);
	addButtonToWindow(actionWindow, actionButton);
}

healButton = createButton("Heal");
healButton.disabled = true;

addButtonToWindow(healthWindow, healButton);