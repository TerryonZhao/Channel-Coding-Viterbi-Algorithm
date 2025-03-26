bits = randsrc(1,10,[0 1])

[bits_enc, x_soft] = encoder(bits, 4);

disp('bits_enc:')
disp(bits_enc)