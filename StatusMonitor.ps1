# This to be adapted to work for showing specific images on Stream deck icon hopefully
# Currently unused, WIP

$status= "Words that are in the file "$env:APPDATA\CCAStatus\CurrentStatus.txt""

If ($status = "availability: 1")
{
    $Words="Available"
    $Icon = C:\locationofGeenIcon.jpeg
}
else if ($status = "availability: 2")
{
    $Words="Orange (Workmode)"
    $Icon = C:\locationofOrangeIcon.jpeg
}
else if ($status = "availability: 0")
{
    $Words="Red (Break/wrapup)"
    $Icon = C:\locationofRedIcon.jpeg
}
