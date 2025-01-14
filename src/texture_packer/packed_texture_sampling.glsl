in vec2 texture_coordinate;
flat in int packed_texture_index;
flat in int packed_texture_bounding_box_index;

uniform sampler2DArray packed_textures;
#define MAX_NUM_TEXTURES 1024
uniform vec4 packed_texture_bounding_boxes[MAX_NUM_TEXTURES];


/**
 * Wraps a texture coordinate (tc) to stay within the given bounding box.
 *
 * @param tc      The texture coordinate to wrap (vec2).
 * @param bbox    The bounding box as vec4 (top_left_x, top_left_y, width, height).
 * @return        The wrapped texture coordinate (vec2).
 */
vec2 wrap_texture_coordinate(vec2 tc, vec4 bbox) {
    // Extract bounding box components
    float tlx = bbox.x;      // Top-left x
    float tly = bbox.y;      // Top-left y
    float width = bbox.z;    // Width of the bounding box
    float height = bbox.w;   // Height of the bounding box

    // Calculate deltas from the top-left corner
    float dx = tc.x - tlx;
    float dy = tc.y - tly;

    // Wrap the coordinates using modulo and shift back into the bounding box
    float wrapped_x = mod(dx, width) + tlx;
    float wrapped_y = mod(dy, height) + tly;

    // Return the wrapped texture coordinate
    return vec2(wrapped_x, wrapped_y);
}

/**
 * @brief Samples from a 2D texture array.
 * 
 * @param texture_array The sampler2DArray containing the packed textures.
 * @param tex_coord The 2D texture coordinates for sampling.
 * @param texture_index The index of the texture in the array.
 * @param bounding_boxes The array of bounding boxes for the textures.
 * @param bounding_box_index The index of the bounding box for the current texture.
 * @return vec4 The sampled color from the texture.
 */
vec4 sample_packed_texture(
    sampler2DArray texture_array,
    vec2 tex_coord,
    int texture_index,
    vec4 bounding_boxes[MAX_NUM_TEXTURES],
    int bounding_box_index
) {
    vec4 bbox = bounding_boxes[bounding_box_index];
    return texture(texture_array, vec3(wrap_texture_coordinate(tex_coord, bbox), texture_index));
}
