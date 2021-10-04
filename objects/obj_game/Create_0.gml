REACTS_TO_ACTION = true;

randomize();

enum FOREST_STATE
{
	ENTER_FOREST,
	// START_BATTLE,
	APPROACH_ENEMY,
	INPUT,
	PLAYER_TURN,
	ENEMY_TURN,
	// FINISH_BATTLE,
	VENTURE_DEEPER,
	GAME_OVER,
	NUM,
};

enum PLAYER_ACTION
{
	ATTACK_1,
	ATTACK_2,
	ATTACK_3,
	
	HEAL,
	
	CALL_OUT,
	DRAW_WEAPON,
	APPROACH,
	THREATEN,
	WAVE_TORCH,
	
	NUM,
};

enum CHARACTER_TYPES
{
	GOLEM,
	MUMMY,
	SKELETON,
	SLIME,
	SPIDER,
	SPIRIT,
	NUM,
};

enum RESPONSE_TO_ATTACK
{
	NORMAL,
	WEAK,
	IMMUNITY,
	NUM,
};

function random_enemy_type()
{
	return irandom_range(1, CHARACTER_TYPES.NUM - 1);
}

forestZoom = 6;
cameraY = 0;
cameraSpd = 1;
forestSurface = -1;
fogSurface = -1;
fogX = 0;
fogY = 0;

enemiesDefeated = 0;

characterSprites = [];
characterSprites[CHARACTER_TYPES.GOLEM] = spr_enemy_golem;
characterSprites[CHARACTER_TYPES.MUMMY] = spr_enemy_mummy;
characterSprites[CHARACTER_TYPES.SKELETON] = spr_enemy_skeleton;
characterSprites[CHARACTER_TYPES.SLIME] = spr_enemy_slime;
characterSprites[CHARACTER_TYPES.SPIDER] = spr_enemy_spider;
characterSprites[CHARACTER_TYPES.SPIRIT] = spr_enemy_spirit;

characterIdleSprites = [];
characterIdleSprites[CHARACTER_TYPES.GOLEM] = spr_enemy_golem_idle;
characterIdleSprites[CHARACTER_TYPES.MUMMY] = spr_enemy_mummy_idle;
characterIdleSprites[CHARACTER_TYPES.SKELETON] = spr_enemy_skeleton_idle;
characterIdleSprites[CHARACTER_TYPES.SLIME] = spr_enemy_slime_idle;
characterIdleSprites[CHARACTER_TYPES.SPIDER] = spr_enemy_spider_idle;
characterIdleSprites[CHARACTER_TYPES.SPIRIT] = spr_enemy_spirit_idle;

reactions = [];
for (var i = 1; i < PLAYER_ACTION.NUM; ++i)
{
	reactions[i] = array_create(CHARACTER_TYPES.NUM);
}

// Actions
reactions[PLAYER_ACTION.ATTACK_1][CHARACTER_TYPES.GOLEM] =		RESPONSE_TO_ATTACK.IMMUNITY;
reactions[PLAYER_ACTION.ATTACK_1][CHARACTER_TYPES.MUMMY] =		RESPONSE_TO_ATTACK.WEAK;
reactions[PLAYER_ACTION.ATTACK_1][CHARACTER_TYPES.SKELETON] =	RESPONSE_TO_ATTACK.WEAK;
reactions[PLAYER_ACTION.ATTACK_1][CHARACTER_TYPES.SLIME] =		RESPONSE_TO_ATTACK.IMMUNITY;
reactions[PLAYER_ACTION.ATTACK_1][CHARACTER_TYPES.SPIDER] =		RESPONSE_TO_ATTACK.WEAK;
reactions[PLAYER_ACTION.ATTACK_1][CHARACTER_TYPES.SPIRIT] =		RESPONSE_TO_ATTACK.NORMAL;

reactions[PLAYER_ACTION.ATTACK_2][CHARACTER_TYPES.GOLEM] =		RESPONSE_TO_ATTACK.NORMAL;
reactions[PLAYER_ACTION.ATTACK_2][CHARACTER_TYPES.MUMMY] =		RESPONSE_TO_ATTACK.IMMUNITY;
reactions[PLAYER_ACTION.ATTACK_2][CHARACTER_TYPES.SKELETON] =	RESPONSE_TO_ATTACK.IMMUNITY;
reactions[PLAYER_ACTION.ATTACK_2][CHARACTER_TYPES.SLIME] =		RESPONSE_TO_ATTACK.WEAK;
reactions[PLAYER_ACTION.ATTACK_2][CHARACTER_TYPES.SPIDER] =		RESPONSE_TO_ATTACK.NORMAL;
reactions[PLAYER_ACTION.ATTACK_2][CHARACTER_TYPES.SPIRIT] =		RESPONSE_TO_ATTACK.WEAK;

