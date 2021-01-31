function [x_data,y_data,t_data,dist]=two_droplets(theta)

theta_rad = theta*pi/180;
%% Set parameters
mem = 0.9;
Gam = mem*4.20;
Nx = 128; Ny = Nx; 
global Lx;  global Ly; 
Lx=50;
Ly=50;
dt_desired = min(Lx/Nx,Ly/Ny)/18;
plotoption = inf;
p = problem_setup_two_droplets(Nx,Ny,Lx,Ly,Gam,dt_desired);
depth =0;
switch depth
    case 0
        p.d = p.d0_deep*ones(size(p.xx));
    % On a 2 regions 
    case 1
         p.h   = p.h0_shallow.*(p.xx>10)+p.h0_deep.*(p.xx<=10);
         p.d   = p.d0_shallow.*(p.xx>10)+p.d0_deep.*(p.xx<=10);
         p.x_wall= 10;
    % On a trois régions de profondeurs différentes 
    case 2
        p.d = p.d0_deep*ones(size(p.xx));
        n = size(p.xx);
        arrondi = round(n/3); % On va diviser l'espace en 3 
        for i=1:n
            for j=arrondi(1):2*arrondi(1)
                p.d(i,j)= p.d0_shallow; 
            end
        end
        %On calculer les coordonnées des murs pour les afficher aprés
        %ATTENTION IL FAUT CHANGER UN PEU LE CODE DANS PLOTSOLUTION POUR
        %QUE CA MARCHE!!! COMING SOON 
        p.x_wall_1 = Lx/3;
        p.x_wall_2 = 2*Lx/3;
end


switch p.num_drops
    case 2
    % Conditions initiales si on a deux gouttes 
    speed_steady= 20;
    %conditions initiales à modifer pour mettre plusieurs gouttes.
    p.xi = [0 -15*sin(theta_rad)]; p.yi = [15 15*cos(theta_rad)]; p.ui =[0 0.5*sin(theta_rad)]; p.vi = [-0.5 -0.5*cos(theta_rad)];p.makeMovie=0;  theta = 0*pi/180;
    %p.ui=speed_steady*cos(theta); p.vi = speed_steady*sin(theta);
    p.nimpacts = 400;      % Number of impacts
    rr = sqrt(p.xx.^2+p.yy.^2);
    p.useGPU=0;
end



%profile du fond

if p.useGPU == 1
    p.d = gpuArray(p.d); p.b = gpuArray(p.b); p.a = gpuArray(p.a);
end
   
[x_data,y_data,t_data, eta_data,dist]  = trajectory(p,plotoption); 
%theta = atan(diff(y_data)./diff(x_data))*180/pi; 
%save(['freespace_wavefield_droptype_',num2str(p.drop_type),...
 %     '_mem_',num2str(mem),'_DtN_',num2str(p.DtN_method),'_N_',num2str(p.Nx),'.mat'],...
  %      'x_data','y_data','t_data','p','eta_data');







