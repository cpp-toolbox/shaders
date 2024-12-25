#version 330 core
in vec3 xyz_position;
in uint local_to_world_index;
uniform mat4 world_to_camera;
uniform mat4 camera_to_clip;

layout(std140) uniform LtwMatrices {
    mat4 local_to_world_matrices[100];
};

void main() {
    gl_Position = camera_to_clip * world_to_camera * local_to_world_matrices[local_to_world_index] * vec4(xyz_position, 1.0);
}
