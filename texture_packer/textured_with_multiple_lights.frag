#version 330 core

struct DirLight {
    vec3 direction;
	
    vec3 ambient;
    vec3 diffuse;
    vec3 specular;
};

struct PointLight {
    vec3 position;
    
    float constant;
    float linear;
    float quadratic;
	
    vec3 ambient;
    vec3 diffuse;
    vec3 specular;
};

struct SpotLight {
    vec3 position;
    vec3 direction;
    float cut_off;
    float outer_cut_off;
  
    float constant;
    float linear;
    float quadratic;
  
    vec3 ambient;
    vec3 diffuse;
    vec3 specular;
};

#define NR_POINT_LIGHTS 4

in vec2 texture_coordinate;
// texture packer
flat in int packed_texture_index;
uniform sampler2DArray packed_textures;
//lighting
in vec3 world_space_position; 
in vec3 normal;

uniform vec3 view_pos;
uniform DirLight dir_light;
uniform PointLight point_lights[NR_POINT_LIGHTS];
uniform SpotLight spot_light;

out vec4 frag_color;

// function prototypes
vec4 calc_dir_light(DirLight light, vec3 normal, vec3 view_dir);
vec4 calc_point_light(PointLight light, vec3 normal, vec3 fragPos, vec3 view_dir);
vec4 calc_spot_light(SpotLight light, vec3 normal, vec3 fragPos, vec3 view_dir);

void main() {

    // properties
    vec3 norm = normalize(normal);
    vec3 view_dir = normalize(view_pos - world_space_position);
    
    // == =====================================================
    // Our lighting is set up in 3 phases: directional, point lights and an optional flashlight
    // For each phase, a calculate function is defined that calculates the corresponding color
    // per lamp. In the main() function we take all the calculated colors and sum them up for
    // this fragment's final color.
    // == =====================================================
    // phase 1: directional lighting
    vec4 result = calc_dir_light(dir_light, norm, view_dir);
    // phase 2: point lights
    for(int i = 0; i < NR_POINT_LIGHTS; i++)
        result += calc_point_light(point_lights[i], norm, world_space_position, view_dir);    
    // phase 3: spot light
    result += calc_spot_light(spot_light, norm, world_space_position, view_dir);    
    
    frag_color = result;

}

// calculates the color when using a directional light.
vec4 calc_dir_light(DirLight light, vec3 normal, vec3 view_dir)
{
    vec3 light_dir = normalize(-light.direction);
    
    // Diffuse shading
    float diff = max(dot(normal, light_dir), 0.0);
    
    // Specular shading
    vec3 reflect_dir = reflect(-light_dir, normal);
    float spec = pow(max(dot(view_dir, reflect_dir), 0.0), 32.0f);
    
    // Sample texture (RGBA) to get color and alpha
    vec4 tex_color = texture(packed_textures, vec3(texture_coordinate, packed_texture_index));
    vec3 base_color = tex_color.rgb;
    float alpha = tex_color.a;  // Opacity

    // Combine lighting components
    vec3 ambient = light.ambient * base_color;
    vec3 diffuse = light.diffuse * diff * base_color;
    vec3 specular = light.specular * spec * vec3(0.1, 0.1, 0.1);

    vec3 final_color = ambient + diffuse + specular;

    // Apply opacity to the final color
    return vec4(final_color, alpha);
}

vec4 calc_point_light(PointLight light, vec3 normal, vec3 fragPos, vec3 view_dir)
{
    vec3 light_dir = normalize(light.position - fragPos);
    
    // Diffuse shading
    float diff = max(dot(normal, light_dir), 0.0);
    
    // Specular shading
    vec3 reflect_dir = reflect(-light_dir, normal);
    float spec = pow(max(dot(view_dir, reflect_dir), 0.0), 32.0f);

    // Attenuation
    float distance = length(light.position - fragPos);
    float attenuation = 1.0 / (light.constant + light.linear * distance + light.quadratic * (distance * distance));
    
    // Sample texture (RGBA) to get color and alpha
    vec4 tex_color = texture(packed_textures, vec3(texture_coordinate, packed_texture_index));
    vec3 base_color = tex_color.rgb;
    float alpha = tex_color.a;  // Opacity
    
    // Combine lighting components
    vec3 ambient = light.ambient * base_color;
    vec3 diffuse = light.diffuse * diff * base_color;
    vec3 specular = light.specular * spec * vec3(0.1, 0.1, 0.1);

    // Apply attenuation
    ambient *= attenuation;
    diffuse *= attenuation;
    specular *= attenuation;

    // Final color
    vec3 final_color = ambient + diffuse + specular;

    // Apply opacity to the final color
    return vec4(final_color, alpha);
}

vec4 calc_spot_light(SpotLight light, vec3 normal, vec3 fragPos, vec3 view_dir)
{
    vec3 light_dir = normalize(light.position - fragPos);
    
    // Diffuse shading
    float diff = max(dot(normal, light_dir), 0.0);
    
    // Specular shading
    vec3 reflect_dir = reflect(-light_dir, normal);
    float spec = pow(max(dot(view_dir, reflect_dir), 0.0), 32.0f);

    // Attenuation
    float distance = length(light.position - fragPos);
    float attenuation = 1.0 / (light.constant + light.linear * distance + light.quadratic * (distance * distance));    

    // Spotlight intensity
    float theta = dot(light_dir, normalize(-light.direction)); 
    float epsilon = light.cut_off - light.outer_cut_off;
    float intensity = clamp((theta - light.outer_cut_off) / epsilon, 0.0, 1.0);

    // Sample texture (RGBA) to get color and alpha
    vec4 tex_color = texture(packed_textures, vec3(texture_coordinate, packed_texture_index));
    vec3 base_color = tex_color.rgb;
    float alpha = tex_color.a;  // Opacity
    
    // Combine results
    vec3 ambient = light.ambient * base_color;
    vec3 diffuse = light.diffuse * diff * base_color;
    vec3 specular = light.specular * spec * vec3(0.1, 0.1, 0.1);

    // Apply attenuation and spotlight intensity
    ambient *= attenuation * intensity;
    diffuse *= attenuation * intensity;
    specular *= attenuation * intensity;

    // Final color
    vec3 final_color = ambient + diffuse + specular;

    // Apply opacity to the final color
    return vec4(final_color, alpha);
}
