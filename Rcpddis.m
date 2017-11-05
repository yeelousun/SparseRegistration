function [C] = Rcpddis( X,Y )

% add a random rigid transformation

% Set the options
opt.method='rigid'; % use rigid registration
opt.viz=0;          % show every iteration
opt.outliers=0;     % do not assume any noise 

opt.normalize=1;    % normalize to unit variance and zero mean before registering (default)
opt.scale=1;        % estimate global scaling too (default)
opt.rot=1;          % estimate strictly rotational matrix (default)
opt.corresp=0;      % do not compute the correspondence vector at the end of registration (default)

opt.max_it=100;     % max number of iterations
opt.tol=1e-8;       % tolerance


% registering Y to X
[Transform, ~]=cpd_register(X,Y,opt);

%figure,cpd_plot_iter(X1, Y1); title('Before');
%figure,cpd_plot_iter(X, Transform.Y);  title('After registering Y to X');
Yicp = Transform.R *  Y' + repmat(Transform.t, 1,size(Y,1) );

a=sum(X);
b=sum(Yicp');

C=norm(a-b);

end

