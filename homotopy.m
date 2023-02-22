f = @(x) x^2-2;

df_dx = @(x) 2*x;

iter = 1;
delta = 0.0001;
t = 0;
x0 = 3;
old_x = x0;

while true
    disp(num2str(iter))
    
    delta_x = -f(x0)/df_dx(old_x);
    new_x = old_x + delta*delta_x;
    r = f(new_x);
    t = t + delta;
    iter = iter + 1;
    disp(new_x)
    disp(r)
    if t >= 1
        break
    end
    old_x = new_x;

end
disp(new_x)