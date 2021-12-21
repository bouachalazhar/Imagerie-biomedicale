clear;
close all;
clc;

I=randi(10,4,4);
% Translation vers le haut
v=[-1,0]; % on se place dans le système d'indexation ligne/colonne : 
% la translation d'un cran vers le haut revient à "remonter" d'une ligne (v(1)=-1)
T=zeros(size(I));

% méthode 1 :
T(max(1,1+v(1)):min(end,end+v(1)),max(1,1+v(2)):min(end,end+v(2))) = ...
   I(max(1,1-v(1)):min(end,end-v(1)),max(1,1-v(2)):min(end,end-v(2)));
disp([I,T]);

% Test de validation : translation vers le bas et à droite
v=[1,1];
T=zeros(size(I));
T(max(1,1+v(1)):min(end,end+v(1)),max(1,1+v(2)):min(end,end+v(2))) = ...
   I(max(1,1-v(1)):min(end,end-v(1)),max(1,1-v(2)):min(end,end-v(2)));
disp([I,T]);

% méthode 2 :
v=[1,1];
T=zeros(size(I));
n1=size(I,1);n2=size(I,2);
T(intersect(1:n1,1+v(1):n1+v(1)),intersect(1:n2,1+v(2):n2+v(2))) = ...
   I(intersect(1:n1,1-v(1):n1-v(1)),intersect(1:n2,1-v(2):n2-v(2)));
disp([I,T]);

% patch :
P=ones(3,3); % on se limite à des patchs de taille carrée impaire
% centre du patch :
p=(size(P,1)+1)/2;
% considérons un pixel du patch
i=1;j=2; % -1 ligne du centre, même colonne que le centre 
% donc translation vers le haut :
v=[i-p,j-p] % v=[-1,0]
i=3;j=3; % +1 ligne du centre, +1 colonne du centre 
% donc translation vers le bas et à droite
v=[i-p,j-p] % v=[1,1]