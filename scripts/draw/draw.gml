function draw_rect(xx, yy, w, h, outline)
{
    var x1 = xx;
    var y1 = yy;
    var x2 = x1 + w - 1;
    var y2 = y1 + h - 1;
    draw_rectangle(x1, y1, x2, y2, outline);
}

function draw_nineslice(sprite, xx, yy, w, h, subimg = 0)
{
    var xScale = w / sprite_get_width(sprite);
    var yScale = h / sprite_get_height(sprite);
    draw_sprite_ext(sprite, subimg, xx, yy, xScale, yScale, 0, c_white, 1);
    
    return;
    
    // NOTE(bret): Realized that there is a built-in nineslice as of 2.3.2
    var leftWidth = 32;
    var rightWidth = 92;
    var middleWidth = sprite_get_width(sprite) - leftWidth - rightWidth;
    
    var topHeight = 80;
    var bottomHeight = 36;
    var middleHeight = sprite_get_height(sprite) - topHeight - bottomHeight;
    
    var srcX = 0;
    var srcY = 0;
    var drawX = xx;
    var drawY = yy;
    
    /*var xScale = 1;
    var yScale = 1;*/
    
    // Top row
    draw_sprite_part(sprite, subimg, srcX, srcY, leftWidth, topHeight, drawX, drawY);
    
    srcX += leftWidth;
    drawX += leftWidth;
    
    draw_sprite_part_ext(sprite, subimg, srcX, srcY, middleWidth, topHeight, drawX, drawY, xScale, 1, c_white, 1);
    
    srcX += middleWidth;
    drawX += middleWidth;
    
    draw_sprite_part(sprite, subimg, srcX, srcY, rightWidth, topHeight, drawX, drawY);
    
    // Middle row
    srcX = 0;
    srcY += topHeight;
    drawX = xx;
    drawY += topHeight;
    
    draw_sprite_part(sprite, subimg, srcX, srcY, leftWidth, middleHeight, drawX, drawY);
    
    srcX += leftWidth;
    drawX += leftWidth;
    
    draw_sprite_part_ext(sprite, subimg, srcX, srcY, middleWidth, middleHeight, drawX, drawY, xScale, yScale, c_white, 1);
    
    srcX += middleWidth;
    drawX += middleWidth;
    
    draw_sprite_part(sprite, subimg, srcX, srcY, rightWidth, middleHeight, drawX, drawY);
    
    // Bottom row
    srcX = 0;
    srcY += middleHeight;
    drawX = xx;
    drawY += middleHeight;
    
    draw_sprite_part(sprite, subimg, srcX, srcY, leftWidth, bottomHeight, drawX, drawY);
    
    srcX += leftWidth;
    drawX += leftWidth;
    
    draw_sprite_part_ext(sprite, subimg, srcX, srcY, middleWidth, bottomHeight, drawX, drawY, xScale, yScale, c_white, 1);
    
    srcX += middleWidth;
    drawX += middleWidth;
    
    draw_sprite_part(sprite, subimg, srcX, srcY, rightWidth, bottomHeight, drawX, drawY);
}

function draw_background()
{
    draw_sprite_tiled_ext(bg_pattern, 0, bgX, bgY, 1, 1, c_white, 1);
    draw_sprite_tiled_ext(bg_background, 0, 0, sin(bgSinElapsed * bgSinDuration) * bgSinAmplitude, 1, 1, c_white, 1);
}

function draw_windows(windowStack, forestWindow = undefined)
{
    for (var i = 0; i < array_length(windowStack); ++i)
    {
    	var window = windowStack[i];
    	
    	draw_set_color(c_dkgray);
    	draw_nineslice(spr_window_shadow, window.xPos - 16, window.yPos + 24, window.w, window.h, false);
    }
    
    for (var i = 0; i < array_length(windowStack); ++i)
    {
    	var window = windowStack[i];
    
    	draw_set_color(c_white);
    	if (window == forestWindow)
    		draw_set_color($FF8080);
    	draw_rect(window.xPos + bodyPadding, window.yPos + windowCaptionBarHeight, window.w - bodyPadding * 2, window.h - bodyPadding - windowCaptionBarHeight, false);
    	draw_nineslice(spr_window_nineslice, window.xPos, window.yPos, window.w, window.h);
    	
    	// Draw window caption
    	draw_set_color(c_white);
    	draw_set_valign(fa_middle);
    	draw_set_font(ft_caption);
    	
    	var drawY = window.yPos + ceil(windowCaptionBarHeight / 2) + 1;
    	draw_text(window.xPos + 21, drawY, window.title);
    	
    	draw_set_valign(fa_top);
    	draw_set_color(c_white);
    	
    	// Draw items
    	var items = window.items;
    	for (var j = 0; j < array_length(items); ++j)
    	{
    		var item = items[j];
    		
    		switch (item.type)
    		{
    			case ITEM_TYPE.BUTTON:
    			{
    				var subimg = item.hover ? 1 : 0;
    				if (item.disabled)
    					subimg = 2;
    				
    				draw_sprite(spr_button, subimg, item.xPos, item.yPos);
    				
    				drawY = item.yPos + buttonH / 2;
    				draw_set_valign(fa_middle);
    				
    				if (item.disabled)
    					draw_set_color($349BE8);
    				else
    					draw_set_color($10489B);
    				draw_set_font(ft_button);
    				draw_text(item.xPos + 21, drawY, item.str);
    			} break;
    			
    			case ITEM_TYPE.HEALTH_BAR:
    			{
    				var stats = item.stats;
    				
    				var drawX = item.xPos;
    				for (var k = 0; k < stats.curHealth; ++k)
    				{
    					draw_sprite(spr_heart, 0, drawX, item.yPos);
    					drawX += sprite_get_width(spr_heart);
    				}
    				for (var k = stats.curHealth; k < stats.maxHealth; ++k)
    				{
    					draw_sprite(spr_heart, 1, drawX, item.yPos);
    					drawX += sprite_get_width(spr_heart);
    				}
    			} break;
    			
    			case ITEM_TYPE.MANA_BAR:
    			{
    				var stats = item.stats;
    				
    				var drawX = item.xPos;
    				for (var k = 0; k < stats.curMana; ++k)
    				{
    					draw_sprite(spr_mana, 0, drawX, item.yPos);
    					drawX += sprite_get_width(spr_mana);
    				}
    				for (var k = stats.curMana; k < stats.maxMana; ++k)
    				{
    					draw_sprite(spr_mana, 1, drawX, item.yPos);
    					drawX += sprite_get_width(spr_mana);
    				}
    			} break;
    			
    			case ITEM_TYPE.TEXT:
    			{
    				draw_set_font(item.font);
    				draw_set_color(item.color);
    				draw_text(item.xPos, item.yPos, item.str);
    				draw_set_color(c_white);
    			} break;
    		}
    	}
    	
    	// Hack to make game not render over other windows
    	if (window == forestWindow)
    	{
    		draw_game(window);
    	}
    }
    
    draw_set_color(c_white);
    draw_set_valign(fa_top);
}

