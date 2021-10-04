enum PLAYER_TURN_STATE
{
    BEGIN_ACTION,
    MOVE_TO_ENEMY,
	ANIMATE_ACTION,
	MOVE_FROM_ENEMY,
	END_ACTION,
	DONE,
	NUM,
};

#macro moveDuration 0.6

function forest_player_turn(state)
{
    switch (state.state)
    {
        case PLAYER_TURN_STATE.BEGIN_ACTION:
        {
        	playerStats.executingAction = true;
        	
            switch (state.action)
            {
                case PLAYER_ACTION.ATTACK_1:
                case PLAYER_ACTION.ATTACK_2:
                case PLAYER_ACTION.ATTACK_3:
                {
                	state.distance = playerStats.yPos - enemyStats.yPos - 16;
                	
                	if (globalSpriteFrameTimer == 0)
                    {
	                    freeActions = 0;
	                    hasAttacked = true;
                    }
                } break;
                
                case PLAYER_ACTION.HEAL:
                {
                    if (globalSpriteFrameTimer == 0)
                    {
                    	audio_play_sound(snd_heal, 1, 0);
                        ++playerStats.curHealth;
                        --playerStats.curMana;
                    }
                } break;
                
                case PLAYER_ACTION.CALL_OUT:
                case PLAYER_ACTION.DRAW_WEAPON:
                case PLAYER_ACTION.APPROACH:
                case PLAYER_ACTION.THREATEN:
                case PLAYER_ACTION.WAVE_TORCH:
                {
                    if (globalSpriteFrameTimer == 0)
                    {
                        enemyStats.reacted = reactions[state.action][enemyStats.type];
                        if (freeActions > 0)
	                    {
	                        --freeActions;
	                    }
	                    else
	                    {
	                        --playerStats.curMana;
	                    }
                    }
                } break;
            }
            
            if (globalSpriteFrameTimer == 0)
            {
                state.elapsed = 0;
                ++state.state;
            }
        } break;
        
        case PLAYER_TURN_STATE.MOVE_TO_ENEMY:
        {
        	switch (state.action)
            {
                case PLAYER_ACTION.ATTACK_1:
                case PLAYER_ACTION.ATTACK_2:
                case PLAYER_ACTION.ATTACK_3:
                {
                	playerStats.yOffset = lerp(0, -state.distance, easeInOutQuart(state.elapsed / moveDuration));
                	
                	if (state.elapsed < moveDuration)
                	{
                		state.elapsed += delta_time_seconds;
                	}
                	else
                	{
                		audio_play_sound(snd_hit, 1, 0);
                		playerStats.yOffset = -state.distance;
                		state.elapsed = 0;
                		++state.state;
                		
                		switch (reactions[state.action][enemyStats.type])
	                    {
	                        case RESPONSE_TO_ATTACK.NORMAL:
	                        {
	                            --enemyStats.curHealth;
	                        } break;
	                        
	                        case RESPONSE_TO_ATTACK.WEAK:
	                        {
	                            enemyStats.curHealth -= 2;
	                        } break;
	                        
	                        case RESPONSE_TO_ATTACK.IMMUNITY:
	                        {
	                            // Do nothing
	                        } break;
	                    }
	                    
	            		if (enemyStats.curHealth <= 0)
	            		{
	            			// Enemy is dead
	            			enemyStats.curHealth = 0;
	            			forestState = FOREST_STATE.VENTURE_DEEPER;
	            			playerStats.curMana += 2;
	            		}
                	}
                } break;
                
                default:
                {
                	++state.state;
                } break;
            }
        } break;
        
        case PLAYER_TURN_STATE.ANIMATE_ACTION:
        {
            var actionDuration = 0.5;
            if (enemyStats.reacted)
            {
                actionDuration = 1.75;
                if ((state.elapsed < 0.25) ||
                    ((state.elapsed > 0.75) && (state.elapsed < 1.0)) ||
                    (state.elapsed > 1.5))
                {
                    enemyStats.subImg = 0;
                }
                else
                {
                    enemyStats.subImg = 1;
                }
                
                var t = state.elapsed / actionDuration;
                enemyStats.rot = -sin(t * pi * 8) * (15 * (1 - t * 0.9));
            }
            
            if (state.elapsed < actionDuration)
            {
                state.elapsed += delta_time_seconds;
            }
            else
            {
                state.elapsed = 0;
                
                enemyStats.rot = 0;
                
                ++state.state;
            }
        } break;
        
        case PLAYER_TURN_STATE.MOVE_FROM_ENEMY:
        {
        	switch (state.action)
            {
                case PLAYER_ACTION.ATTACK_1:
                case PLAYER_ACTION.ATTACK_2:
                case PLAYER_ACTION.ATTACK_3:
                {
                	playerStats.yOffset = lerp(-state.distance, 0, easeInOutQuart(state.elapsed / moveDuration));
                	
                	if (state.elapsed < moveDuration)
                	{
                		state.elapsed += delta_time_seconds;
                	}
                	else
                	{
                		playerStats.yOffset = 0;
                		state.elapsed = 0;
                		++state.state;
                	}
                } break;
                
                default:
                {
                	++state.state;
                } break;
            }
        } break;
        
        case PLAYER_TURN_STATE.END_ACTION:
        {
        	playerStats.executingAction = false;
        	
            switch (state.action)
            {
                case PLAYER_ACTION.CALL_OUT:
                case PLAYER_ACTION.DRAW_WEAPON:
                case PLAYER_ACTION.APPROACH:
                case PLAYER_ACTION.THREATEN:
                case PLAYER_ACTION.WAVE_TORCH:
                {
                    enemyStats.reacted = false;
                    enemyStats.subImg = -1;
                } break;
            }
            
            ++state.state;
        } break;
        
        case PLAYER_TURN_STATE.DONE:
        {
            enemyTurnState.elapsed = 0;
		    enemyTurnState.state = 0;
            
            forestState = FOREST_STATE.ENEMY_TURN;
        } break;
        
        default:
        {
            ++state.state;
        } break;
    }
}

