# shaders
this is where we store all the shader files for our projects

## compilation 
Our shaders allow you to use `#include "your_code_file.glsl` and thus you must compile the shaders first by using the command
```
python main.py src out
```

## warning
There is a differentiation between a shader and a shader file. When we say shader, we are referring to a "shader program" which consists of multiple shader files, each of which either contributes to the fragment or shader part of the entire shader program, to learn about which shader programs are available please visit the shader standard.
