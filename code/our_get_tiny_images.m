function image_feats = our_get_tiny_images(image_paths, resize, tiny_image_size, warp)
    
    num_images = length(image_paths);
    
    max_rows = 0;
    max_columns = 0;
    
    % Find the maximum row/column sizes across all images
    for i = 1:num_images

        image = imread(image_paths{i});
        
        [rows, columns] = size(image);
        
        max_rows = max(max_rows, rows);
        max_columns = max(max_columns, columns);
    end
    
    % Check if the tiny image size exceeds the maximum dimension
    if tiny_image_size > min(max_rows, max_columns)
        fprintf('Tiny image side length too large, value has been reduced to %d\n', min(max_rows, max_columns));
        tiny_image_size = min(max_rows, max_columns); 
    end
    
    % Initialise the feature matrix
    image_feats = zeros(num_images, tiny_image_size * tiny_image_size);
    
    % Process images
    for i = 1:num_images
        
        image = imread(image_paths{i});
        
        % Convert to grayscale 
        if size(image, 3) == 3
            image = rgb2gray(image);
        end
        
        [rows, columns] = size(image);
        
        % Determine the side length for cropping based on the smallest image dimension
        if rows > columns
            sideLength = columns;
        else
            sideLength = rows;
        end
        
        % If 'warp' is true, skip cropping and resize immediately
        if warp
            processedImage = imresize(image, [tiny_image_size, tiny_image_size]);
        else
            cropWindow = centerCropWindow2d(size(image), [sideLength, sideLength]);
            croppedImage = imcrop(image, cropWindow);
            
            % Apply resize or center 
            if resize
                % Resize 
                processedImage = imresize(croppedImage, [tiny_image_size, tiny_image_size]);
            else
                % Crop about the centroid
                cropWindow = centerCropWindow2d(size(croppedImage), [tiny_image_size, tiny_image_size]);
                processedImage = imcrop(croppedImage, cropWindow);
            end
        end
        
        % Flatten the processed grayscale image into a row vector and return
        image_feats(i, :) = processedImage(:)';
    end
end
