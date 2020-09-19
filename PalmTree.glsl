uniform vec3      iResolution;           // viewport resolution (in pixels)
uniform float     iTime;                 // shader playback time (in seconds)

void mainImage( out vec4 fragColor, in vec2 fragCoord)
{
    // Normalized pixel coordinates (from 0 to 1)
    vec2 uv = fragCoord/iResolution.xy;

    // Default background color
    vec4 color = vec4(0.7, 0.5, 0.0, 0.0); //orange
    
    // Define the center
    vec2 center = vec2(0.3, 0.6);
    
    // Distance of a normalized pixel coordinate from the center
    vec2 gradient = uv - center;
    
    // Default radius for a circle
    float radius = 0.2;
    
    // Number of petals to generate from a circle
    float numPetals = 8.0;
    
    // Radius of circle changed based on the cos function for which angle
    // is defined by number of petals multiplied by angle projected by a pixel to
    // the center of the screen defined above.
    // iTime is used to make the petals rotate, add iTime for clockwise,
    // subtract it to get anti-clockwise rotation
    // Add x component of gradient to bring a little bend at the end of the
    // petals. 15.0 is a magic value.
    float changingRadius = radius * cos(15.0 + numPetals * 
                                        atan(gradient.y, gradient.x) +
                                        20.0 * gradient.x);

    
    // This is what will give us petals position and correct shape.
    // The smootstep function will interpolate a value for pixels within the
    //  two edges and the source value is defined by the length of th gradient.
    float smoothValue = smoothstep(changingRadius, changingRadius+0.001, 
                                   length(gradient));
 	
    // Multiply smoothness with color to get petals
    color *= smoothValue;
    
    float barkRadius = 0.015;
    
    // Absolute value of x gradient times some sine angle of y gradient
    // Subtract both to get the reverse shape.
    float barkCurve = abs(gradient.x - 0.2 * sin(3.0 * gradient.y));
    
    // Let's get the bark. Need to subtract 1 from smootstep o/p to get the 
    // complement value for pixels.
    float smoothValueY = 1.0 - ((1.0 - smoothstep(barkRadius, barkRadius+0.0001, 
                                                  barkCurve)) *
                                ((1.0 - smoothstep(0.0, 0.0001, (gradient.y)))));

    color *= smoothValueY;
    
    // Time varying pixels, dont do this to have static color background 
    color *= 0.5 + 0.5*sin(iTime+uv.xyxx);
    
    // Output to screen
    fragColor = color;
}