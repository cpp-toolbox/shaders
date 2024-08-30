#version 330 core

in vec2 texture_coordinate;

uniform sampler2D text_texture_unit;
uniform vec3 rgb_color;

void main() {
    vec4 sampled = vec4(1.0, 1.0, 1.0, texture(text_texture_unit, texture_coordinate).r);
    gl_FragColor = vec4(rgb_color, 1.0) * sampled;
}