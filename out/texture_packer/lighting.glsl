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

// function prototypes
// vec4 calc_dir_light(DirLight light, vec3 normal, vec3 view_dir);
// vec4 calc_point_light(PointLight light, vec3 normal, vec3 fragPos, vec3 view_dir);
// vec4 calc_spot_light(SpotLight light, vec3 normal, vec3 fragPos, vec3 view_dir);

// calculates the color when using a directional light.
vec4 calc_dir_light(DirLight light, vec3 normal, vec3 view_dir, vec4 tex_color)
{
    vec3 light_dir = normalize(-light.direction);
    
    // Diffuse shading
    float diff = max(dot(normal, light_dir), 0.0);
    
    // Specular shading
    vec3 reflect_dir = reflect(-light_dir, normal);
    float spec = pow(max(dot(view_dir, reflect_dir), 0.0), 32.0f);
    
    // Sample texture (RGBA) to get color and alpha
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

vec4 calc_point_light(PointLight light, vec3 normal, vec3 fragPos, vec3 view_dir, vec4 tex_color)
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

vec4 calc_spot_light(SpotLight light, vec3 normal, vec3 fragPos, vec3 view_dir, vec4 tex_color)
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