reactions[PLAYER_ACTION.ATTACK_3][CHARACTER_TYPES.GOLEM] =		RESPONSE_TO_ATTACK.WEAK;
reactions[PLAYER_ACTION.ATTACK_3][CHARACTER_TYPES.MUMMY] =		RESPONSE_TO_ATTACK.NORMAL;
reactions[PLAYER_ACTION.ATTACK_3][CHARACTER_TYPES.SKELETON] =	RESPONSE_TO_ATTACK.NORMAL;
reactions[PLAYER_ACTION.ATTACK_3][CHARACTER_TYPES.SLIME] =		RESPONSE_TO_ATTACK.NORMAL;
reactions[PLAYER_ACTION.ATTACK_3][CHARACTER_TYPES.SPIDER] =		RESPONSE_TO_ATTACK.IMMUNITY;
reactions[PLAYER_ACTION.ATTACK_3][CHARACTER_TYPES.SPIRIT] =		RESPONSE_TO_ATTACK.IMMUNITY;

// Identify
reactions[PLAYER_ACTION.CALL_OUT][CHARACTER_TYPES.GOLEM] = false;
reactions[PLAYER_ACTION.CALL_OUT][CHARACTER_TYPES.MUMMY] = REACTS_TO_ACTION;
reactions[PLAYER_ACTION.CALL_OUT][CHARACTER_TYPES.SKELETON] = false;
reactions[PLAYER_ACTION.CALL_OUT][CHARACTER_TYPES.SLIME] = false;
reactions[PLAYER_ACTION.CALL_OUT][CHARACTER_TYPES.SPIDER] = REACTS_TO_ACTION;
reactions[PLAYER_ACTION.CALL_OUT][CHARACTER_TYPES.SPIRIT] = REACTS_TO_ACTION;

reactions[PLAYER_ACTION.DRAW_WEAPON][CHARACTER_TYPES.GOLEM] = false;
reactions[PLAYER_ACTION.DRAW_WEAPON][CHARACTER_TYPES.MUMMY] = REACTS_TO_ACTION;
reactions[PLAYER_ACTION.DRAW_WEAPON][CHARACTER_TYPES.SKELETON] = false;
reactions[PLAYER_ACTION.DRAW_WEAPON][CHARACTER_TYPES.SLIME] = REACTS_TO_ACTION;
reactions[PLAYER_ACTION.DRAW_WEAPON][CHARACTER_TYPES.SPIDER] = REACTS_TO_ACTION;
reactions[PLAYER_ACTION.DRAW_WEAPON][CHARACTER_TYPES.SPIRIT] = false;

reactions[PLAYER_ACTION.APPROACH][CHARACTER_TYPES.GOLEM] = REACTS_TO_ACTION;
reactions[PLAYER_ACTION.APPROACH][CHARACTER_TYPES.MUMMY] = REACTS_TO_ACTION;
reactions[PLAYER_ACTION.APPROACH][CHARACTER_TYPES.SKELETON] = REACTS_TO_ACTION;
reactions[PLAYER_ACTION.APPROACH][CHARACTER_TYPES.SLIME] = false;
reactions[PLAYER_ACTION.APPROACH][CHARACTER_TYPES.SPIDER] = REACTS_TO_ACTION;
reactions[PLAYER_ACTION.APPROACH][CHARACTER_TYPES.SPIRIT] = false;

reactions[PLAYER_ACTION.THREATEN][CHARACTER_TYPES.GOLEM] = false;
reactions[PLAYER_ACTION.THREATEN][CHARACTER_TYPES.MUMMY] = REACTS_TO_ACTION;
reactions[PLAYER_ACTION.THREATEN][CHARACTER_TYPES.SKELETON] = REACTS_TO_ACTION;
reactions[PLAYER_ACTION.THREATEN][CHARACTER_TYPES.SLIME] = false;
reactions[PLAYER_ACTION.THREATEN][CHARACTER_TYPES.SPIDER] = false;
reactions[PLAYER_ACTION.THREATEN][CHARACTER_TYPES.SPIRIT] = REACTS_TO_ACTION;

