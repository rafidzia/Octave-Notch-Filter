footBall=imread('halftone.png');
imshow(footBall)

%Determine good padding for Fourier transform
PQ = 2*size(footBall);


types = 'gaussian';
form = 'high';
%Create Notch filters corresponding to extra peaks in the Fourier transform
a = 200;
b = 133;

nArr = createArrays(49, [PQ(1) PQ(2)]);
o = 1;
for i = 1:9
    for j = 1:5
        if(mod(i, 2) == 0)
            nArr{o} = notch(types, form, PQ(1), PQ(2), 20, a*i, b*((j-1)*2));
        else
            nArr{o} = notch(types, form, PQ(1), PQ(2), 20, a*i, b*((j*2)-1));
        end
        o = o + 1;
    end
end

nArr{46} = notch(types, form, PQ(1), PQ(2), 20, a*0, b*2);
nArr{47} = notch(types, form, PQ(1), PQ(2), 20, a*0, b*4);
nArr{48} = notch(types, form, PQ(1), PQ(2), 20, a*0, b*6);
nArr{49} = notch(types, form, PQ(1), PQ(2), 20, a*0, b*8);

% H1 = notch(types, form, PQ(1), PQ(2), 20, a*1, b*1);
% H2 = notch(types, form, PQ(1), PQ(2), 20, a*1, b*3);
% H3 = notch(types, form, PQ(1), PQ(2), 20, a*1, b*5);
% H4 = notch(types, form, PQ(1), PQ(2), 20, a*1, b*7);
% H5 = notch(types, form, PQ(1), PQ(2), 20, a*1, b*9);

% H6 = notch(types, form, PQ(1), PQ(2), 20, a*2, b*0);
% H7 = notch(types, form, PQ(1), PQ(2), 20, a*2, b*2);
% H8 = notch(types, form, PQ(1), PQ(2), 20, a*2, b*4);
% H9 = notch(types, form, PQ(1), PQ(2), 20, a*2, b*6);
% H10 = notch(types, form, PQ(1), PQ(2), 20, a*2, b*8);


% Calculate the discrete Fourier transform of the image
F=fft2(double(footBall),PQ(1),PQ(2));

if form == 'high'
    asd = nArr{1};
    for i = 2:49
        asd = asd.*nArr{i};
    end
    % asd = H1.*H2.*H3.*H4.*H5.*H6.*H7.*H8.*H9.*H10;
elseif form == 'loww'
    asd = nArr{1};
    for i = 2:49
        asd = asd .+ nArr{i};
    end
    % asd = H1.+H2.+H3.+H4.+H5.+H6.+H7.+H8.+H9.+H10;
end
F_asd=fftshift(asd);
S0=log(1+abs(F_asd));
figure, imshow(S0,[])


% Apply the notch filters to the Fourier spectrum of the image
FS_football = F.*asd;

% convert the result to the spacial domain.
F_football=real(ifft2(FS_football)); 

% Crop the image to undo padding
F_football=F_football(1:size(footBall,1), 1:size(footBall,2));

%Display the blurred image
figure, imshow(F_football,[])

% Display the Fourier Spectrum 
% Move the origin of the transform to the center of the frequency rectangle.
Fc=fftshift(F);
Fcf=fftshift(FS_football);

% use abs to compute the magnitude and use log to brighten display
S1=log(1+abs(Fc)); 
S2=log(1+abs(Fcf));
figure, imshow(S1,[])
figure, imshow(S2,[])