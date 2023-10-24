load('Task10/cost_values.mat');

% Create a scatter plot
scatter(static_cost_v, dynamic_cost_v, 'o', 'filled', 'b');
hold on;  % Keep the current plot while adding lines

% Add lines connecting the data points
plot(static_cost_v, dynamic_cost_v, 'b-');

% Customize the plot (optional)
title('Static Cost vs Dynamic Cost');
xlabel('Static Cost (RE)');
ylabel('Dynamic Cost (VE)');
xlim([0 200]);
ylim([0 8]);
grid on;

hold off;  % Release the hold on the current plot
