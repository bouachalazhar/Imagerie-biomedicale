clear;
close all;
clc;

% Exercice 1 : Dilatation et érosion

% 1.

[X, Y] = meshgrid(1:0.1:25, 1:0.1:25);
a = 12.5;
b = 12.5;
r1 = 3;
r2 = 4;
C = (X - a).^2 + (Y - b).^2;
C_img = C <= r1.^2 + r2 & C > r1.^2 - r2;
Bx1 = ones(5);

figure(1)
subplot(331)
imagesc(C_img);
title('cercle');

Id1 = my_dilatation(C_img, Bx1);
subplot(332)
imagesc(Id1);
title('image dilatée par my\_dilatation');

Id2 = imdilate(C_img,Bx1);
subplot(333)
imagesc(Id2);
title('image dilatée par imdilate');

% On obtient le même résulat avec la fonction imdilate qu'avec la fonction my_dilatation.

% 2.

% C'est égale à une dilatation par un carré de taille 8x8.
 
Bx2 = ones(3);
Bx3 = ones(8);
Id3 = my_dilatation(C_img,Bx2);
Id4 = my_dilatation(Id3,Bx1);
Id5 = my_dilatation(C_img,Bx3);
Z = Id5 - Id4;

subplot(334)
imagesc(Id4);
title('(1) : image dilatée par un carré de taille 3x3 puis 5x5');

subplot(335)
imagesc(Id5);
title('(2) : image dilatée par un carré de taille 8x8');

subplot(336)
imagesc(Z);
title("différence entre l'image (1) et (2)");

% On voit que les images (1) et (2) sont proches car l'image Z est quasi nulle. 

% 3.

% L'élément disk dans la fonction strel signifie qu'on crée un élément 
% structurant en forme de disque, où r est le rayon et n spécifie le nombre de 
% lignes utilisées pour approximer la forme du disque (ici seul n = 0 fonctionne).

r = 5;
I = zeros(4*r+1); I(floor(size(I,1)/2) +1, floor(size(I,2)/2) +1) = 1;
se1 = strel("disk", r, 0);
SE1 = getnhood(se1);  % afin qu'on puisse extraire la matrice de strel
Id6 = my_dilatation(I, SE1);

subplot(337)
imagesc(Id6);
title("image dilatée par un strel de rayon r");

% 4.

Ie1 = my_erosion(C_img,Bx1);
subplot(338)
imagesc(Ie1);
title('image erodée par my erosion');

Ie2 = imerode(C_img,Bx1);
subplot(339)
imagesc(Ie2);
title('image érodée par imerode');

% On retrouve le même résultat pour l'érosion ce qui est pertinent.

% 5.

gamma4 = ones(3); gamma4(1,1) = 0;  gamma4(1,3) = 0;  
gamma4(3,1) = 0; gamma4(3,3) = 0;
gamma8 = ones(3);
se2 = strel(gamma4);
SE2 = getnhood(se2);

angio_irm1 = imread("imagesTP2/angio-irm.png");
Id_angio1 = imdilate(angio_irm1, SE2);
Ie_angio1 = imerode(angio_irm1, SE2);
Grad_angio1 = Id_angio1 - Ie_angio1;

figure(2)
subplot(141)
imshow(angio_irm1);
title("image angio-irm1");

subplot(142)
imshow(Id_angio1);
title("image dilatée angio-irm1");

subplot(143)
imshow(Ie_angio1);
title("image érodée angio-irm1");

subplot(144)
imshow(Grad_angio1);
title("contour de l'image angio-irm");

angio_irm2 = imread("imagesTP2/angio-irm2.png");
Id_angio2 = imdilate(angio_irm2, SE2);
Ie_angio2 = imerode(angio_irm2, SE2);
Grad_angio2 = Id_angio2 - Ie_angio2;

figure(3)
subplot(141)
imshow(angio_irm2);
title("image angio-irm2");

subplot(142)
imshow(Id_angio2);
title("image dilatée angio-irm2");

subplot(143)
imshow(Ie_angio2);
title("image érodée angio-irm2");

subplot(144)
imshow(Grad_angio2);
title("contour de l'image angio-irm2");

% 6.

Ig1 = rgb2gray(double(Grad_angio1)/255);

figure(4)
subplot(131)
plot(sort(Ig1(:)),'*')
xlim([0 length(Ig1(:))])
ylim([min(Ig1(:)) max(Ig1(:))])
subplot(132)
histogram(Ig1(:), "BinLimits", [0 max(Ig1(:))])
xlim([min(Ig1(:)) max(Ig1(:))])
[GC1, GR1] = groupcounts(Ig1(:));
ylim([0 max(GC1)])

