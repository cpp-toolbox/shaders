#version 330 core

in vec2 texture_coordinate;
uniform sampler2D texture_sampler;

out vec4 fragColor;

void main() {
    fragColor = texture(texture_sampler, texture_coordinate);
    //    gl_FragColor = vec4(1.0f, 0.5f, 0.2f, 1.0f);
}
