#version 330 core

in vec3 xyz_position;
in vec3 passthrough_rgb_color;

out vec3 rgb_color;

#include "aspect_ratio_correction.glsl"

void main()
{
    rgb_color = passthrough_rgb_color;
    gl_Position = vec4(scale_position_by_aspect_ratio(xyz_position, aspect_ratio), 1.0f);
}
