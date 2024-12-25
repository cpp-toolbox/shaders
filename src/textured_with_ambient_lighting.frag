#version 330 core

in vec2 texture_coordinate;

uniform sampler2D texture_sampler;
uniform float ambient_light_strength;
uniform vec3 ambient_light_color;

out vec4 frag_color;

void main() {

    vec4 sampled_texture = texture(texture_sampler, texture_coordinate);

    vec3 ambient_light_multiplier = ambient_light_strength * ambient_light_color;

    vec3 ambient_lit_texture = sampled_texture.rgb * ambient_light_multiplier;

    frag_color = vec4(ambient_lit_texture, sampled_texture.a);

}
