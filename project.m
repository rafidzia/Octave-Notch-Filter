% membaca data gambar
gambar = imread('halftone.png'); 

figure(1);
imshow(gambar);
title('original image');

% mengubah gambar menjadi grayscale
% gambar1 = rgb2gray(gambar); 
gambar1 = gambar;

figure(2);
imshow(gambar1);
title('grayscale image');

% melakukan operasi fast fourier transform
F = fft2(gambar1); 

S = abs(F);
% figure(3);
% imshow(S,[]);
title('fourier transform image');

% melakukan operasi shifting terhadap fourier
Fsh = fftshift(F);

% figure(4);
% imshow(abs(Fsh),[]);
title('center fourier transform');

% mengaplikasikan magnitude pada hasil fourier
S2 = log(1+abs(Fsh));

figure(5);
imshow(S2,[]);
title('log transform image')

% menggunakan inverse fourier untuk mengembalikan ke gambar grayscale semula
F = ifftshift(Fsh); 
f = ifft2(F); 

figure(6);
imshow(f,[]);
title('image reconstruction')