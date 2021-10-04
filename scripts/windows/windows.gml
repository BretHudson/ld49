#macro delta_time_seconds (delta_time / 1000000)

#macro forestWindowWidth 594
#macro forestWindowHeight 922

#macro windowCaptionBarHeight 49
#macro bodyPadding 9
#macro buttonW sprite_get_width(spr_button)
#macro buttonH sprite_get_height(spr_button)

#macro bgSinDuration 8
#macro bgSinAmplitude 100

#macro globalSpriteFrameTimeout 15

enum ITEM_TYPE
{
	BUTTON,
	HEALTH_BAR,
	MANA_BAR,
	TEXT,
	NUM,
};

function initMenus()
{
    globalSpriteFrameTimer = -1;
    globalSpriteFrame = 0;
    
    draggedWindow = undefined;
    dragX = undefined;
    dragY = undefined;
    
    initWindows();
}

function initWindows()
{
    windowStack = [];
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
	
	array_push(windowStack, window);
	
	return window;
}

function addItemToWindow(window, item)
{
	array_push(window.items, item);
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

function createHealthBar(stats)
{
	var healthBar =
	{
		xPos: -1,
		yPos: -1,
		type: ITEM_TYPE.HEALTH_BAR,
		stats: stats,
	};
	
	return healthBar;
}

function createManaBar(stats)
{
	var manaBar =
	{
		xPos: -1,
		yPos: -1,
		type: ITEM_TYPE.MANA_BAR,
		stats: stats,
	};
	
	return manaBar;
}

function createText(str, font, lineHeight, padding, color)
{
	var text =
	{
		xPos: -1,
		yPos: -1,
		type: ITEM_TYPE.TEXT,
		str: str,
		font: font,
		lineHeight: lineHeight,
		padding: padding,
		color: color,
	};
	
	return text;
}

function recalculateWindowItems(window)
{
    var contentsPadding = 4;
    
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
				item.hover = false;
				
				yy += buttonH + contentsPadding;
			} break;
			
			case ITEM_TYPE.HEALTH_BAR:
			{
				item.xPos = xx;
				item.yPos = yy;
				
				yy += sprite_get_height(spr_heart) + contentsPadding;
			} break;
			
			case ITEM_TYPE.MANA_BAR:
			{
				item.xPos = xx;
				item.yPos = yy;
				
				yy += sprite_get_height(spr_mana) + contentsPadding;
			} break;
			
			case ITEM_TYPE.TEXT:
			{
				item.xPos = xx + 6;
				item.yPos = yy;
				
				draw_set_font(item.font);
				
				yy += string_height(item.str) * item.lineHeight + item.padding;
			} break;
 		}
	}
	
	if (window.responsive)
	{
		window.h = yy - window.yPos + bodyPadding;
	}
}

function return_windows_to_screen(windowStack, draggedWindow)
{
    var screenPaddingX = 96;
    var screenPaddingY = 32;
    
    for (var i = 0; i < array_length(windowStack); ++i)
    {
    	var window = windowStack[i];
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
}

function update_menu(windowStack)
{
    ++globalSpriteFrameTimer;
    if (globalSpriteFrameTimer >= globalSpriteFrameTimeout)
    {
    	globalSpriteFrameTimer = 0;
    	++globalSpriteFrame;
    }
    
    // Calculate all UI element positions
    for (var i = 0; i < array_length(windowStack); ++i)
    {
    	recalculateWindowItems(windowStack[i]);
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
    	}
    }
    
    // Push windows back into place
    return_windows_to_screen(windowStack, draggedWindow);
    
    var moveToTop = undefined;
    for (var i = array_length(windowStack) - 1; i >= 0; --i)
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
    			moveToTop = window;
    			audio_play_sound(snd_drag_window, 1, 0);
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
    				
    				item.hover = point_overlap(mouse_x, mouse_y, item.xPos, item.yPos, buttonW, buttonH);
    				if (item.hover == true)
    				{
    					if (mouse_check_button_pressed(mb_left))
    					{
    						var onClick = item.onClick;
    						onClick();
    						audio_play_sound(snd_click, 1, 0);
    					}
    				}
    			} break;
    		}
    	}
    	
    	// Don't send mouse events to other windows if it's captured in this one
    	if (point_overlap(mouse_x, mouse_y, window.xPos, window.yPos, window.w, window.h))
    	{
    		if (mouse_check_button_pressed(mb_left))
    		{
    			// Clicked this mofo
    			moveToTop = window;
    		}
    		break;
    	}
    }
    
    if (moveToTop)
    	array_move_to_top(windowStack, moveToTop);
}
