// Godot 4 Shader for Sprite Doodle Effect
// Adapted from concepts by Alan Zucconi (Unity) / Nick Kaman
shader_type canvas_item;

// Uniforms to control the effect from the Inspector
uniform float noise_scale : hint_range(0.0, 10.0, 0.1) = 2.5; // 2.5 How much the vertices move (pixels)
uniform float noise_frequency : hint_range(1.0, 30.0, 1.0) = 4.0; // 4.0 Simulated frames per second for the wiggle
uniform vec4 tint_color : source_color = vec4(1.0); // Optional tint for the sprite

// A simple pseudo-random number generator function (like the one mentioned in the article)
// Takes a 2D vector (like position or UV + time) and returns a pseudo-random float between 0.0 and 1.0
float random(vec2 st) {
    return fract(sin(dot(st.xy, vec2(12.9898, 78.233))) * 43758.5453);
}

// Generates a 2D pseudo-random vector (components between 0.0 and 1.0)
vec2 random2(vec2 st) {
    // Use slightly different inputs for each component to get different random values
    return vec2(random(st), random(st + vec2(43.123, 71.897)));
}

// Vertex shader function: runs for each vertex of the sprite
void vertex() {
    // --- Time Snapping ---
    // Calculate the duration of each "doodle frame" based on the desired frequency
    float frame_duration = 1.0 / noise_frequency;
    // Snap the current time to the start of the current doodle frame
    // floor(TIME / duration) gives the index of the current frame
    // Multiplying by duration gives the time at the start of that frame
    float snapped_time = floor(TIME / frame_duration) * frame_duration;

    // --- Random Displacement ---
    // Create a seed for the random function. Using the original vertex position (VERTEX)
    // ensures each vertex potentially moves differently. Adding snapped_time makes it change over time.
    // Using .xy as sprites are typically 2D.
    vec2 random_seed = VERTEX.xy + snapped_time; // You could also use UV * some_scale + snapped_time

    // Generate a 2D random vector using our seed
    vec2 noise = random2(random_seed);

    // The random numbers are in the 0.0 to 1.0 range.
    // We want displacement centered around zero (e.g., -0.5 to +0.5 range)
    // so subtract 0.5 and multiply by 2.0 (or just subtract 0.5 if noise_scale adjusts enough)
    noise = (noise - 0.5) * 2.0;

    // Scale the noise vector by the noise_scale uniform to control the intensity
    noise *= noise_scale;

    // Apply the calculated displacement to the vertex position
    VERTEX.xy += noise; // VERTEX is the input/output variable for vertex position
}

// Fragment shader function: runs for each pixel of the sprite
void fragment() {
    // Sample the sprite's texture at the calculated UV coordinates
    vec4 tex_color = texture(TEXTURE, UV);

    // Apply the tint color uniform
    tex_color *= tint_color;

    // Set the final pixel color
    COLOR = tex_color;
}