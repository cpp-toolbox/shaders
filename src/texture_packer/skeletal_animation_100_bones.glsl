in ivec4 passthrough_bone_ids;
in vec4 passthrough_bone_weights;

// if a model contains more, then those bones will not be used.
const int MAX_BONES_TO_USE = 100;
uniform mat4 bone_animation_transforms[MAX_BONES_TO_USE];

/**
 * @brief Computes the animation transform by blending the bone animation transforms
 *        based on the bone weights.
 *
 * @param bone_ids The IDs of the bones influencing the vertex.
 * @param bone_weights The weights of the bones influencing the vertex.
 * @return The computed animation transform matrix.
 */
mat4 compute_animation_transform(ivec4 bone_ids, vec4 bone_weights) {

    float total_weight = bone_weights.x + bone_weights.y + bone_weights.z + bone_weights.w;
    if (total_weight == 0.0) {
        // if all weights are zero, then the below computation would return a zero matrix
        // this causes a problem for vertices that are not affected by any bones 
        // such as non-animated objects in the scene, for them we need them to not have
        // any change, so we return the multiplicative identity
        return mat4(1.0); 
    }

    mat4 animation_transform = mat4(0.0);

    // Accumulate weighted bone animation transforms
    animation_transform += bone_animation_transforms[bone_ids[0]] * bone_weights[0];
    animation_transform += bone_animation_transforms[bone_ids[1]] * bone_weights[1];
    animation_transform += bone_animation_transforms[bone_ids[2]] * bone_weights[2];
    animation_transform += bone_animation_transforms[bone_ids[3]] * bone_weights[3];

    // don't need to to this because bone wegihts add up to 1
    // animation_transform *= 0.25f;  

    return animation_transform;
}
