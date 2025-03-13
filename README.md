# Computer-Vision-Coursework-1 (download data zip folder from blackboard)

# our_get_tiny_images

    - resize -> boolean 
        - True -> entire image is resized to tinyImageSize X tinyImageSize
        - False -> Image is not resized but cropped about the centroid to tinyImageSize X tinyImageSize

    - tinyImageSize -> int
        - Variable to dictate the processed image side length (always a square) 
    
    - warp -> boolean
        - True -> Image is not cropped before resizing meaning images with unequal sidelengths are warped so no pixels are cut out and the image is warped (aspect ratio ignored)
        - False -> Image is cropped to a square based about the centroid before resizing/warping