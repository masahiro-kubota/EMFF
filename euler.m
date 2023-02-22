f = @(x) x^2-2;

df_dx = @(x) 2*x;

iter = 1;
x0 = 3;
old_x = x0;

while true
    disp(num2str(iter))
    
    delta_x = -f(old_x)/df_dx(old_x);
    new_x = old_x + delta_x;
    r = f(new_x);
    iter = iter + 1;
    disp(new_x)
    disp(r)
    if abs(r) < 10^-5
        break
    end
    old_x = new_x;

end