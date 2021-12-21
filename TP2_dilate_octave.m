clear;
close all;
clc;

I=randi(10,4,4);
% Translation vers le haut
v=[-1,0]; % on se place dans le syst�me d'indexation ligne/colonne : 
% la translation d'un cran vers le haut revient � "remonter" d'une ligne (v(1)=-1)
T=zeros(size(I));

% m�thode 1 :
T(max(1,1+v(1)):min(end,end+v(1)),max(1,1+v(2)):min(end,end+v(2))) = ...
   I(max(1,1-v(1)):min(end,end-v(1)),max(1,1-v(2)):min(end,end-v(2)));
disp([I,T]);

% Test de validation : translation vers le bas et � droite
v=[1,1];
T=zeros(size(I));
T(max(1,1+v(1)):min(end,end+v(1)),max(1,1+v(2)):min(end,end+v(2))) = ...
   I(max(1,1-v(1)):min(end,end-v(1)),max(1,1-v(2)):min(end,end-v(2)));
disp([I,T]);

% m�thode 2 :
v=[1,1];
T=zeros(size(I));
n1=size(I,1);n2=size(I,2);
T(intersect(1:n1,1+v(1):n1+v(1)),intersect(1:n2,1+v(2):n2+v(2))) = ...
   I(intersect(1:n1,1-v(1):n1-v(1)),intersect(1:n2,1-v(2):n2-v(2)));
disp([I,T]);

% patch :
P=ones(3,3); % on se limite � des patchs de taille carr�e impaire
% centre du patch :
p=(size(P,1)+1)/2;
% consid�rons un pixel du patch
i=1;j=2; % -1 ligne du centre, m�me colonne que le centre 
% donc translation vers le haut :
v=[i-p,j-p] % v=[-1,0]
i=3;j=3; % +1 ligne du centre, +1 colonne du centre 
% donc translation vers le bas et � droite
v=[i-p,j-p] % v=[1,1]