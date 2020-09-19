uniform vec3      iResolution;           // viewport resolution (in pixels)
uniform float     iTime;                 // shader playback time (in seconds)

void mainImage( out vec4 fragColor, in vec2 fragCoord)
{
    // Normalized pixel coordinates (from 0 to 1)
    vec2 uv = fragCoord/iResolution.xy;

    // Default background color
    vec4 color = vec4(1.0, 0.5, 0.0, 0.0); //orange
    
    // Define the center
    vec2 center = vec2(0.5, 0.5);
    
    // Distance of a normalized pixel coordinate from the center
    vec2 gradient = uv - center;
    
    // Default radius for a circle
    float radius = 0.2;
    
    // Number of petals to generate from a circle
    float numPetals = 1.0;
    
    // Radius of circle changed based on the cos function for which angle
    // is defined by number of petals multiplied by angle projected by a pixel to
    // the center of the screen defined above
    // iTime is used to make the petals rotate, add iTime for clockwise,
    // subtract it to get anti-clockwise rotation
    float changingRadius = radius * cos(iTime + numPetals * atan(gradient.y, gradient.x));

    // A constant value of smooth function will never give us a circle
    // float changingSmoothValue = 1.0;
    
    // This is what will give us a black circle around the center of the screen
    // The smootstep function will interpolate a value for pixels within the two edges
    // and the source value is defined by the length of th gradient.
    float smoothValue = smoothstep(changingRadius, changingRadius+0.001, length(gradient));


    // Multiply smoothness with color
    color *= smoothValue;
    
    // Time varying pixels, dont do this to have static color background 
    color *= 1.0 + 0.5*sin(iTime+uv.xyxx);
    
    // Output to screen
    fragColor = color;
}