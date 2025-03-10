function [colourHistogram] = get_colour_histograms(colourImage)
% QUANTISE AND CONVERT COLOUR IMAGE TO HISTOGRAM OF ITS RGB VALUES
%   1. Quantisation of 255 RGB range to 16 range (less memory)
%   2. Histogram with count of how many times the colour with RGB vector [i,j,k] occurs
    disp(colourImage)
    img = double(colourImage);
    imquant = img/255;
    imquant = round(imquant*(16-1)) + 1;
    
    hh = zeros(16, 16, 16);
    
    [dim1, dim2, ~] = size(imquant);
    
    for i = 1:dim1
        for j = 1:dim2
            R = imquant(i,j,1);
            G = imquant(i,j,2);
            B = imquant(i,j,3);
    
            hh(R,G,B) = hh(R,G,B) + 1;
        end
    end

    colourHistogram = hh;
end

