%% Task 16 script
clear
clc
load('measurements.mat', 'xgt', 'vgt', 'tref', 'a', 'r', 'u', 'v', 'rr');
%% Problem formulation
% Set initial values for vel and x0

x0=(xgt(1,:))';
niu=1;
E=1e-6;
v_true=v(1,:);
k=1; %k is inicialized at 1, because matlab arrays' first index is 1
vel(:,k) = [3;3];
lambda(k)=1;
validation=0;
rejection=0;


while 1 %while true em matlab
    J(:,:,k)= residual_Jacbobian(vel(:,k), a, x0, tref, niu);
    residual(:,k)=residual_func(vel(:,k), a, x0, tref, r, rr, niu);
    fval(k)=cost_function(vel(:,k),a, x0 ,tref, r, rr, niu);
    g(k,:)= (J(:,:,k))'*residual(:,k); %gradient of f(v)
    g_norm(k)=norm(g(k,:));

    if g_norm(k)<E | k>1500 %function converged to local minima - output results
        output_func(fval, g_norm, vel, v_true)
        break
    end
   
    v_hat(:,k)= argmin_function(lambda(k), vel(:,k),residual(:,k),J(:,:,k),g(k,:));
    
    if cost_function(v_hat(:,k),a, x0 ,tref, r, rr, niu)<fval(k)%valid step
        vel(:,k+1)=v_hat(:,k);
        lambda(k+1)=0.7*lambda(k) ;
        validation=validation+1;
    else %null step
        vel(:,k+1)=vel(:,k);
        lambda(k+1)=2*lambda(k);
        rejection=rejection+1;
    end
    k=k+1;
    end

%% Functions to support optimization

function residual = residual_func(v, a, x0, tref, r, rr, niu)
    for i = 1:length(tref)
        aux=x0+v*tref(i)-a';
        rR(i)=norm(aux) - r(i);
        rRR(i)= sqrt(niu)*( (v'*(aux)/(norm(aux))) - rr(i));
    end
    residual=[rR,rRR]';
end


function J= residual_Jacbobian(v, a, x0, tref, niu)
    for i = 1:length(tref)
        %for range
        aux=x0+v*tref(i)-a';
        jR(i,:) = ((aux/norm(aux)) *tref(i))';
        
        %for range rate
        P = v'*aux;
        Q = norm(aux);
        P_grad= v*tref(i) + aux;
        Q_grad=aux/norm(aux);
        jRR(i,:)= (( (P_grad * Q - P*Q_grad)/(Q^2) ) *sqrt(niu))';
    end
J=[jR;jRR];
end

function v_minima= argmin_function(lambda, vel, residual,J,g)
    T=size(J,1)/2;
    %aqui não tamos a transpor a jacobiana e na teoria deviamos
    grad_f1=(J(1:T,:));
    grad_f2=(J(T+1:end,:));
    f1= residual(1:T);
    f2= residual(T+1:end);
    b1=grad_f1*vel - f1;
    b2= grad_f2*vel -f2;
    A=[ grad_f1 ; grad_f2; sqrt(lambda)*eye(2)]; %matrix identidade 2x2 porque multiplica por vel (2x1)
    b=[b1 ;b2; sqrt(lambda)*vel];
    v_minima = lsqlin(A, b);

end

function output_func(cost_fun, gradient, velocity, v_true)
    figure      
    subplot(2,1,1)
    title('\textbf{Optimaztion parameters - Levenberg-Marquard method}', 'Interpreter','latex')
    yyaxis left
    plot(gradient)
    ylabel("\textbf{Norm of the residuals' gradient}", 'Interpreter','latex')
    %ylim([0 100])
    yyaxis right
    plot(cost_fun)
    ylabel("\textbf{Cost function}", 'Interpreter','latex')
    legend("\textbf{Norm of the residual's gradient $\| \nabla f(v_k) \|$}",'\textbf{Cost function: $\sum_{t \in T} (\hat{r}(t) - r_t)^2 + \nu(\hat{s}(t) - s_t)^2$}', 'Interpreter','latex')
    xlabel('\textbf{Iterations}', 'Interpreter','latex')
    %ylim([0 100])
    subplot(2,1,2)
    plot(velocity(1,:),velocity(2,:), 'b-o')
    hold on
    xlabel('\textbf{x Velocity (m/s)}', 'Interpreter','latex')
    ylabel('\textbf{y Velocity (m/s)}', 'Interpreter','latex')
    
    scatter3(v_true(1,1),v_true(1,2),0,'r','filled')
    legend('\textbf{Velocity vector along iterations $v_k$}','\textbf{True $v$}' ,'Interpreter','latex')
    title('Velocity', 'Interpreter','latex');
    hold off
    
   fprintf('Final gradient norm: %e\n', gradient(end))
   fprintf('Final residuals (fval): %e\n', cost_fun(end))
   fprintf('Predicted velocity: [ %f , %f ]', velocity(1,end),velocity(2,end))



end
function F = cost_function(v, a, x0 ,tref, r, rr, niu)
  
residual=residual_func(v, a, x0, tref, r, rr, niu);
F= 0.5*(norm(residual))^2;    

end
