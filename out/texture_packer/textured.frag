#version 330 core

in vec2 texture_coordinate;
flat in int packed_texture_index;

uniform sampler2DArray packed_textures;

out vec4 frag_color;

void main() {
    frag_color = texture(packed_textures, vec3(texture_coordinate, packed_texture_index));
}
