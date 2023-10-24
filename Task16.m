%% Task 16 script
clear
load('measurements.mat', 'xgt', 'vgt', 'tref', 'a', 'r', 'u', 'v', 'rr');
%% Problem formulation
% Set initial values for v and x0
initial_v = ([3,3])';
x0=(xgt(1,:))';
options = optimoptions(@lsqnonlin,'Algorithm','levenberg-marquardt',...
    'MaxFunctionEvaluations',1500, 'FunctionTolerance', 1e-8, 'OutputFcn', @record_values);  % Create an options structure for the optimizer
% Perform optimization using Levenberg-Marquardt
func=@(v)cost_function(v, a, x0, tref, r, rr)
[sol,fval] = lsqnonlin(func, initial_v, [], [], options)
%cost_function_hist, gradientNorm_hist and velocity_hist save their
%respetctive optimization parameter for each iteration
scatter3(v(1,1),v(1,2),0,'r','filled')
legend('\textbf{Velocity vector along iterations $v_k$}','\textbf{True $v$}' ,'Interpreter','latex')
hold off
%% Functions to support optimization
function F = cost_function(v, a, x0 ,tref, r, rr)
    delta=tref(2) - tref(1);
    F=0;
    derivative_term=0;
    for i = 1:length(tref) 
        if i == 1
            derivative_term = ( norm(x0+v*tref(i+1)-a') - norm(x0+v*tref(i)-a') )/(delta);
        elseif i == length(tref) 
            derivative_term = ( norm(x0+v*tref(i)-a') - norm(x0+v*tref(i-1)-a') )/(delta);
        else
            derivative_term = ( norm(x0+v*tref(i+1)-a') - norm(x0+v*tref(i-1)-a') )/(2*delta);
        end
    F = F + (norm(x0+v*tref(i)-a') - r(i)).^2 + norm(v)*((derivative_term - rr(i)).^2);
    end
end
function stop = record_values(v,optimValues,state)
    persistent gradientNorm_history costFun_history velocity_history
    stop = false; % Continue optimization
    switch state
         case 'init'
             %values to store optimization parameters over all iteration
             gradientNorm_history=[];
             costFun_history=[];
             velocity_history=[];
         case 'iter'
            costFun_history = [costFun_history; optimValues.residual]; % Append cost value to the cost function history array
            gradientNorm_history = [gradientNorm_history; norm(optimValues.gradient)]; % Calculate and append gradient norm to the gradientNorm history array
            velocity_history = [velocity_history, v];% Append velocity to it's history array
        case 'done'
            assignin('base','cost_function_hist',costFun_history);
            assignin('base','gradientNorm_hist',gradientNorm_history);
            assignin('base','velocity_hist',velocity_history);
            plot_output(costFun_history, gradientNorm_history, velocity_history)
        otherwise
    end
end
function plot_output(costFun, gradientNorm, velocity,v)
    figure      

    subplot(2,1,1)
    title('\textbf{Optimaztion parameters - Levenberg-Marquard method}', 'Interpreter','latex')
    yyaxis left
    plot(gradientNorm)
    ylabel("\textbf{Norm of the cost function's gradient}", 'Interpreter','latex')
    %ylim([0 100])
    yyaxis right
    plot(costFun)
    ylabel("\textbf{Cost function}", 'Interpreter','latex')
    legend("\textbf{Norm of the cost function's gradient $\| \nabla f(v_k) \|$}",'\textbf{Cost function: $\sum_{t \in T} (\hat{r}(t) - r_t)^2 + \nu(\hat{s}(t) - s_t)^2$}', 'Interpreter','latex')
    xlabel('\textbf{Iterations}', 'Interpreter','latex')
    %ylim([0 100])
    subplot(2,1,2)
    plot(velocity(1,:),velocity(2,:), 'b-o')
    hold on
    title('\textbf{Velocity}', 'Interpreter','latex')
    xlabel('\textbf{x Velocity (m/s)}', 'Interpreter','latex')
    ylabel('\textbf{y Velocity (m/s)}', 'Interpreter','latex')
   end