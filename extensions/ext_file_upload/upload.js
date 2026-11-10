function html_upload_profile_picture() {
    var existingInput = document.getElementById('gm_file_input');
    if (existingInput) {
        existingInput.remove();
    }

    var input = document.createElement('input');
    input.type = 'file';
    input.id = 'gm_file_input';
    input.accept = 'image/png, image/jpeg, image/jpg';
    input.style.display = 'none';

    input.addEventListener('change', function(event) {
        var file = event.target.files[0];
        if (file) {
            var reader = new FileReader();
            reader.onload = function(e) {
                // Save the base64 string to a custom window variable
                window.pending_pfp_data = e.target.result;
                console.log("JS: Base64 data saved to window.pending_pfp_data");
            };
            reader.readAsDataURL(file);
        }
    });

    document.body.appendChild(input);
    input.click();
}

function html_get_pending_pfp() {
    if (window.pending_pfp_data) {
        var data = window.pending_pfp_data;
        window.pending_pfp_data = null; // Clear it so it only reads once
        return data;
    }
    return "";
}