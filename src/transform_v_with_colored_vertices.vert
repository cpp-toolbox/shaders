#version 330

in vec3 xyz_position;
in vec3 passthrough_rgb_color;

uniform mat4 transform;

out vec3 rgb_color;

void main() {
    rgb_color = passthrough_rgb_color;
    gl_Position = transform * vec4(xyz_position, 1.0);
}
