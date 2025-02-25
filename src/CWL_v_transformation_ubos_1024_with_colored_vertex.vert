#version 330

in vec3 xyz_position;
in vec3 passthrough_rgb_color;

uniform mat4 camera_to_clip;
uniform mat4 world_to_camera;

#include "texture_packer/local_to_world_1024_ubo.glsl"

out vec3 rgb_color;

void main() {
    rgb_color = passthrough_rgb_color;
    gl_Position = camera_to_clip * world_to_camera * local_to_world_matrices[local_to_world_index] * vec4(xyz_position, 1.0);
}
