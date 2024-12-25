#version 330 core

in vec2 texture_coordinate;
uniform sampler2D texture_sampler;

out vec4 fragColor;

void main() {
    fragColor = texture(texture_sampler, texture_coordinate);
}
