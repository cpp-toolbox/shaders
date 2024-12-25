#version 330 core

in vec2 texture_coordinate;

uniform sampler2D texture_sampler;
uniform float character_width;
uniform float edge_transition_width;
uniform vec3 rgb_color;

out vec4 fragColor;

void main() {
    float distance_from_center_of_char = 1.0 - texture(texture_sampler, texture_coordinate).r;
    float alpha = 1.0 - smoothstep(character_width, character_width + edge_transition_width, distance_from_center_of_char);
    fragColor = vec4(rgb_color, alpha);
}