vmin = 0.2; vmax = 0.7;
Ig1v = ((vmax-vmin)/max(Ig1(:)))*Ig1 + vmin;
Ig1n = Ig1/max(Ig1(:)); %Ig1n = max(Ig1(:))*((Ig1v - vmin)/(vmax-vmin));
Img1 = Ig1n;
for i = 1:size(Img1, 1)
  for j = 1:size(Img1, 2)
    if Img1(i,j) <= vmin
      Img1(i,j) = vmin;
    elseif Img1(i,j) >= vmax
      Img1(i,j) = vmax;
    else
            % pass
    end
  end
end

x1 = sort(Ig1n(:));
y1 = sort(Img1(:));

subplot(133)
hold on
plot(x1, x1, 'Color', [0.85 0.85 0.85], 'LineStyle', '--', 'LineWidth', 1)
plot(x1, y1, 'Color', 'r', 'LineStyle', '-', 'LineWidth', 2)
yline(vmin, 'b--');
yline(vmax, 'b--');
xlim([0 1])
ylim([0 1])

figure(5)
subplot(121)
imagesc(Ig1);
axis off
colorbar('Ticks', min(Ig1(:)):0.1:max(Ig1(:)))
colormap(gray)
title("image angio-irm1");

subplot(122)
imagesc(Img1);
axis off
colorbar('Ticks', min(Img1(:)):0.1:max(Img1(:)))
colormap(gray)
title("image contrastée angio-irm1");

Ig2 = rgb2gray(double(Grad_angio2)/255);

figure(6)
subplot(131)
plot(sort(Ig2(:)),'*')
xlim([0 length(Ig2(:))])
ylim([min(Ig2(:)) max(Ig2(:))])
subplot(132)
histogram(Ig2(:), "BinLimits", [0 max(Ig2(:))])
xlim([min(Ig2(:)) max(Ig2(:))])
[GC2, GR2] = groupcounts(Ig2(:));
ylim([0 max(GC2)])

vmin = 0.025; vmax = 0.3;
Ig2v = ((vmax-vmin)/max(Ig2(:)))*Ig2 + vmin;
Ig2n = Ig2/max(Ig2(:)); %Ig2n = max(Ig2(:))*((Ig2v - vmin)/(vmax-vmin));
Img2 = Ig2n;
for i = 1:size(Img2, 1)
  for j = 1:size(Img2, 2)
    if Img2(i,j) <= vmin
      Img2(i,j) = vmin;
    elseif Img2(i,j) >= vmax
      Img2(i,j) = vmax;
    else
      % pass
    end
  end
end

x2 = sort(Ig2n(:));
y2 = sort(Img2(:));

subplot(133)
hold on
plot(x2, x2, 'Color', [0.85 0.85 0.85], 'LineStyle', '--', 'LineWidth', 1)
plot(x2, y2, 'Color', 'r', 'LineStyle', '-', 'LineWidth', 2)
yline(vmin, 'b--');
yline(vmax, 'b--');
xlim([0 1])
ylim([0 1])

figure(7)
subplot(121)
imagesc(Ig2);
axis off
colorbar('Ticks', min(Ig2(:)):0.1:max(Ig2(:)))
colormap(gray)
title("image angio-irm2");

subplot(122)
imagesc(Img2);
axis off
colorbar('Ticks', 2*min(Img2(:)):0.05:max(Img2(:)))
colormap(gray)
title("image contrastée angio-irm2");

% Exercice 2 : Rétinopathie

% 1.
retino = imread("imagesTP2/retino.png");
retino_bw = double(rgb2gray(retino))/255;
retino_bw = retino_bw - min(retino_bw(:));

r = 1;
rayons = [3*r, 4*r, 5*r, 6*r]; % (un tableau de 4 rayons à tester)
Od_retino = zeros(size(retino_bw, 1), size(retino_bw, 2), 4);
Ir = Od_retino;
figure(8);
set(gcf,'color','w');
for i = 1:4
  % test pour le i-ème rayon
  se3 = strel('disk', rayons(i), 4);
  Od_retino(:,:,i) = imopen(retino_bw, se3);
  Ir(:,:,i) = retino_bw - Od_retino(:,:,i);
  subplot(2,2,i);
  imagesc(Ir(:,:,i))
  axis off
  colorbar('Ticks', min(Ir(:,:,i), [], 'all'):0.05:max(Ir(:,:,i), [], 'all'))
  colormap(gray)
  title(sprintf('Rayon = %d', rayons(i)));
end

