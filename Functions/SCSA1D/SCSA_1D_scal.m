
%%
    %**********************************************************************
    %                SCSA  Function with Scaling function                 *
    %**********************************************************************

 % Author : Professor Taous_Meriem Laleg . EMAN Group KAUST 
 % taousmeriem.laleg@kaust.edu.sa 
 
 %% Description
 % Script compute the SCSA algorithm  on a 1D signal of size N  with gm=0.5
 % with a scaling funcion parameters  f_scal
 % Done: Nov,  2017

%% input parapeters
% y   :  Noisy  signal
% fs : sampling frequency 
% h  : SCSA parameter
% gm  : SCSA parameter
% f_scal: Scaling function parameteres= [i_0,i_end,Amax,Amin ]
% factor: the sca;ing factor the the interpolation 
 
%% output parapeters
% yscsa   :  denoised  signal
% Nh : Number of Eigen values chosen
% SC_h : The decomposed Matrix of the Schrödinger problem
% f_scal_vars : [x0 xn Amax 1 alpha];
% param   = [scal_flag TypeScal]
function [h, yscsa,Nh,scaling_fun,psi,lamda]= SCSA_1D_scal(y,fs,h,gm,f_scal,param)
%% Prepare the scaling function
global  store_decomposition Results_path post_save_tag
y0=y; 
n=max(size(y));
scaling_fun=Build_scaling_function(n,f_scal,param);
y=scaling_fun.*y0;

%% Start SCSA
Lcl = (1/(2*sqrt(pi)))*(gamma(gm+1)/gamma(gm+(3/2)));
N=max(size(y));
%% remove the negative part
if min(y)<0
    y_scsa = y - min(y);
else
   y_scsa = y; 
end

%% Build Delta metrix for the SC_hSA
feh = 2*pi/N;
D=delta(N,fs,feh);

%% start the SC_hSA
Y = diag(y_scsa);
SC_h = -h*h*D-Y; % The Schrodinger operaor

% = = = = = = Begin : The eigenvalues and eigenfunctions
[psi,lamda] = eig(SC_h); % All eigenvalues and associated eigenfunction of the schrodinger operator
% Choosing  eigenvalues
All_lamda = diag(lamda);
ind = find(All_lamda<0);


%  negative eigenvalues
Neg_lamda = All_lamda(ind);
kappa = diag((abs(Neg_lamda)).^gm); 
Nh = size(kappa,1); %%#ok<NASGU> % number of negative eigenvalues

if Nh~=0
    
    % Associated eigenfunction and normalization
    psin = psi(:,ind(:,1)); % The associated eigenfunction of the negarive eigenvalues
    I = simp(psin.^2,fs); % Normalization of the eigenfunction 
    psinnor = psin./sqrt(I);  % The L^2 normalized eigenfunction 


    %yscsa =4*h*sum((psinnor.^2)*kappa,2); % The 1D SC_hSA formula
    yscsa1 =((h/Lcl)*sum((psinnor.^2)*kappa,2)).^(2/(1+2*gm));



    else
      yscsa1=0*y;
      yscsa1=yscsa1-10*abs(max(y));
      disp('There are no negative eigenvalues. Please change the SCSA parameters: h, gm ')
end

if size(y_scsa) ~= size(yscsa1)
yscsa1 = yscsa1';

end
 
 %% add the removed negative part
 
 if min(y)<0
   yscsa = yscsa1 + min(y);
 else
     yscsa = yscsa1;
 end
 

%% Scal down the output signal
yscsa=yscsa./scaling_fun;

 %% frame the output 
if param(3)==1
yscsa=frame2fun(yscsa,y0);
end

if store_decomposition==1
    
     path_save=strcat(Results_path,'/Decomposition/');
          if exist(path_save)~=7
            mkdir(path_save);
          end
 save(strcat(path_save,'decomp_',post_save_tag,'.mat'))
end



    %**********************************************************************
    %*********              Numerical integration                 *********
    %**********************************************************************

    % Author: Taous Meriem Laleg

    function y = simp(f,dx);
    %  This function returns the numerical integration of a function f
    %  using the Simpson method

    n=length(f);
    I(1)=1/3*f(1)*dx;
    I(2)=1/3*(f(1)+f(2))*dx;

    for i=3:n
        if(mod(i,2)==0)
            I(i)=I(i-1)+(1/3*f(i)+1/3*f(i-1))*dx;
        else
            I(i)=I(i-1)+(1/3*f(i)+f(i-1))*dx;
        end
    end
    y=I(n);
    

    %**********************************************************************
    %*********             Delata Metrix discretization           *********
    %**********************************************************************
    
    
%Author: Zineb Kaisserli

function [Dx]=delta(n,fex,feh)
    ex = kron([(n-1):-1:1],ones(n,1));
    if mod(n,2)==0
        dx = -pi^2/(3*feh^2)-(1/6)*ones(n,1);
        test_bx = -(-1).^ex*(0.5)./(sin(ex*feh*0.5).^2);
        test_tx =  -(-1).^(-ex)*(0.5)./(sin((-ex)*feh*0.5).^2);
    else
        dx = -pi^2/(3*feh^2)-(1/12)*ones(n,1);
        test_bx = -0.5*((-1).^ex).*cot(ex*feh*0.5)./(sin(ex*feh*0.5));
        test_tx = -0.5*((-1).^(-ex)).*cot((-ex)*feh*0.5)./(sin((-ex)*feh*0.5));
    end
    Ex = full(spdiags([test_bx dx test_tx],[-(n-1):0 (n-1):-1:1],n,n));
    
    Dx=(feh/fex)^2*Ex;
    
