LTM: local_to_world is a matrix which translates space to change the origin
if you have an object, and you don't want it to appear at the origin
then you can use the local_to_world matrix to store the 3d translation
EX) your character is holding a gun and you use the players position as
a 4x4 matrix which encodes a 3d translation and use that to draw the gun
relative to the players position. For fixed objects like the map, this is
usually the identity

WTC: world_to_camera transforms space so that the origin is now the camera, that is
to say if the camera was located at (1, 1, 1) and then there is an object at
(2, 1, 1) then after setting the camera's position to be the origin, this point
now becomes (1, 0, 0) relative to the camera.
EX) Your character has a camera attached to them, and they move, you want your
camera view to move as well, thus by updating this matrix you can acheive that

CTC: camera_to_clip is a transformationb ased on the physical properties of our camera
we transform vertices to apply perspective. Shouldn't change in our context unless FOV
is changed.

A regular vertex shader then might do the following:
Given a vertex v in R3, we do CTC WTC LTM v
which is matrix multiplication and moves from inside out.

now opengl looks at the result of this composite transformation, if it lands in clip space
then the vertex will be rendered, otherwise it is outside of view.

After the last transformation is complete, all verices are considered to be in clip space and
will be visible or not based on the above
