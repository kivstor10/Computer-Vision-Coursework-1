function image_feats = our_get_tiny_images(image_paths, resize, tiny_image_size, warp, normalise, use_rgb)
    % Inputs:
    % - image_paths: Cell array of image file paths.
    % - resize: Boolean, whether to resize the image.
    % - tiny_image_size: Desired size of the tiny image (e.g., 16 for 16x16).
    % - warp: Boolean, whether to warp the image (skip cropping).
    % - normalise: Boolean, whether to normalize the feature vectors.
    % - use_rgb: Boolean, whether to use RGB (768-long vector) or grayscale (256-long vector).

    num_images = length(image_paths);

    % Start timing
    tic;
    
    % Determine the feature vector length based on use_rgb
    if use_rgb
        feature_length = tiny_image_size * tiny_image_size * 3; % RGB: 768 for 16x16
    else
        feature_length = tiny_image_size * tiny_image_size; % Grayscale: 256 for 16x16
    end
    
    % Initialize the feature matrix
    image_feats = zeros(num_images, feature_length);
    
    % Process images
    for i = 1:num_images
        image = imread(image_paths{i});
        
        % Convert to grayscale if use_rgb is false
        if ~use_rgb && size(image, 3) == 3
            image = rgb2gray(image);
        end
        
        [rows, columns, ~] = size(image);
        
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
        
        % Flatten the processed image into a feature vector
        if use_rgb
            % For RGB, flatten all three channels into a single vector
            image_feats(i, :) = reshape(processedImage, 1, []);
        else
            % For grayscale, flatten the single channel
            image_feats(i, :) = processedImage(:)';
        end
    end
    
    % Normalize feature vectors if requested
    if normalise
        for i = 1:num_images
            feature_vector = image_feats(i, :);
            feature_vector = (feature_vector - mean(feature_vector)) / std(feature_vector); % Zero mean and unit variance
            image_feats(i, :) = feature_vector;
        end
    end

    % End timing and display results
    elapsed_time = toc;
    fprintf('%d images processed in %.4f seconds (%.4f sec per image)\n', ...
        num_images, elapsed_time, elapsed_time / num_images);
end