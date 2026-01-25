function send_data(_struct) {
    // 1. Ensure the network object exists and has a socket
    if (!instance_exists(ob_server) || ob_server.network_socket < 0) return;

    // 2. Add the sender ID automatically so you don't forget
    _struct.sender = global.player_id;

    // 3. Convert to JSON
    var _json = json_stringify(_struct);
    
    // 4. Create and write to buffer
    var _size = string_byte_length(_json) + 1;
    var _buf = buffer_create(_size, buffer_fixed, 1);
    buffer_write(_buf, buffer_string, _json);
    
    // 5. Send raw data to the server
    network_send_raw(ob_server.network_socket, _buf, buffer_tell(_buf));
    
    // 6. Cleanup
    buffer_delete(_buf);
}