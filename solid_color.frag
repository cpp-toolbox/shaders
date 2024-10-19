#version 330 core

uniform vec4 rgba_color;

out vec4 frag_color;

void main()
{
    frag_color = rgba_color;
}
