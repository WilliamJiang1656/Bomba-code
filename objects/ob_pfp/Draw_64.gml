// 1. Make sure the surface exists before drawing it
if (surface_exists(pfp_surface)) {
    // Draw the surface at the object's x/y position
    draw_surface(pfp_surface, x, y);
}

// 2. Draw a border so you can see where the canvas is
draw_set_color(c_white);
draw_rectangle(x, y, x + canvas_size, y + canvas_size, true);