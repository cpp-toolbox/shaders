#version 330 core

in vec3 position;
in vec3 passthrough_normal;
in vec2 passthrough_texture_coordinate;

uniform mat4 local_to_world;
uniform mat4 world_to_camera;
uniform mat4 camera_to_clip;

out vec3 normal;
out vec2 texture_coordinate;

// for diffuse lighting, as we need to know where the position is relative to the game world 
// or else lighting would be applied as if the object was centered at he origin.
out vec3 world_space_position; 

void main() {
    // CWL v
    gl_Position = camera_to_clip * world_to_camera * local_to_world * vec4(position, 1.0);
    world_space_position = vec3(local_to_world * vec4(position, 1.0));
    texture_coordinate = passthrough_texture_coordinate;
    normal = passthrough_normal;
}
