import argparse
import math
import os

def generate_circle_offsets(radius: int):
    offsets = []
    for y in range(-radius, radius + 1):
        for x in range(-radius, radius + 1):
            if x * x + y * y <= radius * radius:
                offsets.append((x, y))
    return offsets

def write_glsl_file(offsets, radius, output_path):
    with open(output_path, "w") as f:
        f.write(f"// Auto-generated circle offsets for radius = {radius}\n")
        f.write(f"const int NUM_OFFSETS = {len(offsets)};\n")
        f.write(f"const vec2 circle_offsets[NUM_OFFSETS] = vec2[](\n")
        for i, (x, y) in enumerate(offsets):
            comma = "," if i < len(offsets) - 1 else ""
            f.write(f"    vec2({float(x):.1f}, {float(y):.1f}){comma}\n")
        f.write(");\n")

def main():
    parser = argparse.ArgumentParser(description="Generate GLSL circular pixel offsets.")
    parser.add_argument("radius", type=int, help="Radius of the circular kernel (e.g. 2)")
    parser.add_argument("-o", "--output", help="Optional output file name")
    args = parser.parse_args()

    # Default filename: circle_offsets_radius_2.glsl
    default_filename = f"circle_offsets_radius_{args.radius}.glsl"
    output_filename = args.output if args.output else default_filename

    offsets = generate_circle_offsets(args.radius)
    write_glsl_file(offsets, args.radius, output_filename)
    print(f"Wrote {len(offsets)} offsets to '{output_filename}' for radius {args.radius}")

if __name__ == "__main__":
    main()
