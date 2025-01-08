#version 330 core

in vec3 xyz_position;
in vec2 passthrough_texture_coordinate;

out vec2 texture_coordinate;

void main()
{
    texture_coordinate = passthrough_texture_coordinate;
    gl_Position = vec4(xyz_position, 1.0);
}
