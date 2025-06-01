#version 330

in vec3 xyz_position;
in vec3 passthrough_rgb_color;

#include "CWL_uniforms.glsl"

out vec3 rgb_color;

void main() {
    rgb_color = passthrough_rgb_color;
    gl_Position = camera_to_clip * world_to_camera * local_to_world * vec4(xyz_position, 1.0);
}
