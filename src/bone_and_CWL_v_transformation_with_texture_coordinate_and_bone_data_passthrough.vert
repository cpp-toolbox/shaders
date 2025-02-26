#version 330 core

in vec3 xyz_position;
in vec2 passthrough_texture_coordinate;
in ivec4 passthrough_bone_ids;
in vec4 passthrough_bone_weights;

uniform mat4 local_to_world;
uniform mat4 world_to_camera;
uniform mat4 camera_to_clip;

out vec2 texture_coordinate;
// flat means that the rasterizer will not interpolate this
flat out ivec4 bone_ids;
out vec4 bone_weights;

// if a model contains more, then those bones will not be used.
const int MAX_BONES_TO_USE = 100;
uniform mat4 bone_animation_transforms[MAX_BONES_TO_USE];


void main() {
    texture_coordinate = passthrough_texture_coordinate;
    bone_ids = passthrough_bone_ids;
    bone_weights = passthrough_bone_weights;

    // only doing 4 here because we set that as the max number of bones that could influence a single vertex.
    mat4 weighted_averge_bone_animation_transform = bone_animation_transforms[bone_ids[0]] * bone_weights[0];
    weighted_averge_bone_animation_transform     += bone_animation_transforms[bone_ids[1]] * bone_weights[1];
    weighted_averge_bone_animation_transform     += bone_animation_transforms[bone_ids[2]] * bone_weights[2];
    weighted_averge_bone_animation_transform     += bone_animation_transforms[bone_ids[3]] * bone_weights[3];

    weighted_averge_bone_animation_transform = weighted_averge_bone_animation_transform   * 0.25f;  

    mat4 animation_transform = weighted_averge_bone_animation_transform;
    vec4 animated_position = animation_transform * vec4(xyz_position, 1.0);

    // CWL v
    gl_Position = camera_to_clip * world_to_camera * local_to_world * animated_position;
}
