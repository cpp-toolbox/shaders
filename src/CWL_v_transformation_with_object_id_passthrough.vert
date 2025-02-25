#version 330 core

in uint passthrough_object_id;
in vec3 xyz_position;
#include "CWL_uniforms.glsl"

flat out uint object_id;

void main() {
    // CWL v
    gl_Position = camera_to_clip * world_to_camera * local_to_world * vec4(xyz_position, 1.0);
    object_id = passthrough_object_id;
}
