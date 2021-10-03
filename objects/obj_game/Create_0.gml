enum FOREST_STATE {
	INPUT,
	PLAYER_TURN,
	ENEMY_TURN,
	VENTURE_DEEPER,
	GAME_OVER,
	NUM,
};

enum MENU_OPTIONS {
	ACTION_1,
	ACTION_2,
	ACTION_3,
	NUM,
};

enum ITEM_TYPE {
	BUTTON,
	NUM,
};

enum WINDOWS {
	ACTION,
	HEALTH,
	FOREST,
	NUM,
};

bgX = 0;
bgY = 0;
bgSpd = 1;

menuStrings = [];
menuStrings[MENU_OPTIONS.ACTION_1] = "Action 1";
menuStrings[MENU_OPTIONS.ACTION_2] = "Action 2";
menuStrings[MENU_OPTIONS.ACTION_3] = "Action 3";

windows = [];
windowStack = [];

windowCaptionBarHeight = 49;
contentsPadding = 4;
bodyPadding = 9;
buttonW = sprite_get_width(spr_button);
buttonH = sprite_get_height(spr_button);

playerStats = {
	xPos: 300,
	yPos: 300,
	w: 80,
	h: 120,
	curHealth: 100,
	visHealth: 100,
	maxHealth: 100,
	color: c_yellow,
};

enemyStats = {
	xPos: 300,
	yPos: 600,
	w: 160,
	h: 100,
	curHealth: 100,
	visHealth: 100,
	maxHealth: 100,
	color: c_red,
};

forestState = 0;

draggedWindow = undefined;
dragX = undefined;
dragY = undefined;

function playerAction()
{
	return function() {
		// Player turn
		forestState = FOREST_STATE.PLAYER_TURN;
		enemyStats.curHealth -= irandom_range(6, 10);
		if (enemyStats.curHealth <= 0)
		{
			// Enemy is dead
			enemyStats.curHealth = 0;
			forestState = FOREST_STATE.VENTURE_DEEPER;
			return;
		}
		
		// Enemy turn
		forestState = FOREST_STATE.ENEMY_TURN;
		
		playerStats.curHealth -= irandom_range(4, 7);
		if (playerStats.curHealth <= 0)
		{
			// Enemy is dead
			playerStats.curHealth = 0;
			forestState = FOREST_STATE.GAME_OVER;
			return;
		}
		
		// Finish
		forestState = FOREST_STATE.INPUT;
	};
}

function createWindow(xx, yy, w, h, title)
{
	var window = {
		xPos: xx,
		yPos: yy,
		w: w,
		h: h,
		title: title,
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
	var button = {
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
forestWindow = createWindow(1200, 110, 600, 900, "Hero");

action1Button = createButton(menuStrings[MENU_OPTIONS.ACTION_1], playerAction());
action2Button = createButton(menuStrings[MENU_OPTIONS.ACTION_2], playerAction());
action3Button = createButton(menuStrings[MENU_OPTIONS.ACTION_3], playerAction());
healButton = createButton("Heal");
healButton.disabled = true;

actionButtons = [action1Button, action2Button, action3Button];

addButtonToWindow(actionWindow, action1Button);
addButtonToWindow(actionWindow, action2Button);
addButtonToWindow(actionWindow, action3Button);

addButtonToWindow(healthWindow, healButton);