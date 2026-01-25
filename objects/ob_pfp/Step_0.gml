if (mouse_check_button(mb_left)) {
    if (!surface_exists(pfp_surface)) {
        pfp_surface = surface_create(canvas_size, canvas_size);
    }
    
    // Switch drawing to the surface
    surface_set_target(pfp_surface);
    
    // Draw a line from the previous mouse position to the current 
    // This prevents "gaps" when moving the mouse fast
    draw_set_color(brush_color);
    draw_line_width(mouse_x_previous - x, mouse_y_previous - y, mouse_x - x, mouse_y - y, brush_size);
    
    surface_reset_target(); // ALWAYS reset drawing target back to screen
}

mouse_x_previous = mouse_x;
mouse_y_previous = mouse_y;