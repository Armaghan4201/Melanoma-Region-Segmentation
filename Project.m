close all; clearvars; clc

%% Generating a Mask for Extracting ROI from a Noisy Image

image = im2double(imread('Sample Image.jpg'));
figure('windowstate','maximized'), imshow(image), title('Given Image', 'fontsize', 18)

grayscale = rgb2gray(image);                  % Converting to image grayscale
figure('windowstate','maximized'), imshow(grayscale), title('Grayscale Image', 'fontsize', 18)

se = strel('disk',5);                         % Disk Shaped Structuring Element
hairs = imbothat(grayscale,se);               % Bottom Hat Filtering for Extracting Hairs
figure('windowstate','maximized'), imshow(hairs), title('Hairs Extracted', 'fontsize', 18)

replacedImage = regionfill(grayscale, hairs); % Filling the Hair Region with Inward Interpolation
figure('windowstate','maximized'), imshow(replacedImage), title('Hairs Removed', 'fontsize', 18)

I = replacedImage;
L = graythresh(I);                 % Threshold Level L
I(I>L-L/10*2 & I<L+L/10*1.5) = 1;  % Thresholding using the Level L
I = imbinarize(I);
figure('windowstate','maximized'), imshow(I), title('Thresholding the Image', 'fontsize', 18)

CC = bwconncomp(I);
n = CC.PixelIdxList;     % No. of Connected Components
num = 0;

for k=1:length(n)        % Iterating through all Connected Components
    temp = length(n{k}); % No. of pixels in the Connected Component
    if num<temp          % If Larger
        num = temp;      % number (num) updated
        obj = k;         % The 'no.' of connected component with largest no. of pixels
    end
end

a = n(obj);                                 % Indexing the Largest Connected Component
Largest_CC = bwareaopen(I,length(a{:,1}));  % Getting the length of the Largest Connected Component and filtering out the rest
figure('windowstate','maximized'), imshow(Largest_CC), title('Retaining only the Largest Connected Component', 'fontsize', 18)

se = strel('diamond',27);                   % Diamond Shaped Structuring Element (Disk can also be used)
Generated_Mask = imdilate(Largest_CC,se);   % Dilation Operation to fill dark regions in the Mask
figure('windowstate','maximized'), imshow(Generated_Mask), title('Dilating the Image - Generated Mask', 'fontsize', 18)


%% Calculating Jaccard Index and Dice Coefficient:

Given_Mask = imbinarize(imread('Given Mask.png'));

Jaccard_Index = jaccard(Generated_Mask,Given_Mask)
Dice_Coefficient = dice(Generated_Mask,Given_Mask)

figure('windowstate','maximized')
subplot 121, imshow(Generated_Mask), title('Generated Mask','fontsize',18);
subplot 122, imshow(Given_Mask), title('Given Mask','fontsize',18);
