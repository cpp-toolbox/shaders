#version 330 core

in vec2 texture_coordinate;
// texture packer
flat in int packed_texture_index;
uniform sampler2DArray packed_textures;
//lighting
in vec3 world_space_position; 
in vec3 normal;

uniform sampler2D texture_sampler;
uniform float ambient_light_strength;
uniform vec3 ambient_light_color;

uniform vec3 diffuse_light_position;

out vec4 frag_color;

void main() {

    // ambient light setup
    vec4 sampled_texture = texture(packed_textures, vec3(texture_coordinate, packed_texture_index));
    vec3 ambient_light_multiplier = ambient_light_strength * ambient_light_color;

    // diffuse light setup
    vec3 unit_normal = normalize(normal);
    vec3 unit_vector_from_world_pos_to_light_source = normalize(diffuse_light_position - world_space_position);
    float cos_of_the_angle_between_light_and_normal = dot(unit_normal, unit_vector_from_world_pos_to_light_source);
    float proximity_to_right_angle_reflect = max(cos_of_the_angle_between_light_and_normal, 0.0);
    vec3 diffuse_light_multiplier = proximity_to_right_angle_reflect * ambient_light_color;

    // if we only used the diffuse light, then parts of the object would appear black, adding ambient keeps those places colored.
    vec3 lit_texture = sampled_texture.rgb * (ambient_light_multiplier + diffuse_light_multiplier);

    frag_color = vec4(lit_texture, sampled_texture.a);

}
