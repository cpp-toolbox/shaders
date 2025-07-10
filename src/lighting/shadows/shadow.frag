#version 330 core
out vec4 frag_color;

in vec3 normal;
in vec3 world_space_position;
in vec4 light_space_position;
in vec3 rgb_color; // temporary

uniform sampler2D light_space_depth_map;

uniform vec3 light_position;
// uniform vec3 camera_position;

#include "../../offsets/circle_offsets_radius_3.glsl"

// give a specific location and its depth we compute the shadow for this position by computing the shadow that would be produced nearby this location and averaging it.
float get_shadow_averaged_by_neighbors(sampler2D light_space_depth_map, vec3 projCoords, float depth) {
    float shadow = 0.0;
    vec2 texel_size = 1.0 / textureSize(light_space_depth_map, 0);

    for (int i = 0; i < NUM_OFFSETS; ++i) {
        vec2 offset_uv = projCoords.xy + circle_offsets[i] * texel_size;
        float neighboring_depth = texture(light_space_depth_map, offset_uv).r;
        shadow += depth > neighboring_depth ? 1.0 : 0.0;
    }

    shadow /= float(NUM_OFFSETS);
    return shadow;
}

// the depthmap is at a fixed lower resolution and thus when we sample the texture from multiple different light space positions we will get back the same depth, for places in shadow this isn't really a problem, also for flat surfaces which are perpendicular that's not an issue because they are actually that depth value, but for all other surfaces which are not any of the above we get shadow acne because compared to the constant depth part of the current fragment's light space position will be in front or behind the depth value in the depth map (because the depth map is probably the average of the depth at that place), causing mini shadows everywhere which is bad.
// Given a plane if it is perpendicular to the lights direction then there is no acne, the less perpendicular and more paralell it is ot the lights direction the more acne is produced (A)
// therefore if we were to know the normal of the current fragment we could use that to determine how much acne would be there

float position_is_in_shadow(vec4 light_space_position, vec3 fragment_to_light_dir, vec3 normal) {

    // perform perspective divide
    vec3 projCoords = light_space_position.xyz / light_space_position.w;

    // keep the shadow at 0.0 when outside the far_plane region of the light's frustum, if we allow values greater than 1, since the depth map has values in the range [0, 1] where 1 is the furthest then these positions will be always be shadowed because they are further away then any possible depth value.
    if (projCoords.z > 1.0)
        return 0.0;


    // light can only hit something that is facing the light, everything else must be shadowed
    float facing_light_source_amount = dot(normal, fragment_to_light_dir);

    if (facing_light_source_amount <= 0.0)
        return 1.0; // fully shadowed
    else if (facing_light_source_amount < 0.1)
        return smoothstep(0.1, 0.0, facing_light_source_amount); // fade in shadow


    // transform to [0,1] range
    projCoords = projCoords * 0.5 + 0.5;
    // get closest depth value from light's perspective (using [0,1] range fragPosLight as coords)
    float closestDepth = texture(light_space_depth_map, projCoords.xy).r; 
    // get depth of current fragment from light's perspective
    float currentDepth = projCoords.z;

    // dot product is 0 at 90 degrees, aka when shadow acne is worst (A)
    // thus 1 minus maximizes this value when acne is bad and minimizes it to 0 
    // when there is none, for angles greater than 90, then this is already in shadow
    // and there will be no acne so we don't care about it's value in that case.
    float shadow_acne_badness = 1.0 - facing_light_source_amount;

    float bias = 0.05 * shadow_acne_badness;
    float min_bias = 0.005;
    bias = max(bias, min_bias);

    // by bringing the current depth closer it brings the shadowed acne out of the shadow
    float bias_depth = currentDepth - bias;

    // check whether current frag pos is in shadow


    float shadow = get_shadow_averaged_by_neighbors(light_space_depth_map, projCoords, bias_depth);
    // float shadow = bias_depth > closestDepth  ? 1.0 : 0.0;

    return shadow;
}  

void main() {           
    vec3 light_color = vec3(1.0);
    vec3 ambient = 0.15 * light_color;
    vec3 fragment_to_light_dir = normalize(light_position - world_space_position);
    float shadow = position_is_in_shadow(light_space_position, fragment_to_light_dir , normal);
    // vec3 lighting = (ambient + (1.0 - shadow) * (diffuse + specular)) * color;
    vec3 lighting = (ambient + (1.0 - shadow)) * rgb_color;
    frag_color = vec4(lighting, 1.0);
}
