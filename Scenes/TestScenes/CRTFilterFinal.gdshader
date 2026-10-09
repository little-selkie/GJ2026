
shader_type canvas_item;

// ============================================================
// SCREEN TEXTURE
// ============================================================

uniform sampler2D screen_tex : hint_screen_texture, repeat_disable, filter_linear_mipmap;


// ============================================================
// CRT SCREEN: CURVATURE AND CORNERS
// ============================================================

group_uniforms CRT_Screen;

uniform float curvature : hint_range(0.0, 0.3) = 0.1;
uniform float corner_radius : hint_range(0.0, 0.3) = 0.06;
uniform vec4 border_color : source_color = vec4(0.0, 0.0, 0.0, 1.0);


// ============================================================
// CRT STATIC SCANLINES
// ============================================================

group_uniforms CRT_Static_Scanlines;

uniform float scanlines : hint_range(0.0, 1.0) = 0.35;
uniform float scanline_size : hint_range(2.0, 8.0) = 3.0;


// ============================================================
// CRT LOOK
// ============================================================

group_uniforms CRT_Look;

uniform float vignette : hint_range(0.0, 1.0) = 0.35;
uniform float brightness : hint_range(0.5, 2.0) = 1.1;

uniform bool rgb_mask = false;
uniform float mask_strength : hint_range(0.0, 1.0) = 0.3;


// ============================================================
// ANIMATED SCANLINES AND NOISE
// Settings from the second shader + additional controls
// ============================================================

group_uniforms Animated_Effects;

uniform float scanlines_1 : hint_range(0.0, 1000.0) = 500.0;
uniform float scanlines_2 : hint_range(0.0, 500.0) = 25.0;
uniform float scan_reduction : hint_range(0.0, 0.5) = 0.1;

uniform float animated_scan_speed_1 : hint_range(0.0, 5.0) = 1.0;
uniform float animated_scan_speed_2 : hint_range(0.0, 5.0) = 0.4;

uniform float noise_strength : hint_range(0.0, 0.25) = 0.04;
uniform float noise_speed : hint_range(0.0, 60.0) = 12.0;


// ============================================================
// SECOND VIGNETTE
// Corrected version of the second shader's vignette
// ============================================================

group_uniforms Radial_Vignette;

uniform float radial_vignette_alpha : hint_range(0.0, 1.0, 0.01) = 0.2;
uniform float radial_vignette_inner_radius : hint_range(0.0, 1.5, 0.01) = 0.0;
uniform float radial_vignette_outer_radius : hint_range(0.01, 1.5, 0.01) = 1.0;


// ============================================================
// RANDOM / HASH FUNCTIONS
// ============================================================

float hash(vec2 p) {
    p = fract(p * vec2(0.1031, 0.1030));
    p += dot(p, p.yx + 33.33);
    return fract((p.x + p.y) * p.x);
}


float random(vec2 p) {
    return fract(
        sin(dot(p, vec2(12.9898, 78.233))) * 43758.5453123
    );
}


// ============================================================
// FRAGMENT
// ============================================================

