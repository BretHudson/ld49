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
}

// Draw characters
function draw_character(stats)
{
	var window = windows[WINDOWS.FOREST];
	var xx = stats.xPos * forestZoom + window.xPos;
	var yy = stats.yPos * forestZoom + window.yPos;
	var w = stats.w;
	var h = stats.h;
	var color = stats.color;
	var curHealth = stats.visHealth;
	var maxHealth = stats.maxHealth;
	var type = stats.type;
	
	draw_sprite_ext(characterSprites[type], 0, xx, yy, forestZoom, forestZoom, 0, c_white, 1);
	
	var healthH = 20;
	xx -= (maxHealth / 2);
	yy += 8;
	
	draw_set_color(c_red);
	draw_rect(xx - 1, yy - 1, maxHealth + 2, healthH + 2, false);
	
	draw_set_color(c_black);
	draw_rect(xx - 1, yy - 1, maxHealth + 2, healthH + 2, true);
	
	draw_set_color(c_lime);
	draw_rect(xx, yy, curHealth, healthH, false);
	
	draw_set_color(c_white);
}

function draw_game()
{
    var window = windows[WINDOWS.FOREST];
    var drawX = window.xPos + bodyPadding;
    var drawY = window.yPos + windowCaptionBarHeight;
    var drawW = (window.w - bodyPadding * 2) / forestZoom;
    var drawH = (window.h - bodyPadding - windowCaptionBarHeight) / forestZoom;
    draw_sprite_part_ext(spr_forest, 0, 0, 0, drawW, drawH, drawX, drawY, forestZoom, forestZoom, c_white, 1);
    
	draw_character(playerStats);
	draw_character(enemyStats);
}