reactions[PLAYER_ACTION.WAVE_TORCH][CHARACTER_TYPES.GOLEM] = false;
reactions[PLAYER_ACTION.WAVE_TORCH][CHARACTER_TYPES.MUMMY] = false;
reactions[PLAYER_ACTION.WAVE_TORCH][CHARACTER_TYPES.SKELETON] = REACTS_TO_ACTION;
reactions[PLAYER_ACTION.WAVE_TORCH][CHARACTER_TYPES.SLIME] = false;
reactions[PLAYER_ACTION.WAVE_TORCH][CHARACTER_TYPES.SPIDER] = REACTS_TO_ACTION;
reactions[PLAYER_ACTION.WAVE_TORCH][CHARACTER_TYPES.SPIRIT] = REACTS_TO_ACTION;

menuStrings = [];
menuStrings[PLAYER_ACTION.ATTACK_1] = "Fire";
menuStrings[PLAYER_ACTION.ATTACK_2] = "Poison";
menuStrings[PLAYER_ACTION.ATTACK_3] = "Earth";
menuStrings[PLAYER_ACTION.HEAL] = "Heal";
menuStrings[PLAYER_ACTION.CALL_OUT] = "Call Out to Enemy";
menuStrings[PLAYER_ACTION.DRAW_WEAPON] = "Draw Weapon";
menuStrings[PLAYER_ACTION.APPROACH] = "Approach";
menuStrings[PLAYER_ACTION.THREATEN] = "Threaten";
menuStrings[PLAYER_ACTION.WAVE_TORCH] = "Wave Torch";

freeActions = 3;
hasAttacked = false;

initMenus();

var centerForestWindow = (forestWindowWidth / forestZoom) / 2;
var height = (forestWindowHeight - bodyPadding - windowCaptionBarHeight) / forestZoom;

playerTargetY = height - centerForestWindow + sprite_get_height(spr_player_idle);

playerStats = 
{
	xPos: centerForestWindow,
	yPos: forestWindowHeight / forestZoom + 150,
	yOffset: 0,
	curHealth: 5,
	maxHealth: 5,
	curMana: 2,
	maxMana: 5,
	executingAction: false,
};

enemyStartY = -50;
enemyTargetY = ceil(centerForestWindow); // 50

enemyStartingType = random_enemy_type();
enemyStats =
{
	type: enemyStartingType,
	visual: enemyStartingType,
	xPos: centerForestWindow,
	yPos: enemyStartY,
	yOffset: 0,
	curHealth: 3,
	maxHealth: 3,
	reacted: false,
	subImg: -1,
	rot: 0,
	executingAction: false,
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

identifyWindow = createWindow(100, 420, 401, 600, "Identify");
attackWindow = createWindow(100, 150, 401, 600, "Attack");
healthWindow = createWindow(600, 250, 401, 250, "Health - Player");
manaWindow = createWindow(600, 100, 401, 250, "Mana");
enemyStatsWindow = createWindow(600, 550, 401, 250, "Health - Enemy");
forestWindow = createWindow(1200, 110, forestWindowWidth, forestWindowHeight, "Hero - Forest Entrance", false);

actionButtons = [];

for (var i = 0; i < PLAYER_ACTION.NUM; ++i)
{
	var actionButton = createButton(menuStrings[i], playerAction(i));
	array_push(actionButtons, actionButton);
}

addItemToWindow(identifyWindow, actionButtons[PLAYER_ACTION.CALL_OUT]);
addItemToWindow(identifyWindow, actionButtons[PLAYER_ACTION.DRAW_WEAPON]);
addItemToWindow(identifyWindow, actionButtons[PLAYER_ACTION.APPROACH]);
addItemToWindow(identifyWindow, actionButtons[PLAYER_ACTION.THREATEN]);
addItemToWindow(identifyWindow, actionButtons[PLAYER_ACTION.WAVE_TORCH]);

addItemToWindow(attackWindow, actionButtons[PLAYER_ACTION.ATTACK_1]);
addItemToWindow(attackWindow, actionButtons[PLAYER_ACTION.ATTACK_2]);
addItemToWindow(attackWindow, actionButtons[PLAYER_ACTION.ATTACK_3]);

playerHealthBar = createHealthBar(playerStats);
addItemToWindow(healthWindow, playerHealthBar);
addItemToWindow(healthWindow, actionButtons[PLAYER_ACTION.HEAL]);

manaBar = createManaBar(playerStats);
addItemToWindow(manaWindow, manaBar);

enemyHealthBar = createHealthBar(enemyStats);
addItemToWindow(enemyStatsWindow, enemyHealthBar);