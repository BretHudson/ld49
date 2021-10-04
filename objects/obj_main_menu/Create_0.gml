initMenus();

mainMenuWindow = createWindow(600, 600, 401, 600, "Main Menu");
creditsWindow = createWindow(1300, 500, 401, 600, "Credits");

playButton = createButton("Play", function() { room_goto(rm_game); });
quitButton = createButton("Quit", game_end);

logoYOffsetTimer = 0;

addItemToWindow(mainMenuWindow, playButton);
addItemToWindow(mainMenuWindow, quitButton);

credits = [
	["Art", "Max Cordeiro"],
	["Code", "Bret Hudson"],
	["Special Thanks", "arcadia"],
	["Sounds", "Kenny"],
	["Music", "HorrorPen"],
];

for (var i = 0; i < array_length(credits); ++i)
{
	addItemToWindow(creditsWindow, createText(credits[i][0], ft_caption, 0.8, 0, $AA9999));
	var padding = (i == array_length(credits) - 1) ? 0 : 12;
	addItemToWindow(creditsWindow, createText(credits[i][1], ft_button, 0.8, padding, $202020));
}

addItemToWindow(creditsWindow, createText("Alexandr Zhelanov", ft_button, 0.8, 12, $202020));