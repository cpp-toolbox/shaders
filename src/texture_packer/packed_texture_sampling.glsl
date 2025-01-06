in vec2 texture_coordinate;
flat in int packed_texture_index;

uniform sampler2DArray packed_textures;

out vec4 frag_color;

/**
 * @brief Samples from a 2D texture array.
 * 
 * @param texture_array The sampler2DArray containing the packed textures.
 * @param tex_coord The 2D texture coordinates for sampling.
 * @param texture_index The index of the texture in the array.
 * @return vec4 The sampled color from the texture.
 */
vec4 sample_packed_texture(sampler2DArray texture_array, vec2 tex_coord, int texture_index) {
    return texture(texture_array, vec3(tex_coord, texture_index));
}
