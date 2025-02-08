#version 330

in uint passthrough_object_id;
in vec3 xyz_position;

uniform mat4 camera_to_clip;
uniform mat4 world_to_camera;

#include "texture_packer/local_to_world_1024_ubo.glsl"

flat out uint object_id;

void main() {
    object_id = passthrough_object_id;
    gl_Position = camera_to_clip * world_to_camera * local_to_world_matrices[local_to_world_index] * vec4(xyz_position, 1.0);
}