// Draw characters
function draw_player(stats, window)
{
	var sprite = spr_player_idle;
	var xx = floor(stats.xPos);
	var yy = floor(stats.yPos) - sprite_get_height(sprite) + sprite_get_yoffset(sprite);
	if (forestState == FOREST_STATE.APPROACH_ENEMY)
	    sprite = spr_player_walk;
	
	var subimg = globalSpriteFrame % sprite_get_number(sprite);
	
	//if (stats.reacted == true)
	//    subimg = 1;
	
	draw_sprite(sprite, subimg, xx, yy);
}

function draw_enemy(stats, window)
{
	var type = stats.visual;
	var sprite = characterIdleSprites[type];
	var xx = floor(stats.xPos);
	var yy = floor(stats.yPos) - floor(sprite_get_width(sprite) / 2);
	var rot = stats.rot;
	
	var subimg = globalSpriteFrame % sprite_get_number(sprite);
	if (stats.subImg > -1)
	    subimg = stats.subImg;
	
	if (stats.reacted == true)
	{
	    sprite = characterSprites[type];
	}
	
	draw_sprite_ext(sprite, subimg, xx, yy, 1, 1, rot, c_white, 1);
}

// Draw game
function draw_game(window)
{
    var width = (window.w - bodyPadding * 2) / forestZoom;
    var height = (window.h - bodyPadding - windowCaptionBarHeight) / forestZoom;
    
    if (!surface_exists(forestSurface))
        forestSurface = surface_create(width, height);
    if (!surface_exists(fogSurface))
    	fogSurface = surface_create(width, height);
    
    surface_set_target(forestSurface);
    
    draw_clear_alpha(c_black, 0);
    
    var initialPlayerYPos = forestWindowWidth / 2;
    
    var left = 0;
    var top = cameraY;
    
    draw_sprite_part_ext(spr_forest, 0, left, top, width, height, 0, 0, 1, 1, c_white, 1);
    
    // Draw a second to loop
    if (top < 0)
    {
        top += sprite_get_height(spr_forest);
        draw_sprite_part_ext(spr_forest, 0, left, top, width, height, 0, 0, 1, 1, c_white, 1);
    }
    
	draw_player(playerStats, window);
	draw_enemy(enemyStats, window);
	
    var drawX = window.xPos + bodyPadding;
    var drawY = window.yPos + windowCaptionBarHeight;
    
    surface_reset_target();
    
    surface_set_target(fogSurface);
    draw_clear_alpha(c_black, 0);
    
    //gpu_set_blendmode_ext_sepalpha(bm_dest_colour, bm_zero, bm_inv_src_alpha, bm_src_alpha);
    //gpu_set_blendmode_ext(bm_zero, bm_src_colour);
    //gpu_set_blendmode_ext(bm_dest_color, bm_zero);
    //shader_set(shd_multiply_blend);
    draw_sprite_tiled_ext(spr_fog, 0, fogX, fogY, 1, 1, c_white, 1);
    //shader_reset();
    //gpu_set_blendmode(bm_normal);
    //gpu_set_blendmode(bm_normal);
    
    surface_reset_target();
    
    surface_set_target(forestSurface);
    
    //gpu_set_blendmode_ext(bm_zero, bm_src_colour);
    //shader_set(shd_multiply_blend);
    //draw_surface_ext(fogSurface, 0, 0, 1, 1, 0, c_white, 0.1);
    //shader_reset();
    //gpu_set_blendmode(bm_normal);
    
    surface_reset_target();
    draw_surface_ext(forestSurface, drawX, drawY, forestZoom, forestZoom, 0, c_white, 1);
}

function draw_cursor()
{
    draw_sprite(spr_cursor, mouse_check_button(mb_left) ? 1 : 0, mouse_x, mouse_y);
}