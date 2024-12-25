#version 330 core

in vec3 xyz_position;
in vec2 passthrough_texture_coordinate;
in ivec4 passthrough_bone_ids;
in vec4 passthrough_bone_weights;
in int passthrough_packed_texture_index;

uniform mat4 local_to_world;
uniform mat4 world_to_camera;
uniform mat4 camera_to_clip;

out vec2 texture_coordinate;
// flat means that the rasterizer will not interpolate this
flat out ivec4 bone_ids;
out vec4 bone_weights;
flat out int packed_texture_index;

// if a model contains more, then those bones will not be used.
const int MAX_BONES_TO_USE = 100;
uniform mat4 bone_animation_transforms[MAX_BONES_TO_USE];

void main() {
    texture_coordinate = passthrough_texture_coordinate;
    bone_ids = passthrough_bone_ids;
    bone_weights = passthrough_bone_weights;
    packed_texture_index = passthrough_packed_texture_index;

    vec4 animated_position;

    if (bone_weights.x + bone_weights.y + bone_weights.z + bone_weights.w == 0.0) {
        animated_position = vec4(xyz_position, 1.0);
    } else {
        // Apply weighted average bone animation transform
        mat4 weighted_average_bone_animation_transform = bone_animation_transforms[bone_ids[0]] * bone_weights[0];
        weighted_average_bone_animation_transform     += bone_animation_transforms[bone_ids[1]] * bone_weights[1];
        weighted_average_bone_animation_transform     += bone_animation_transforms[bone_ids[2]] * bone_weights[2];
        weighted_average_bone_animation_transform     += bone_animation_transforms[bone_ids[3]] * bone_weights[3];

        weighted_average_bone_animation_transform = weighted_average_bone_animation_transform * 0.25f;  

        animated_position = weighted_average_bone_animation_transform * vec4(xyz_position, 1.0);
    }

    // Calculate final position in clip space
    gl_Position = camera_to_clip * world_to_camera * local_to_world * animated_position;
}
