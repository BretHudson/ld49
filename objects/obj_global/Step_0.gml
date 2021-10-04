bgX -= bgSpd;
bgY += bgSpd;

bgSinElapsed += delta_time_seconds / bgSinDuration;
if (bgSinElapsed > pi)
	bgSinElapsed -= pi;

if (audio_is_playing(soundPlaying) == false)
{
    switch (currentlyPlaying)
    {
        case snd_music_1:
        {
            currentlyPlaying = snd_music_2;
        } break;
        
        case snd_music_2:
        {
            currentlyPlaying = snd_music_3;
        } break;
        
        case snd_music_3:
        {
            currentlyPlaying = snd_music_1;
        } break;
    }
    
    soundPlaying = audio_play_sound(currentlyPlaying, 1000, false);
}