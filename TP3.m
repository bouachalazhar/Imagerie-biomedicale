clear;
close all;
clc;

% Exercice 1 : Analyse morphologique des globules rouges

% 1.

dacr = imread("imagesTP3/dacryocytes.png");
dacr_bw = rgb2gray(dacr); % en niveaux de gris
elli = imread("imagesTP3/elliptocytes.png");
elli_bw = rgb2gray(elli);

%{ 
On utilise l'histogramme pour transformer en images binaires grâce à un seuil
que l'on définit.
%}

figure(1)
subplot(221)
imhist(dacr_bw);
title('histogramme dacryocytes')

subplot(222)
imhist(elli_bw);
title('histogramme elliptocytes ')

s1 = mean(mean(imadjust(dacr_bw)));
Ib1 = imadjust(dacr_bw);
Ib1(imadjust(dacr_bw) > s1) = 0;
Ib1(imadjust(dacr_bw) < s1) = 1;
subplot(223)
imshow(Ib1, []);
title('image binaire dacryocytes');

s2 = mean(mean(imadjust(elli_bw)));
Ib2 = imadjust(elli_bw);
Ib2(imadjust(elli_bw) > s2) = 0;
Ib2(imadjust(elli_bw) < s2) = 1;
subplot(224)
imshow(Ib2, []);
title('image binaire elliptocytes');

% 2.

%{
La binarisation fait apparaître du bruit on applique une ouverture minimale
(petit rayon) pour débruiter.
%}

r1 = 1;
r2 = 3;
se1 = strel('disk', r1, 0);
se2 = strel('disk', r2, 0);

Io1 = imopen(Ib1, se1); % ouverture minimale
Io2 = imopen(Ib2, se2);

figure(2)
subplot(221)
imshow(Io1, [])
title('ouverture dacryocytes');

subplot(222)
imshow(Io2, [])
title('ouverture elliptocytes');


% 3.

%{
On crée M1 et M2 égaux aux images des globules rouges sur les bords et 
0 ailleurs. Les reconstructions de M1 M2 inférieures aux images des globules
restaurent les objets aux bords. On extrait l’image résiduelle I1 − R^X(M1,B1) 
et I2 − R^X(M2,B2).
%}

M1 = zeros(size(dacr_bw));
for i = 1:size(dacr_bw,1)-1:size(dacr_bw,1)
  for j = 1:size(dacr_bw,2)-1:size(dacr_bw,2)
    M1(i,:) = dacr_bw(i,:);
    M1(:,j) = dacr_bw(:,j);
  end
end

M2 = zeros(size(elli_bw));
for i = 1:size(elli_bw,1)-1:size(elli_bw,1)
  for j = 1:size(elli_bw,2)-1:size(elli_bw,2)
    M2(i,:) = elli_bw(i,:);
    M2(:,j) = elli_bw(:,j);
  end
end

Idr1 = imreconstruct(uint8(M1), Io1); % reconstruction inférieure
Idr2 = imreconstruct(uint8(M2), Io2);

subplot(223)
imshow(Idr1, [])
title('objets aux bords dacryocytes');

subplot(224)
imshow(Idr2, [])
title('objets aux bords elliptocytes');

% Il nous reste doonc plus qu'à soustraire cette image de l'image d'origine.

Ir1 = Io1 - Idr1; % image résiduelle
Ir2 = Io2 - Idr2;

figure(3)
subplot(221)
imshow(Ir1, [])
title('élimination des objets touchant les bords dacryocytes');

subplot(222)
imshow(Ir2, [])
title('élimination des objets touchant les bords elliptocytes');

% 4.