seuil = [0.2, 0.25, 0.27, 0.29];
r = 3;
Irs = Ir(:,:,r); % choix du rayon 3
M = max(Ir(:,:,r), [], 'all');
figure(9);
for j = 1:4
  m = 0.5*(M + seuil(j));
  subplot(2,2,j)
  Irs(Ir(:,:,r) <= seuil(j)) = 0;
  if and((seuil(j) < Ir(:,:,r)) <= m, Irs ~= 0)
    Irs((seuil(j) < Ir(:,:,r)) <= m) = abs(seuil(j) - M);
  end
  Irs(Ir(:,:,r) > m) = M;
  imagesc(Irs)
  axis off
  colorbar('Ticks', min(Irs(:)):0.05:max(Irs(:)))
  colormap(gray)
  title(sprintf('Seuil = %.2f', seuil(j)));
end

% Les paramètres optimaux (rayon et seuil) sont R = 5 et seuil = 0.29 puisqu'on 
% a un rendu les faux négatifs, les faux positifs et le bruit au minimum.
  
% 2.

r1 = 5;
theta = rad2deg([0, pi/4, pi/2, 3*pi/4]);
m = zeros(4,1);
Ol_retino = zeros(size(retino_bw, 1), size(retino_bw, 2), 4);
Ir1 = Ol_retino;
figure(10)
for i = 1:4
  % test pour le i-ème rayon
  subplot(2,2,i);
  if i == 1
    line = ones(1, r1);
    Ol_retino(:,:,i) = imopen(retino_bw, line);
  elseif i == 2
    linemat = rot90(eye(r1));
    Ol_retino(:,:,i) = imopen(retino_bw, linemat);
  elseif i == 3
    Ol_retino(:,:,i) = imopen(retino_bw, line');
  elseif i == 4
    Ol_retino(:,:,i) = imopen(retino_bw, eye(r1));
  end
  Ir1(:,:,i) = retino_bw - Ol_retino(:,:,i);
  imagesc(Ir1(:,:,i))
  axis off
  if max(Ir1(:,:,i), [], 'all') == Inf
    colorbar('Ticks', min(Ir1(:,:,i), [], 'all'):0.05:max(Ir1(:,:,4), [], 'all'))
    lim1 = caxis; caxis([min(Ir1(:,:,i), [], 'all') max(Ir1(:,:,4), [], 'all')]);
    colormap(gray)
    title(sprintf('Theta = %d', theta(i)));
  else
    colorbar('Ticks', min(Ir1(:,:,i), [], 'all'):0.05:max(Ir1(:,:,i), [], 'all'))
    colormap(gray)
    title(sprintf('Theta = %d', theta(i)));
  end
end

% En observant, les images résiduelles avec l'ouverture "line" les angles à 0°
% et à 90° ressortent les mêmes points blancs mais les angles 45° et 135° 
% renvoient d'autres points blancs. (R - Ir1(:,:,4).^2)

% 3.

R = Ir1(:,:,1) .* Ir1(:,:,2) + Ir1(:,:,1) .* Ir1(:,:,3) + (Ir1(:,:,1) .* Ir1(:,:,4)).^2 + (Ir1(:,:,2) .* Ir1(:,:,3)).^2 + Ir1(:,:,2) .* Ir1(:,:,4) + (Ir1(:,:,3) .* Ir1(:,:,4)).^2;
RR = sum(R(:))*R/255;

figure(11)
imagesc(RR)
axis off
colorbar('Ticks', min(RR(:)):0.05:max(RR(:)))
colormap(gray)
title('Combinaison des ouvertures par ligne');

seuil1 = [0.06, 0.07, 0.08, 0.09];
Irs2 = RR;
M = max(RR(:), [], 'all');
figure(12);
for j = 1:4
  m = 0.5*(M + seuil1(j));
  Irs2(RR <= seuil1(j)) = 0;
  if and((seuil1(j) < RR) <= m, Irs2 ~= 0)
    Irs2((seuil1(j) < RR) <= m) = abs(seuil1(j) - M);
  end
  Irs2(RR > m) = M;
  subplot(2,2,j)
  imagesc(Irs2)
  axis off
  colorbar('Ticks', min(Irs2(:)):0.05:max(Irs2(:)))
  colormap(gray)
  title(sprintf('Seuil = %.2f', seuil1(j)));
end

% Le choix du seuil à 0.07 est optimal.

% 4.

r2 = 2;
se5 = strel('disk', r2, 0);
R_od2 = 4*imopen(RR, se5); 
figure(13)
imagesc(R_od2)
axis off
colorbar('Ticks', min(R_od2(:)):0.02:max(R_od2(:)))
colormap(gray)
title('Ouverture par un disque');

% Une ouverture comme le seuillage permet de rendre les points blancs 
% plus lumineux et aussi d'avoir un fond plus noir c'est à dire sans bruit.
