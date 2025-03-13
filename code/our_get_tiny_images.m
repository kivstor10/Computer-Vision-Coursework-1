function image_feats = our_get_tiny_images(image_paths, resize, tiny_image_size, warp)
    % Number of images
    num_images = length(image_paths);
    
    % Initialize variables to track the maximum dimensions of the images
    max_rows = 0;
    max_columns = 0;
    
    % First pass to find the maximum row/column sizes across all images
    for i = 1:num_images
        % Read the image
        image = imread(image_paths{i});
        
        % Get the size of the current image
        [rows, columns, ~] = size(image);
        
        % Track the maximum row and column sizes
        max_rows = max(max_rows, rows);
        max_columns = max(max_columns, columns);
    end
    
    % Check if the tiny image size exceeds the maximum dimension
    if tiny_image_size > min(max_rows, max_columns)
        fprintf('Tiny image side length too large, value has been reduced to %d\n', min(max_rows, max_columns));
        tiny_image_size = min(max_rows, max_columns);  % Reduce tiny_image_size to the maximum dimension
    end
    
    % Preallocate the feature matrix: N x (tiny_image_size^2)
    image_feats = zeros(num_images, tiny_image_size * tiny_image_size);
    
    % Second pass to process the images
    for i = 1:num_images
        % Read the image
        image = imread(image_paths{i});
        
        % Convert to grayscale (expected by nearest neighbor classifier)
        if size(image, 3) == 3
            image = rgb2gray(image);
        end
        
        % Get the size of the current image
        [rows, columns, ~] = size(image);
        
        % Determine the side length for cropping based on the smallest dimension
        if rows > columns
            sideLength = columns;
        else
            sideLength = rows;
        end
        
        % If 'warp' is true, we skip cropping and resize directly
        if warp
            % Resize the image directly to the desired tiny image size
            processedImage = imresize(image, [tiny_image_size, tiny_image_size]);
        else
            % Create a cropping window based on the smallest dimension
            cropWindow = centerCropWindow2d(size(image), [sideLength, sideLength]);
            croppedImage = imcrop(image, cropWindow); % Crop the image to a square
            
            % Apply resize or center cropping based on the user's choice
            if resize
                % Resize the cropped image to the desired tiny image size
                processedImage = imresize(croppedImage, [tiny_image_size, tiny_image_size]);
            else
                % Center crop again with the specified tiny_image_size
                cropWindow = centerCropWindow2d(size(croppedImage), [tiny_image_size, tiny_image_size]);
                processedImage = imcrop(croppedImage, cropWindow);
            end
        end
        
        % Flatten the processed grayscale image into a row vector and store it
        image_feats(i, :) = processedImage(:)';
    end
end
