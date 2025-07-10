#version 330

in vec3 xyz_position;

uniform mat4 world_to_light;

#include "../../texture_packer/local_to_world_1024_ubo.glsl"

void main() {
    gl_Position = world_to_light * local_to_world_matrices[local_to_world_index] * vec4(xyz_position, 1.0);
}
