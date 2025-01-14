#version 330 core

in vec3 xyz_position;
in vec2 passthrough_texture_coordinate;

uniform mat4 transform;

out vec2 texture_coordinate;

void main() {
    gl_Position = transform * vec4(xyz_position, 1.0);
    texture_coordinate = passthrough_texture_coordinate;
}
