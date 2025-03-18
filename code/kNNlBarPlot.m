%% Function to generate bar plot from recorded accuracy readings across various tiny image configurations

category_sizes = [25, 50, 100]; % Number of training images per category
image_sizes = {'8x8', '10x10', '16x16'}; % Tiny image resolutions
k_values = [1, 5, 10]; % k values tested

% Accuracy data for each combination of category size, image size, and k value
accuracy_data = [
    % 25 images per category
    26.7, 28.0, 30.7; % 8x8
    26.7, 26.7, 30.7; % 10x10
    25.6, 24.5, 28.5; % 16x16
    
    % 50 images per category
    31.7, 29.2, 30.9; % 8x8
    31.3, 28.9, 30.1; % 10x10
    28.8, 27.9, 29.6; % 16x16
    
    % 100 images per category
    32.6, 33.3, 33.1; % 8x8
    32.6, 32.6, 32.3; % 10x10
    31.0, 30.7, 29.7; % 16x16
];

% Reshape the accuracy data into a 3D matrix (category_size x image_size x k_value)
accuracy_data = reshape(accuracy_data, [3, 3, 3]);

% Create grouped bar plots for each category size
figure;
for i = 1:length(category_sizes)
    subplot(1, 3, i); % Create a subplot for each category size
    
    % Get accuracy data for the current category size
    data = squeeze(accuracy_data(i, :, :));
    
    % Create grouped bar plot
    bar(data, 'grouped');
    
    title(['Category Size: ' num2str(category_sizes(i))]);
    xlabel('Image Size');
    ylabel('Accuracy (%)');
    xticklabels(image_sizes);
    legend('k=1', 'k=5', 'k=10', 'Location', 'best');
    grid on;
    
    % Set y-axis limits to start at 20
    ylim([24, max(data(:)) + 0.5]); 
end