function Ie = my_erosion1(I ,B)
    Ie = -my_dilatation(~I, B); % dilater sur les pixels blancs <=> éroder.
end