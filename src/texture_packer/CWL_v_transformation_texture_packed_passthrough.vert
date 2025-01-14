#version 330 core
in vec3 xyz_position;

uniform mat4 local_to_world;
uniform mat4 world_to_camera;
uniform mat4 camera_to_clip;

#include "texture_packer_input_passthrough.glsl"

void main() {
    texture_packer_passthrough(passthrough_texture_coordinate, passthrough_packed_texture_index, passthrough_packed_texture_bounding_box_index, texture_coordinate, packed_texture_index, packed_texture_bounding_box_index);

    gl_Position = camera_to_clip * world_to_camera * local_to_world * vec4(xyz_position, 1.0);
}
