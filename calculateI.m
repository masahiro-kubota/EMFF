function I_jk = calculateI(x_j, x_k, q_j, q_k, split, a, j_coil, k_coil)
%２つのコイルによって発生する電磁力の周回積分項を計算
%   Detailed explanation goes here


if j_coil == 1
    E = [0,pi/2,0];
    q_x = quaternion(E,'euler','XYZ','point');
    q_j = q_j*q_x;
end

if j_coil == 2
    E = [-pi/2,0,0];
    q_x = quaternion(E,'euler','XYZ','point');
    q_j = q_j*q_x;
end

if k_coil == 1
    E = [0,pi/2,0];
    q_x = quaternion(E,'euler','XYZ','point');
    q_k = q_k*q_x;
end


if k_coil == 2
    E = [-pi/2,0,0];
    q_x = quaternion(E,'euler','XYZ','point');
    q_k = q_k*q_x;
end




d_phi = 2*pi/split;
d_theta = 2*pi/split;

I_jk = zeros(1,3);
phi = 0;

for l = 1:split
    phi = phi + d_phi;
    theta = 0;
    II_ij = zeros(1,3);
    for m = 1:split
        theta = theta + d_theta;
        r_jk = calculater_jk(x_j, x_k, q_j, q_k, theta, phi, a);

        %磁場II_ijの向きdispすると向きが合ってるかのデバッグができる．
        II_ij = II_ij + 1/norm(r_jk)^3*cross(rotatepoint(q_j, [-a*sin(theta), a*cos(theta), 0]), r_jk)*d_theta;
        %disp(r_jk)
        %disp(1/norm(r_jk)^3*cross(r_jk, [-a*sin(phi), a*cos(phi), 0]))
    end

    q_jk = quatmultiply(q_k, quatconj(q_j));
    
    %disp(rad2deg(phi))
    %disp(r_jk)
    %disp(II_ij)
    %disp(cross(II_ij, rotatepoint(q_jk, [-a*sin(theta), a*cos(theta), 0])*d_theta))
    %disp(q_k)
    rt = rotatepoint(q_k, [-a*sin(phi), a*cos(phi), 0]);
    I_jk = I_jk + cross(rt, II_ij)*d_phi;
    
    %disp(x_k - x_j + rotatepoint(q_jk, [-a*sin(theta), a*cos(theta), 0]))
    %disp(I_jk)
    
end
