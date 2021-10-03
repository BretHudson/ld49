// Draw background
draw_sprite_tiled_ext(bg_pattern, 0, bgX, bgY, 1, 1, c_white, 1);
draw_sprite_tiled_ext(bg_background, 0, 0, sin(bgSinElapsed) * bgSinAmplitude, 1, 1, c_white, 1);

// Draw windows
for (var i = 0; i < WINDOWS.NUM; ++i)
{
	var window = windowStack[i];
	
	draw_set_color(c_dkgray);
	draw_nineslice(spr_window_shadow, window.xPos - 16, window.yPos + 24, window.w, window.h, false);
}

for (var i = 0; i < WINDOWS.NUM; ++i)
{
	var window = windowStack[i];

	draw_set_color(c_white);
	if (window == windows[WINDOWS.FOREST])
		draw_set_color($202020);
	draw_rect(window.xPos + bodyPadding, window.yPos + windowCaptionBarHeight, window.w - bodyPadding * 2, window.h - bodyPadding - windowCaptionBarHeight, false);
	draw_nineslice(spr_window_nineslice, window.xPos, window.yPos, window.w, window.h);
	
	// Draw window caption
	draw_set_color(c_white);
	draw_set_valign(fa_middle);
	draw_set_font(ft_caption);
	
	var drawY = window.yPos + ceil(windowCaptionBarHeight / 2);
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
		}
	}
	
	// Hack to make game not render over other windows
	if (window == windows[WINDOWS.FOREST])
	{
		draw_game();
	}
}

draw_set_color(c_white);
draw_set_valign(fa_top);

draw_sprite(spr_cursor, mouse_check_button(mb_left) ? 1 : 0, mouse_x, mouse_y);
