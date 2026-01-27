
function to_real(data) {
    // 1. If it's an array, look inside it
    if (is_array(data)) {
        var len = array_length(data);
        var new_array = array_create(len);
        
        for (var i = 0; i < len; i++) {
            // Recursively call the same function for nested arrays
            new_array[i] = to_real(data[i]);
        }
        return new_array;
    }
    
    // 2. If it's a string, convert to real
    if (is_string(data)) {
        // Only convert if it's actually a number string, otherwise return string
        return string_digits(data) == "" && data != "0" ? data : real(data);
    }
    
    // 3. If it's already a number or undefined, just return it
    return data;
}