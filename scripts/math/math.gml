function point_overlap(px, py, xx, yy, w, h)
{
    var x1 = xx;
    var y1 = yy;
    var x2 = x1 + w - 1;
    var y2 = y1 + h - 1;
    return point_in_rectangle(px, py, x1, y1, x2, y2);
}