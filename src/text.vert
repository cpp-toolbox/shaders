#version 330 core

in vec2 passthrough_texture_coordinate;
in vec2 xy_position;

out vec2 texture_coordinate;

uniform mat4 camera_to_clip;

void main()
{
    texture_coordinate = passthrough_texture_coordinate;
    gl_Position = camera_to_clip * vec4(xy_position, 0.0, 1.0);
}