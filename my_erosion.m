function Ie = my_erosion(I ,B)
  [I1,I2] = find(I == 0); % indices à pixel blanc de l'image
  [B1,B2] = find(B); % indices élement structurant
  B1 = B1 - floor(size(B,1)/2) - 1; % indices élement structurant par rapport au centre de l'image
  B2 = B2 - floor(size(B,2)/2) - 1;
  Ie2 = zeros(size(I,1), size(I,2));
  for i = 1:numel(I1) % boucle sur les pixels blancs
    I_L = I1(i); % indices des pixels blancs
    I_C = I2(i);
    for j = 1:numel(B1) % boucle sur les indices non nuls (élement structurant)
      L = I_L + B1(j); % la position du pixel est (L; C)
      C = I_C + B2(j);
      if L > 0 && C > 0 && L <= size(I,1)  && C <= size(I,2)
        Ie2(L,C) = 1; % valeur 1 au pixel dans l'image
      end
    end
  end
  Ie = -Ie2; % dilater sur les pixels blancs <=> éroder.
end
