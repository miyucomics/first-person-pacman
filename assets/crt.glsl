float warp = 0.75;

vec4 effect(vec4 color, Image tex, vec2 uv, vec2 screen_coords) {
    vec2 dc = abs(0.5 - uv);
    dc *= dc;

    uv.x -= 0.5; uv.x *= 1.0 + (dc.y * (0.3 * warp)); uv.x += 0.5;
    uv.y -= 0.5; uv.y *= 1.0 + (dc.x * (0.4 * warp)); uv.y += 0.5;

    if (uv.y > 1.0 || uv.x < 0.0 || uv.x > 1.0 || uv.y < 0.0)
        return vec4(0.0);
    return Texel(tex, uv);
}
