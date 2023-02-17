myu = 3.986*10^14;
earth_radius = 6378.140*10^3;

altitude = 500*10^3;%高度
r_star = earth_radius + altitude;

n = sqrt(myu/r_star^3);
%disp(2*pi/(n*60)) 軌道周期

m = 0.05;%衛星質量
u_upper = 1;%推力上限
u_lower = -1;%推力下限

T = 10;
N = 90*60*1/10;

A = [0, 0, 0, 1, 0, 0;
     0, 0, 0, 0, 1, 0;
     0, 0, 0, 0, 0, 1;
     0, 0, 0, 0, 0, 2*n;
     0, -n^2, 0, 0, 0, 0;
     0, 0, 3*n^2, -2*n, 0, 0];

B = [0, 0, 0;
     0, 0, 0;
     0, 0, 0;
     1/m, 0, 0;
     0, 1/m, 0;
     0, 0, 1/m];

A_d = eye(6) + T*A;%差分方程式の係数
B_d = T*B;%差分方程式の係数

%A_d = eye(6) * 2;
%B_d = eye(6,3) * 3;

x_0 = [0, 0.05, 0, 0, 0, 0].';

%x = ones(6*(N+1), 1)*10^-2;%k=0~N 6×(N+1)

%x = repmat([0,0.05,0,0,0,0].',[N+1,1]);
%dynamic_test_eulerを実行して初期値を計算.uを同じにする必要がある．
%u = zeros(3*N, 1)*10^-5;%k=0~N-1　3×N
u = repmat([-1,1,0].', [N,1])*10^-5;

X = cat(1, x, u);%ひとつのベクトルに統合 初期条件



i = 0;
A_ = zeros(N+1, 6);%全ての時間の状態を状態変数とした状態方程式の係数

while i < N+1

    i = i + 1;
    A_(1 + 6*(i - 1):6*i, 1:6) = A_d^(i-1);

end



i = 0;
B_ = zeros(6*(N+1), 3*N);%全ての時間の状態を状態変数とした状態方程式の係数
%disp(size(Beq));


while i < N + 1
    i = i + 1;
    j = 0;
    while j < N
        j = j + 1;
        if i<=j
            B_(1 + 6*(i - 1):6*i, 1 + 3*(j - 1):3*j) = zeros(6, 3);
        else
            B_(1 + 6*(i - 1):6*i, 1 + 3*(j - 1):3*j) = A_d^(i-j-1)*B_d;
        end
    end
    
end


Aeq = zeros(6*(N + 1), 9*N+6);%Aeq x = Beqの形に変形

Aeq(1:6*(N+1), 1:6*(N+1)) = eye(6*(N+1));
Aeq(1:6*(N+1), 6*(N+1)+1:9*N+6) = -B_;
%disp(Aeq)

Beq = A_*x_0;%Aeq x = Beqの形に変形

%disp(Beq)

%f = @(x,y) x.*exp(-x.^2-y.^2)+(x.^2+y.^2)/20;%この式を最小化する
%fun = @(x) f(x(1),x(2));

%g = @(x,y) x.*y/2+(x+2).^2+(y-2).^2/2-2;%非線形不等式制約
%gfun = @(x) deal(g(x(1),x(2)),[]);%一個目に非線形不等式制約，二個目に非線形等式制約

A = [];
b = [];
%Aeq = [];
%Beq = [];

lb = cat(1,repmat(-Inf,6*(N+1),1),repmat(u_lower,3*N,1));%全ての時間での下限を設定
ub = cat(1,Inf(6*(N+1),1),repmat(u_upper,3*N,1));%全ての時間での下限を設定

gfun = [];
options = optimoptions('fmincon','Algorithm','interior-point','Display','iter');

J = @(X) sum(X(6*(N+1)+1:9*N+6,1));%合計推力
fun = @(X) J(X);

[x,fval,exitflag,output] = fmincon(fun,X,A,b,Aeq,Beq,lb,ub,gfun,options);