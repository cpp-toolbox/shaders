#version 330 core

in vec2 texture_coordinate;
flat in ivec4 bone_ids;
flat in int packed_texture_index;
in vec4 bone_weights;

uniform int id_of_bone_to_visualize;
uniform sampler2DArray packed_textures;

out vec4 frag_color;

void main() {
    bool found = false;

    // 4 is the maximum number of verices a bone can influce right now
    for (int i = 0 ; i < 4 ; i++) {
        if (bone_ids[i] == id_of_bone_to_visualize) {
           if (bone_weights[i] >= 0.7) {
               frag_color = vec4(1.0, 0.0, 0.0, 0.0) * bone_weights[i];
           } else if (bone_weights[i] >= 0.4 && bone_weights[i] <= 0.6) {
               frag_color = vec4(0.0, 1.0, 0.0, 0.0) * bone_weights[i];
           } else if (bone_weights[i] >= 0.1) {
               frag_color = vec4(1.0, 1.0, 0.0, 0.0) * bone_weights[i];
           }

           found = true;
           break;
        }
    }

    if (!found) {
        vec4 sampled = texture(packed_textures, vec3(texture_coordinate, packed_texture_index));
        frag_color = sampled;
    }
}
