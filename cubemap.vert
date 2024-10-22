#version 330 core

in vec3 xyz_position;
uniform mat4 world_to_camera;
uniform mat4 camera_to_clip;
out vec3 texture_coordinate_3D;

void main()
{
    texture_coordinate_3D = xyz_position;
    gl_Position = camera_to_clip * world_to_camera * vec4(xyz_position, 1.0);
}
