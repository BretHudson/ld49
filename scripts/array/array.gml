function array_push(arr, val)
{
    arr[@array_length(arr)] = val;
}

function array_get_first_index(arr, val)
{
    for (var i = 0; i < array_length(arr); ++i)
    {
        if (arr[i] == val)
            return i;
    }
    
    return -1;
}

function array_move_to_top(arr, val)
{
    var index = array_get_first_index(arr, val);
    array_delete(arr, index, 1);
    array_push(arr, val);
}