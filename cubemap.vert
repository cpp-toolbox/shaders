#version 330 core

attribute vec3 position;
uniform mat4 world_to_camera;
uniform mat4 camera_to_clip;
out vec3 texture_coordinate_3D;

void main()
{
    texture_coordinate_3D = position;
    gl_Position = camera_to_clip * world_to_camera * vec4(position, 1.0);
}