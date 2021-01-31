n=300;
theta =linspace(45,180,n);
X =[];
Y=[];
T =[];
D =[];
parfor (i=1:n,30)
    i
    [x_data,y_data,t_data,dist]=two_droplets(theta(i));
    X =[X x_data];
    Y =[Y y_data];
    %T =t_data;
    D = [D ;dist];
end

save(['two_droplets_measures','.mat'],'X','Y','D','theta');