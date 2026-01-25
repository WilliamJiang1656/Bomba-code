function scr_resize_browser() {
    var _bw = browser_width;
    var _bh = browser_height;
    
    // Your design resolution
    var _base_w = 1366;
    var _base_h = 768;
    
    var _aspect = _base_w / _base_h;
    var _new_w = 0;
    var _new_h = 0;
    
    // Calculate aspect ratio fit
    if (_bw / _bh > _aspect) {
        _new_h = _bh;
        _new_w = _bh * _aspect;
    } else {
        _new_w = _bw;
        _new_h = _bw / _aspect;
    }
    
    // 1. Resize Window and Drawing Surface
    window_set_size(_new_w, _new_h);
    window_center();
    surface_resize(application_surface, _new_w, _new_h);
    
    // 2. FORCE Viewport Settings
    // If these aren't enabled, the game draws 1:1 and cuts off
    view_enabled = true;
    view_set_visible(0, true);
    
    //// 3. Set the View Port (Where it draws on screen)
    //// We tell it to fill the entire window we just made
    //view_set_wport(0, _new_w);
    //view_set_hport(0, _new_h);

    //// 4. Set the Camera Size (How much of the room it sees)
    //// This is the "100 pixel" fix. It forces the camera to see exactly 1366x768
    //var _cam = view_get_camera(0);
    //camera_set_view_size(_cam, _base_w, _base_h);
    
    //// Optional: Keep the camera centered at (0,0) of your room
    //camera_set_view_pos(_cam, 0, 0);

    // 5. GUI Scaling
    display_set_gui_size(_base_w, _base_h);
}