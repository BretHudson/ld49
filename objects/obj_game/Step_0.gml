
window_set_caption("Free Actions: " + string(freeActions));

if (keyboard_check_pressed(vk_escape))
	room_goto(rm_menu);

if (keyboard_check_pressed(vk_space))
{
	enemyStats.visual++;
	if (enemyStats.visual >= CHARACTER_TYPES.NUM)
		enemyStats.visual = 0;
}

// Only enable that which are available
var actionButtonsDisabled = (forestState != FOREST_STATE.INPUT);
for (var i = 0; i < array_length(actionButtons); ++i)
	actionButtons[i].disabled = actionButtonsDisabled;
	
actionButtons[PLAYER_ACTION.HEAL].disabled |= (playerStats.curHealth == playerStats.maxHealth) || (playerStats.curMana == 0);
	
for (var i = PLAYER_ACTION.CALL_OUT; i < array_length(actionButtons); ++i)
	actionButtons[i].disabled |= (freeActions == 0) && (playerStats.curMana == 0);

update_menu(windowStack);

fogX -= 0.05;
fogY += 0.05;

switch (forestState)
{
	case FOREST_STATE.ENTER_FOREST:
	{
		if (playerStats.yPos > playerTargetY)
		{
			playerStats.yPos -= cameraSpd;
		}
		else
		{
			forestState = FOREST_STATE.APPROACH_ENEMY;
		}
	} break;
	
	case FOREST_STATE.APPROACH_ENEMY:
	{
		if (enemyStats.yPos < enemyTargetY)
		{
			enemyStats.yPos += cameraSpd;
			cameraY -= cameraSpd;
			if (cameraY < -sprite_get_height(spr_forest))
			{
				cameraY += sprite_get_height(spr_forest);
			}
			fogY += cameraSpd * 0.2;
			if (fogY < -sprite_get_height(spr_fog))
			{
				fogY += sprite_get_height(spr_fog);
			}
		}
		else
		{
			forestState = FOREST_STATE.INPUT;
		}
	} break;
	
	case FOREST_STATE.INPUT:
	{
		// Don't do anything special, all is handled above :)
	} break;
	
	case FOREST_STATE.PLAYER_TURN:
	{
		forest_player_turn(playerTurnState);
	} break;
	
	case FOREST_STATE.ENEMY_TURN:
	{
		forest_enemy_turn(enemyTurnState);
	} break;
	
	case FOREST_STATE.VENTURE_DEEPER:
	{
		enemyStats.curHealth = enemyStats.maxHealth;
		enemyStats.type = random_enemy_type();
		enemyStats.visual = enemyStats.type;
		enemyStats.yPos = enemyStartY;
		
		enemyStats.reacted = false;
        enemyStats.subImg = -1;
		
		freeActions = 3;
		hasAttacked = false;
		
		forestState = FOREST_STATE.APPROACH_ENEMY;
	} break;
	
	case FOREST_STATE.GAME_OVER:
	{
		room_goto(rm_menu);
	} break;
}