void fragment() {

    // Preserve the ColorRect's original tint.
    vec4 node_tint = COLOR;

    // Screen dimensions in pixels.
    vec2 screen_px = 1.0 / SCREEN_PIXEL_SIZE;
    float aspect = screen_px.x / screen_px.y;


    // --------------------------------------------------------
    // 1. SCREEN CURVATURE
    // --------------------------------------------------------

    vec2 cc = SCREEN_UV * 2.0 - 1.0;

    vec2 bent = cc + cc * cc.yx * cc.yx * curvature;
    bent *= 1.0 + curvature * 0.25;

    vec2 uv = bent * 0.5 + 0.5;


    // --------------------------------------------------------
    // 2. ROUNDED SCREEN CORNERS
    // --------------------------------------------------------

    vec2 half_size = vec2(aspect, 1.0);
    vec2 p = bent * half_size;

    float rad = corner_radius;

    vec2 q = abs(p) - (half_size - rad);

    float d = length(max(q, 0.0))
        + min(max(q.x, q.y), 0.0)
        - rad;

    float inside = clamp(
        0.5 - d / max(fwidth(d), 1e-5),
        0.0,
        1.0
    );


    // --------------------------------------------------------
    // 3. READ THE ALREADY RENDERED SCREEN
    // --------------------------------------------------------

    vec3 col = textureLod(
        screen_tex,
        clamp(uv, 0.0, 1.0),
        0.0
    ).rgb;


    // --------------------------------------------------------
    // 4. STATIC CRT SCANLINES
    // --------------------------------------------------------

    float line = FRAGCOORD.y / scanline_size;
    float s = 0.5 + 0.5 * cos(line * 6.2832);

    float lum = dot(col, vec3(0.3, 0.59, 0.11));

    col *= mix(
        1.0,
        mix(1.0 - scanlines, 1.0, s),
        1.0 - lum * 0.4
    );


    // --------------------------------------------------------
    // 5. ANIMATED SCANLINES FROM THE SECOND SHADER
    // --------------------------------------------------------

    float animated_scan_1 = sin(
        (SCREEN_UV.y + TIME * animated_scan_speed_1)
        * scanlines_1
    ) * scan_reduction - scan_reduction;

    float animated_scan_2 = sin(
        (SCREEN_UV.y + TIME * animated_scan_speed_2)
        * scanlines_2
    ) * scan_reduction - scan_reduction;

    // Use the scanlines as brightness multipliers.
    // This avoids the excessive brightness caused by multiplying
    // the original second shader's output by 5.

    col *= max(0.0, 1.0 + animated_scan_1);
    col *= max(0.0, 1.0 + animated_scan_2);


    // --------------------------------------------------------
    // 6. OPTIONAL RGB MASK
    // --------------------------------------------------------

    if (rgb_mask) {

        float k = mod(floor(FRAGCOORD.x), 3.0);

        vec3 m = k < 1.0
            ? vec3(1.0, 0.7, 0.7)
            : (k < 2.0
                ? vec3(0.7, 1.0, 0.7)
                : vec3(0.7, 0.7, 1.0));

        col *= mix(
            vec3(1.0),
            m * 1.18,
            mask_strength
        );
    }


    // --------------------------------------------------------
    // 7. FIRST VIGNETTE FROM THE CRT SHADER
    // --------------------------------------------------------

    vec2 v = uv * (1.0 - uv);

    float crt_vignette = pow(
        clamp(v.x * v.y * 16.0, 0.0, 1.0),
        0.3
    );

    col *= mix(
        1.0,
        crt_vignette,
        vignette
    );


    // --------------------------------------------------------
    // 8. RADIAL VIGNETTE FROM THE SECOND SHADER
    // --------------------------------------------------------

    float radial_dist = length(
        (SCREEN_UV - vec2(0.5)) * 2.0
    );

    // Prevent invalid smoothstep edges if outer radius
    // is set below inner radius.

    float radial_outer = max(
        radial_vignette_outer_radius,
        radial_vignette_inner_radius + 0.001
    );

    float radial_factor = smoothstep(
        radial_vignette_inner_radius,
        radial_outer,
        radial_dist
    );

    // Actually darken RGB instead of modifying alpha only.

    col *= 1.0 - radial_factor * radial_vignette_alpha;


    // --------------------------------------------------------
    // 9. BRIGHTNESS
    // --------------------------------------------------------

    col *= brightness;


    // --------------------------------------------------------
    // 10. ANIMATED GRAIN / NOISE
    // --------------------------------------------------------

    vec2 pixel_coord = floor(SCREEN_UV * screen_px);

    vec2 noise_offset = vec2(
        floor(TIME * noise_speed),
        floor(TIME * noise_speed * 0.73)
    );

    float grain = random(pixel_coord + noise_offset);

    // Center the noise around zero, so it doesn't
    // continuously brighten or darken the whole image.

    col += (grain - 0.5) * noise_strength;


    // --------------------------------------------------------
    // 11. SUBTLE DITHER
    // --------------------------------------------------------

    col += (hash(FRAGCOORD.xy) - 0.5) / 255.0;


    // --------------------------------------------------------
    // 12. FINAL SCREEN AND BORDER
    // --------------------------------------------------------

    COLOR = vec4(
        mix(border_color.rgb, col, inside),
        1.0
    );

    COLOR *= node_tint;
}
