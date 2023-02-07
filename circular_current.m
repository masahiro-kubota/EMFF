 

myu = 1.2566*10^(-6); %
pi = 3.1415926536; 


a = 0.015;
I = 1;
split = 100;
d_phi = 2*pi/split;

x = 0;
y = 0;
z = 0;


phi = 0;


%
d_B = cos(phi);


B = [0, 0, 0];
i = 0;
%disp(d_B)
%disp(x)
T = 0;

while i < split
    
    i = i + 1;
    phi = phi + d_phi;
    d_B = ((myu*I*a)/(4*pi))*((x-a*cos(phi))^2+(y-a*sin(phi))^2+z^2)^(-3/2)*[z*cos(phi), z*sin(phi), -x*cos(phi)-y*sin(phi)+a]*d_phi;
    %disp(d_B)
    B = B + d_B;
end

disp(B)
disp(myu*I*a^2/(2*(a^2 + z^2)^(3/2)))

y = fact(5);
disp(y)
function f = fact(n)
    f = prod(1:n);
end