enum ENEMY_TURN_STATE
{
	BEGIN_ACTION,
	MOVE_TO_PLAYER,
	ANIMATE_ACTION,
	MOVE_FROM_PLAYER,
	END_ACTION,
	DONE,
	NUM,
};

function forest_enemy_turn(state)
{
    switch (state.state)
    {
        case ENEMY_TURN_STATE.BEGIN_ACTION:
        {
        	if (hasAttacked == false)
        	{
                state.state = ENEMY_TURN_STATE.DONE;
                break;
        	}
        	
        	enemyStats.executingAction = true;
        	state.distance = playerStats.yPos - enemyStats.yPos - 16;
        	
        	++state.state;
        } break;
        
        case ENEMY_TURN_STATE.MOVE_TO_PLAYER:
        {
    		enemyStats.yOffset = lerp(0, state.distance, easeInOutQuart(state.elapsed / moveDuration));
            	
        	if (state.elapsed < moveDuration)
        	{
        		state.elapsed += delta_time_seconds;
        	}
        	else
        	{
        		audio_play_sound(snd_hit, 1, 0);
        		enemyStats.yOffset = state.distance;
	    		
        		--playerStats.curHealth;
	    		if (playerStats.curHealth <= 0)
	    		{
	    			// Player is dead
	    			playerStats.curHealth = 0;
	    			forestState = FOREST_STATE.GAME_OVER;
	    		}
	    		
        		state.elapsed = 0;
        		++state.state;
        	}
        } break;
        
        case ENEMY_TURN_STATE.ANIMATE_ACTION:
        {
            if (state.elapsed < 0.5)
            {
                state.elapsed += delta_time_seconds;
            }
            else
            {
                state.elapsed = 0;
                ++state.state;
            }
        } break;
        
        case ENEMY_TURN_STATE.MOVE_FROM_PLAYER:
        {
        	enemyStats.yOffset = lerp(state.distance, 0, easeInOutQuart(state.elapsed / moveDuration));
                	
        	if (state.elapsed < moveDuration)
        	{
        		state.elapsed += delta_time_seconds;
        	}
        	else
        	{
        		enemyStats.yOffset = 0;
        		state.elapsed = 0;
        		++state.state;
        	}
        } break;
        
        case ENEMY_TURN_STATE.END_ACTION:
        {
        	enemyStats.executingAction = false;
            ++state.state;
        } break;
        
        case ENEMY_TURN_STATE.DONE:
        {
            forestState = FOREST_STATE.INPUT;
        } break;
        
        default:
        {
            ++state.state;
        } break;
    }
}