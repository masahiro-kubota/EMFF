function [F, i_k] = force2current(F, a, i_max, x_j, x_k, q_j, q_k)
%Find the required current from the desired force.
%   Detailed explanation goes here


%disp(F)
%disp(a)
%disp(i_max)
%disp(x_j)
%disp(x_k)
%disp(q_j)
%disp(q_k)

%a = 0.015;
N = 17;

myu0 = 1.2566*10^(-6);
split = 10;

i_j = i_max * (x_k - x_j)/norm(x_k - x_j) ;
%i_k = [1 2 3] ;

%E_j = [pi/3,0,pi/4];
%q_j = quaternion(E_j,'euler','XYZ','point');
I_j1 = zeros(1,3);
I_j2 = zeros(1,3);
I_j3 = zeros(1,3);

for j = 1:3
    I_j1 =  I_j1 + i_j(j)*calculateI(x_j, x_k, q_j, q_k, split, a, j, 1);
    %disp(I_j1)
    %disp(calculateI(x_j, x_k, q_j, q_k, split, a, j, 1))
    I_j2 =  I_j2 + i_j(j)*calculateI(x_j, x_k, q_j, q_k, split, a, j, 2);
    %disp(I_j2)
    I_j3 =  I_j3 + i_j(j)*calculateI(x_j, x_k, q_j, q_k, split, a, j, 3);
    %disp(I_j3)
end



S = N*[I_j1.', I_j2.', I_j3.'];

%disp("SSSSSSS")
%disp(S)
%F = myu0/(4*pi)*N*S*i_k.';

%F = [10^-14, 10^-14, 10^-14].';
%disp(F)
%F = F*1;

i_k = 4*pi/(myu0*N)*(S\F.');
%disp(i_k)

if max(abs(i_k)) >= i_max
    i_k = i_k * i_max/max(abs(i_k));
    %disp('over')
end


F = myu0/(4*pi)*N*S*i_k;

end