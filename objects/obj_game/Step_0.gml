bgX -= bgSpd;
bgY += bgSpd;

bgSinElapsed += delta_time_seconds;

if (keyboard_check_pressed(vk_escape))
	game_end();

function recalculateWindowItems(window)
{
	var items = window.items;
	
	var xx = window.xPos + bodyPadding + contentsPadding;
	var yy = window.yPos + windowCaptionBarHeight + contentsPadding;
	for (var j = 0; j < array_length(items); ++j)
	{
		var item = items[j];
		switch (item.type)
		{
			case ITEM_TYPE.BUTTON:
			{
				item.xPos = xx;
				item.yPos = yy;
				item.hover = point_overlap(mouse_x, mouse_y, item.xPos, item.yPos, buttonW, buttonH);
				
				yy += buttonH + contentsPadding;
			} break;
		}
	}
	
	if (window.responsive)
	{
		window.h = yy - window.yPos + bodyPadding;
	}
}

// Calculate all UI element positions
for (var i = 0; i < WINDOWS.NUM; ++i)
{
	recalculateWindowItems(windows[i]);
}

// Only enable that which are available
var actionButtonsDisabled = (forestState != FOREST_STATE.INPUT);
actionButtons[0].disabled = actionButtonsDisabled || (battleRound < 3);
for (var i = 1; i < array_length(actionButtons); ++i)
{
	actionButtons[i].disabled = actionButtonsDisabled || (battleRound >= 3);
}

for (var i = WINDOWS.NUM - 1; i >= 0; --i)
{
	// Check to see if we're trying to drag a window
	var window = windowStack[i];
	if (point_overlap(mouse_x, mouse_y, window.xPos, window.yPos, window.w, windowCaptionBarHeight))
	{
		if (mouse_check_button_pressed(mb_left))
		{
			dragX = mouse_x;
			dragY = mouse_y;
			window.dragX = window.xPos;
			window.dragY = window.yPos;
			draggedWindow = window;
			array_move_to_top(windowStack, window);
		}
	}
	
	// Check all the items of the window
	var items = window.items;
	for (var j = 0; j < array_length(items); ++j)
	{
		var item = items[j];
		switch (item.type)
		{
			case ITEM_TYPE.BUTTON:
			{
				if (item.disabled) continue;
				
				if (item.hover == true)
				{
					if (mouse_check_button_pressed(mb_left))
					{
						var onClick = item.onClick;
						onClick();
					}
				}
			} break;
		}
	}
	
	// Don't send mouse events to other windows if it's captured in this one
	if (point_overlap(mouse_x, mouse_y, window.xPos, window.yPos, window.w, window.h))
	{
		break;
	}
}

if (mouse_check_button(mb_left))
{
	if (draggedWindow != undefined)
	{
		var deltaX = mouse_x - dragX;
		var deltaY = mouse_y - dragY;
		draggedWindow.xPos = draggedWindow.dragX + deltaX;
		draggedWindow.yPos = draggedWindow.dragY + deltaY;
		recalculateWindowItems(draggedWindow);
	}
}
else
{
	if (draggedWindow)
	{
		dragX = dragY = undefined;
		draggedWindow.dragX = draggedWindow.dragY = undefined;
		draggedWindow = undefined;
		// TODO(bret): Do something to make sure we can't let it go out of bounds
	}
}

// Push windows back into place
for (var i = 0; i < array_length(windows); ++i)
{
	var window = windows[i];
	if (window == draggedWindow)
		continue;
	
	if (window.xPos < screenPaddingX)
	{
		window.xPos = lerp(window.xPos, screenPaddingX, 0.3);
	}
	if (window.yPos < screenPaddingY)
	{
		window.yPos = lerp(window.yPos, screenPaddingY, 0.3);
	}
	if (window.xPos + window.w >= room_width - screenPaddingX)
	{
		window.xPos = lerp(window.xPos, room_width - window.w - screenPaddingX - 1, 0.3);
	}
	if (window.yPos + window.h >= room_height - screenPaddingY)
	{
		window.yPos = lerp(window.yPos, room_height - window.h - screenPaddingY - 1, 0.3);
	}
	
	recalculateWindowItems(window);
}

function updateHealth(stats)
{
	var diff = abs(stats.visHealth - stats.curHealth);
	if (diff > 0.1)
		stats.visHealth = lerp(stats.curHealth, stats.visHealth, 0.7);
	else
		stats.visHealth = lerp(stats.curHealth, stats.visHealth, 0.7);
}

switch (forestState)
{
	case FOREST_STATE.INPUT:
	{
		
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
		var oldH = enemyStats.h;
		enemyStats.w *= 1.2;
		enemyStats.h *= 1.2;
		enemyStats.yPos -= enemyStats.h - oldH;
		
		battleRound = 0;
		
		forestState = FOREST_STATE.INPUT;
	} break;
	
	case FOREST_STATE.GAME_OVER:
	{
		show_message("ur ded LMFAO");
		game_end();
	} break;
}

updateHealth(playerStats);
updateHealth(enemyStats);