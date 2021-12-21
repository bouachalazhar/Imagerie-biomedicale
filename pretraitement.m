function [Ip, LabIp] = pretraitement(I,R)
  
    % Image originale
    Ir = imread(I);
    figure
    subplot(231)
    imagesc(Ir)
    axis off
    title('image originale');
    Irbw = rgb2gray(Ir);
    subplot(232)
    imshow(Irbw,[])
    title('image en niveaux de gris');
  
    % Image binaire
    seuil = mean(mean(imadjust(Irbw)));
    Irbin = imadjust(Irbw);
    Irbin(imadjust(Irbw) > seuil) = 0;
    Irbin(imadjust(Irbw) < seuil) = 1;
    subplot(233)
    imshow(Irbin, []);
    title('seuillage');
  
  % Image débruitée
    strel1 = strel('disk', R(1), 0);
    IrO = imopen(Irbin, strel1);
    M = zeros(size(Irbw));
    for i = 1:size(Irbw,1)-1:size(Irbw,1)
        for j = 1:size(Irbw,2)-1:size(Irbw,2)
            M(i,:) = Irbw(i,:);
            M(:,j) = Irbw(:,j);
        end
    end
  
    Irec = imreconstruct(uint8(M), IrO);
    Ires = IrO - Irec;
    subplot(234)
    imshow(Ires, [])
    title('extraction du fond');
  
    % Boucher les trous
    strel2 = strel('disk', R(2), 0);
    IrO2 = imopen(1-imreconstruct(Irec, 1-Ires),strel2);
    subplot(235)
    imshow(IrO2, [])
    title('ouverture');
  
    % Composantes connexes
    Ip = bwlabel(IrO2,4);
    subplot(236)
    imagesc(label2rgb(Ip,'prism','k'))
    axis off
    title('Composantes connexes');
  
    % Labels
    LabIp = unique(Ip); 
    LabIp(1) = [];
end