%{
Un trou peut être vu comme un morceau du complémentaire des globules.
Les globules représentent des une courbes fermée grâce au théorème de Jordan.
On bouche les trous par le complémentaire de la reconstruction dans le 
complémentaire de l'image d'un ensemble qui n'intersecte pas les  globules, soit
R^Xc(X',B)c ; Xc : complémentaire de l'image, 
              X' : ensemble qui n'intersecte pas les  globules
              B : élément structurant
              R^.(.,.)c : complémentaire de la reconstruction
%}

r3 = 1;
r4 = 1;
se3 = strel('disk', r3, 0);
se4 = strel('disk', r4, 0);

Iro1 = imopen(1-imreconstruct(Idr1, 1-Ir1),se3);
Iro2 = imopen(1-imreconstruct(Idr2, 1-Ir2),se4);

subplot(223)
imshow(Iro1, [])
title('boucher les trous dacryocytes');

subplot(224)
imshow(Iro2, [])
title('boucher les trous elliptocytes');

% 5.

Ic1 = bwlabel(Iro1,4);
Ic2 = bwlabel(Iro2,4);

figure(4)
subplot(121)
%L = Ic1;
%imagesc(L,'alphadata',L>0)
imagesc(label2rgb(Ic1,'prism','k'))
axis off
title('Composantes connexes dacryocytes');
subplot(122)
imagesc(label2rgb(Ic2,'prism','k'))
axis off
title('Composantes connexes elliptocytes');

% 6.

Labels1 = unique(Ic1); 
Labels1(1) = []; %ignore le label 0 du fond de l'image
Labels2 = unique(Ic2); 
Labels2(1) = [];

% 7.

I1 = "imagesTP3/dacryocytes.png";
R1 = [1,1];
[Ip1, LabIp1]  = pretraitement(I1, R1);

% 2. Traitement des dacryocytes 2, 5, 13

Iv0 = zeros(length(LabIp1), size(Ip1, 1), size(Ip1, 2));
for i = 1:size(LabIp1,1)
  Ivtest = (Ip1 == i);
  se = strel('diamond', 4);
  Io = imopen(Ivtest, se);
  dIo = Ivtest + abs(Io-Ivtest);
  dp = length(find(abs(Io-Ivtest) == 1));
  Iv0(i,:,:) = dp*(Ip1 == i);
end
Iv1 = reshape(sum(Iv0, 1), size(Iv0, 2), size(Iv0, 3));

figure
imagesc(Iv1, "AlphaData", Iv1 > 0)
title('dacryocytes');
colorbar('Ticks', min(Iv1(:)):5:max(Iv1(:)))
colormap(jet)
axis equal; axis tight;

% On a les composantes 2, 5 et 13 qui ressortent avec une ouverture de taille 4 qu'on
% met en place uniquement après observation.

% 3. Traitement des elliptocytes

I2 = "imagesTP3/elliptocytes.png";
R2 = [3,2];
[Ip2, LabIp2]  = pretraitement(I2,R2);

Iv2 = zeros(length(LabIp2), size(Ip2, 1), size(Ip2, 2));
Iv3 = zeros(length(LabIp2), size(Ip2, 1), size(Ip2, 2));
mesure = regionprops('table', Ip2, 'all');
mx = mesure.MaxFeretDiameter; mn = mesure.MinorAxisLength;
for i = 1:size(LabIp2,1)
  Ivtest2 = (Ip2 == i);
  Ivtest3 = (Ip2 == i);
  se = strel('disk', 12, 0);
  Io = imopen(Ivtest2, se);
  dIo = Ivtest2 + abs(Io-Ivtest2);
  m1 = regionprops('table', Io, 'all');
  dp = m1.Solidity * m1.MinFeretDiameter;
  Iv2(i,:,:) = dp*(Ip2 == i);
  m2 = regionprops('table', Io, 'all');
  mn = m2.MinorAxisLength;
  dp1 = mx(i)/mn;
  Iv3(i,:,:) = dp1*(Ip2 == i);
end
Iv2 = reshape(sum(Iv2, 1), size(Iv2, 2), size(Iv2, 3));
Iv3 = reshape(sum(Iv3, 1), size(Iv3, 2), size(Iv3, 3));

figure
subplot(121)
imagesc(Iv2, "AlphaData", Iv2 > 0)
title('Épaisseurs');
colorbar('Ticks', round(min(Iv2(Iv2 ~= 0))):2:max(Iv2(:)))
lim = caxis; caxis([round(min(Iv2(Iv2 ~= 0))) max(Iv2(:))]); 
colormap(jet)
axis equal; axis tight;

subplot(122)
imagesc(Iv3, "AlphaData", Iv3 > 0)
title('Anisotropie');
colorbar('Ticks', round(min(Iv3(Iv3 ~= 0))):0.2:max(Iv3(:)))
lim1 = caxis; caxis([round(min(Iv3(Iv3 ~= 0))) max(Iv3(:))]);
colormap(jet)
axis equal; axis tight;

% On retrouve les globules concernés (1, 3, 7, 10 épaisseurs) avec une ouverture taille 12 
% et de même pour l'anisotropie grâce à un rapport grand axe/ petit axe.
