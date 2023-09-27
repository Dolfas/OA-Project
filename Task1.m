cat%% This is the solution for task 1
x = linspace(-6,6);
plot(x,(abs(x-2)-1).^2);
title('Cost Function: $(|x-2|-1)^2$', 'Interpreter','latex')
xlabel('x','Interpreter','latex');
ylabel('Cost Function value', 'Interpreter','latex') ;
xline(0, 'Color', 'k', 'LineWidth', 0.5);
yline(0, 'Color', 'k', 'LineWidth', 0.5);
%nova branch
%Hello my dear friends! 
%HELLO REDOLFO
%% Comments
% The cost function $(|x-2|-1)^2$, has two local minimums, one positioned at $x = 1$ and the other positioned at $x = 3$.
% 
% This is due to the fact that, for range $r=1$, the target must be positioned at $a\pm r =  a \pm 1 $.
% Therefore, if $ a = 2 $, then in order to minimize the value of the cost function for a given $x$, the target must be positioned at either $x = 1$ or $x = 3$. (Perguntar se é preciso demonstrar que os minimos serão aqui com derivadas)
% 
% Between the values $x = 1$ and $x = 3$ there is a spike at $x = 2$. This is due to the increasing proximity of the target to the anchor (when we are between these two local minimums) while the measured range is still the same. In mathematical terms we have, $|x-2| \rightarrow 0$ while $ r = 1$.
% 
% Finally, the further away the target is from these two local minimums, (i.e $x \rightarrow -\inf$ or $x \rightarrow +\inf$  ), the more the value of the cost function increases. 
%agora o alex já sabe programar e linux e cenas
