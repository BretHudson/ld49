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