in int passthrough_packed_texture_index;
in vec2 passthrough_texture_coordinate;

out vec2 texture_coordinate;
// flat means that the rasterizer will not interpolate this
flat out int packed_texture_index;


// call the function like this: 
// texture_packer_passthrough(passthrough_texture_coordinate, passthrough_packed_texture_index, texture_coordinate, packed_texture_index);
void texture_packer_passthrough(in vec2 passthrough_texture_coordinate, in int passthrough_packed_texture_index,
                            out vec2 texture_coordinate, out int packed_texture_index) {
    texture_coordinate = passthrough_texture_coordinate;
    packed_texture_index = passthrough_packed_texture_index;
}
