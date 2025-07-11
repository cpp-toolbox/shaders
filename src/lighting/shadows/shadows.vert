#version 330

in vec3 xyz_position;
in vec3 passthrough_rgb_color;
// in vec3 passthrough_normal;

#include "../../texture_packer/local_to_world_1024_ubo.glsl"

out vec3 world_space_position;
out vec4 light_space_position;
out vec3 world_to_light;
out vec3 rgb_color;
// out vec3 normal;

void main() {
    // world space doesn't use any camera stuff.
    world_space_position = vec3(local_to_world_matrices[local_to_world_index] * vec4(xyz_position, 1.0));
    light_space_position = world_to_light * local_to_world_matrices[local_to_world_index] * vec4(xyz_position, 1.0);
    rgb_color = passthrough_rgb_color;
    // normal = passthrough_normal;
    gl_Position = world_to_light * local_to_world_matrices[local_to_world_index] * vec4(xyz_position, 1.0);
}
