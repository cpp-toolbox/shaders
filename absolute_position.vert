#version 330 core

// This shader draws vertices at an absolute location rather than using a
// local to world coordinate transformation

in vec3 xyz_position;
 
void main()
{
    gl_Position = vec4(xyz_position, 1.0f);
}
