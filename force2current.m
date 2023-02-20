function i_mat = force2current(F, a, i_max, I1, x_j, x_k, q_j, q_k)
%Find the required current from the desired force.
%   Detailed explanation goes here

%a = 0.015;
N = 17;

myu0 = 1.2566*10^(-6);
split = 10;

i_j = I1 ;
%i_k = [1 2 3] ;

%E_j = [pi/3,0,pi/4];
%q_j = quaternion(E_j,'euler','XYZ','point');
I_j1 = zeros(1,3);
I_j2 = zeros(1,3);
I_j3 = zeros(1,3);

for j = 1:3
    I_j1 =  I_j1 + i_j(j)*calculateI(x_j, x_k, q_j, q_k, split, a, j, 1);
    I_j2 =  I_j2 + i_j(j)*calculateI(x_j, x_k, q_j, q_k, split, a, j, 2);
    %disp(I_j2)
    I_j3 =  I_j3 + i_j(j)*calculateI(x_j, x_k, q_j, q_k, split, a, j, 3);
    %disp(I_j3)
end



S = N*[I_j1.', I_j2.', I_j3.'];
%disp(S)
%F = myu0/(4*pi)*N*S*i_k.';

%F = [10^-14, 10^-14, 10^-14].';
%disp(F)

i_mat = 4*pi/(myu0*N)*(S\F.');




if any(i_mat >= i_max)
    i_mat = i_mat * i_max/max(i_mat);
end