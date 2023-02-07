function B = magnetic_flux(x, y, z, I, a, N) 
% Calculate the magnetic field vector created at (x, y, z) by the coil with radius a, number of turns N, and current I at the origin
%   Detailed explanation goes here
myu = 1.2566*10^(-6); %
pi = 3.1415926536; 


%a = 0.015;
%I = 1;
split = 100;
d_phi = 2*pi/split;

%{
x = 0;
y = 0;
z = 0;
%}


phi = 0;


B = [0, 0, 0];
i = 0;
%disp(d_B)
%disp(x)

while i < split
    i = i + 1;
    phi = phi + d_phi;
    d_B = ((myu*N*I*a)/(4*pi))*((x-a*cos(phi))^2+(y-a*sin(phi))^2+z^2)^(-3/2)*[z*cos(phi), z*sin(phi), -x*cos(phi)-y*sin(phi)+a]*d_phi;
    %disp(d_B)
    B = B + d_B;
end

%disp(B)
%disp(myu*I*a^2/(2*(a^2 + z^2)^(3/2)))
%{
t = linspace(0,2*pi,100);

figure
plot3(a*sin(t),a*cos(t),zeros(1,100))
hold on
axis([-0.25,0.25,-0.25,0.25,-0.25,0.25])
axis square 
grid on
%}



end