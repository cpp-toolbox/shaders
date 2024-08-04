#version 330 core

in vec3 texture_coordinate_3D;
uniform samplerCube skybox_texture_unit;

void main()
{
    gl_FragColor = texture(skybox_texture_unit, texture_coordinate_3D);
}
