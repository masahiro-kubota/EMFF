function B = dipole2m_field(myu, r)
%UNTITLED5 Summary of this function goes here
%   Detailed explanation goes here
myu_0 = 1.2566*10^(-6);
n_r = norm(r);

B = myu_0/(4*pi)*((3*dot(myu, r)/n_r^5)*r-myu/n_r^3);

end