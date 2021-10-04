logoYOffsetTimer += delta_time_seconds;

if (keyboard_check_pressed(vk_escape))
	game_end();

update_menu(windowStack);