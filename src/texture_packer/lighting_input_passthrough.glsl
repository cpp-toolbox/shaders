// note that in the future if we do scalings then we need to correct this normal, since we havent yet done this it's working so far
in vec3 passthrough_normal;
out vec3 normal;
// for diffuse lighting, as we need to know where the position is relative to the game world 
// or else lighting would be applied as if the object was centered at he origin.
out vec3 world_space_position; 

void normal_and_world_space_position_passthrough(in vec3 passthrough_normal, vec3 wsp, 
                                     out vec3 normal, out vec3 world_space_position) {
    normal = passthrough_normal;
    world_space_position = wsp;
}
