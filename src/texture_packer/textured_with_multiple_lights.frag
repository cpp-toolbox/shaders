#version 330 core

#include "lighting.glsl"
#include "packed_texture_sampling.glsl"

// lighting
#define NR_POINT_LIGHTS 4
in vec3 world_space_position; 
in vec3 normal;

uniform vec3 camera_position;
uniform DirLight dir_light;
uniform PointLight point_lights[NR_POINT_LIGHTS];
uniform SpotLight spot_light;

out vec4 frag_color;
void main() {

    // properties
    vec3 norm = normalize(normal);
    vec3 view_dir = normalize(camera_position - world_space_position);
    
    // == =====================================================
    // Our lighting is set up in 3 phases: directional, point lights and an optional flashlight
    // For each phase, a calculate function is defined that calculates the corresponding color
    // per lamp. In the main() function we take all the calculated colors and sum them up for
    // this fragment's final color.
    // == =====================================================
    // phase 1: directional lighting
    vec4 tex_color = sample_packed_texture(
        packed_textures, 
        texture_coordinate, 
        packed_texture_index, 
        // packed_texture_bounding_boxes, 
        packed_texture_bounding_box_index
    );
    vec4 result = calc_dir_light(dir_light, norm, view_dir, tex_color);
    // phase 2: point lights
    for(int i = 0; i < NR_POINT_LIGHTS; i++)
        result += calc_point_light(point_lights[i], norm, world_space_position, view_dir, tex_color);    
    // phase 3: spot light
    result += calc_spot_light(spot_light, norm, world_space_position, view_dir, tex_color);    
    frag_color = result;
}

