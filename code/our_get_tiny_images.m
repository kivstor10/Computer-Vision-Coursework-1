function [] = our_get_tiny_images(image_path, resize, resizeSideLength)
    % Read the image
    image = imread(image_path);
    fprintf("Image loaded, resizing image...\n");
    
    % Get the size of the image
    [rows, columns, ~] = size(image);

    % Determine the side length for cropping
    if rows > columns
        sideLength = columns;
    else
        sideLength = rows;
    end
    
    % Create a cropping window
    cropWindow = centerCropWindow2d(size(image), [sideLength, sideLength]);
    
    % Apply the cropping window to the image
    croppedImage = imcrop(image, cropWindow);

    % Check if the image is to be resized or cropped in the center
    if resize == true
        fprintf("Resizing the cropped image to %d x %d pixels...\n", resizeSideLength, resizeSideLength);
        % Resize the image to the given cropSideLength
        resizedImage = imresize(croppedImage, [resizeSideLength, resizeSideLength]);
    else
        fprintf("Cropping to a square of side length %d about the centerpoint...\n", resizeSideLength);
        % Center crop again with the specified cropSideLength
        cropWindow = centerCropWindow2d(size(croppedImage), [resizeSideLength, resizeSideLength]);
        resizedImage = imcrop(croppedImage, cropWindow);
    end
    
    % Display the original and the processed (resized or cropped) images
    subplot(1,2,1)
    imshow(image)
    title('Original Image')
    
    subplot(1,2,2)
    imshow(resizedImage)
    title('Processed Image')  
end
