#version 330 core

#include "local_to_world_1024_ubo.glsl"
#include "../CWL_uniforms.glsl"
#include "skeletal_animation_100_bones.glsl"
#include "texture_packer_input_passthrough.glsl"
#include "lighting_input_passthrough.glsl"

in vec3 xyz_position;

void main() {
    texture_packer_passthrough(passthrough_texture_coordinate, passthrough_packed_texture_index, texture_coordinate, packed_texture_index);

    mat4 animation_transform = compute_animation_transform(passthrough_bone_ids, passthrough_bone_weights);
    vec4 animated_position = animation_transform * vec4(xyz_position, 1.0);

    vec3 wsp = vec3(local_to_world_matrices[local_to_world_index] * animated_position);
    normal_and_world_space_position_passthrough(passthrough_normal, wsp, normal, world_space_position);

    gl_Position = camera_to_clip * world_to_camera * local_to_world_matrices[local_to_world_index] * animated_position;

}
