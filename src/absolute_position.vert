#version 330 core
in vec3 xyz_position;

#include "aspect_ratio_correction.glsl"
 
void main() {
    gl_Position = vec4(scale_position_by_aspect_ratio(xyz_position, aspect_ratio), 1.0f);
}
