#version 330 core
in vec3 xyz_position;
in uint local_to_world_index;
in int passthrough_packed_texture_index;
in vec2 passthrough_texture_coordinate;

uniform mat4 world_to_camera;
uniform mat4 camera_to_clip;

flat out int packed_texture_index;
out vec2 texture_coordinate;

layout(std140) uniform LtwMatrices {
    mat4 local_to_world_matrices[1024];
};

void main() {
    texture_packer_passthrough(passthrough_texture_coordinate, passthrough_packed_texture_index, texture_coordinate, packed_texture_index);

    gl_Position = camera_to_clip * world_to_camera * local_to_world_matrices[local_to_world_index] * vec4(xyz_position, 1.0);
}
