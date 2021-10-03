enum PLAYER_TURN_STATE
{
	ANIMATE_ACTION,
	EXECUTE_ACTION,
	DONE,
	NUM,
};

function forest_player_turn(state)
{
    switch (state.state)
    {
        case PLAYER_TURN_STATE.ANIMATE_ACTION:
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
        
        case PLAYER_TURN_STATE.EXECUTE_ACTION:
        {
            enemyStats.curHealth -= irandom_range(6, 10);
    		if (enemyStats.curHealth <= 0)
    		{
    			// Enemy is dead
    			enemyStats.curHealth = 0;
    			forestState = FOREST_STATE.VENTURE_DEEPER;
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
	EXECUTE_ATTACK,
	APPLY_DAMAGE,
	DONE,
	NUM,
};

function forest_enemy_turn(state)
{
    switch (state.state)
    {
        case ENEMY_TURN_STATE.EXECUTE_ATTACK:
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
        
        case ENEMY_TURN_STATE.APPLY_DAMAGE:
        {
            playerStats.curHealth -= irandom_range(4, 7);
    		if (playerStats.curHealth <= 0)
    		{
    			// Player is dead
    			playerStats.curHealth = 0;
    			forestState = FOREST_STATE.GAME_OVER;
    		}
            
            ++state.state;
        } break;
        
        case ENEMY_TURN_STATE.DONE:
        {
            ++battleRound;
            
            forestState = FOREST_STATE.INPUT;
        } break;
        
        default:
        {
            ++state.state;
        } break;
    }
}