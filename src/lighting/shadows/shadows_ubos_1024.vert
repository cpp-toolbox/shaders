#version 330

in vec3 xyz_position;
in vec3 passthrough_normal;
in vec3 passthrough_rgb_color;

uniform mat4 world_to_light;
uniform mat4 world_to_camera;
uniform mat4 camera_to_clip;

out vec3 world_space_position;
out vec3 normal;
out vec3 rgb_color;
out vec4 light_space_position;

#include "../../texture_packer/local_to_world_1024_ubo.glsl"

void main() {
    // camera independent positions
    world_space_position = vec3(local_to_world_matrices[local_to_world_index] * vec4(xyz_position, 1.0));
    light_space_position = world_to_light * local_to_world_matrices[local_to_world_index] * vec4(xyz_position, 1.0);

    normal = passthrough_normal;
    rgb_color = passthrough_rgb_color;

    gl_Position = camera_to_clip * world_to_camera * local_to_world_matrices[local_to_world_index] * vec4(xyz_position, 1.0);
}
