function easeInOutSine(t)
{
    return -(cos(pi * t) - 1) / 2;
}

function easeInOutQuart(t)
{
    return t < 0.5 ? 8 * t * t * t * t : 1 - power(-2 * t + 2, 4) / 2;
}