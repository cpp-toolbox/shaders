#version 330 core

in vec3 xyz_position;
in uint local_to_world_index;
in int passthrough_packed_texture_index;
in vec2 passthrough_texture_coordinate;
in vec3 passthrough_normal;

uniform mat4 local_to_world;
uniform mat4 world_to_camera;
uniform mat4 camera_to_clip;

out vec3 normal;
out vec2 texture_coordinate;
flat out int packed_texture_index;

layout(std140) uniform LtwMatrices {
    mat4 local_to_world_matrices[1024];
};

// for diffuse lighting, as we need to know where the position is relative to the game world 
// or else lighting would be applied as if the object was centered at he origin.
out vec3 world_space_position; 

void main() {
    // passthrough
    texture_coordinate = passthrough_texture_coordinate;
    packed_texture_index = passthrough_packed_texture_index;
    normal = passthrough_normal;

    // CWL v
    gl_Position = camera_to_clip * world_to_camera * local_to_world_matrices[local_to_world_index] * vec4(xyz_position, 1.0);
    world_space_position = vec3(local_to_world_matrices[local_to_world_index] * vec4(xyz_position, 1.0));
}
