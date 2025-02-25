// To correct for the stretching of a unit circle on a screen with a 
// resolution of 1920x1080, we need to account for the difference
// in aspect ratio between the width and height. 
// If the screen width is greater than the height, the circle will appear as an oval stretched horizontally.
// To fix this, we should scale down the x-axis by the ratio of the width to the height. 
// Conversely, if the height is greater than the width, the circle will be stretched vertically, 
// and we need to scale down the y-axis by the ratio of the height to the width. 
// This ensures that the unit circle maintains its circular shape regardless of the screen's resolution.
uniform vec2 aspect_ratio;

vec3 scale_position_by_aspect_ratio(vec3 position, vec2 aspect_ratio) {
    position.x *= aspect_ratio.x;
    position.y *= aspect_ratio.y;
    return position;
}
