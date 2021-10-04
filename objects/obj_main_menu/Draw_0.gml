var logoYOffset = 20;

draw_sprite(spr_logo, 0, room_width / 2, 300 + sin(logoYOffsetTimer) * logoYOffset);

draw_windows(windowStack);
draw_cursor();
