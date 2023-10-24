%% Task 14 script
clc
load('mh370.mat', 'xgt', 'vgt', 'tref', 'a', 'r', 'u', 'v', 'rr');

%% Problem formulation

%still in progress - a ser feito por Alex


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