function preProcessed = preproc(img,mask)

    %RGB=imread('img.png');
    %G = RGB(:,:,2);
    %mask = calc_mask(RGB);
   % mask = uint8(mask);
    avMaskSize=69;
    preProcessed =  doPreProc( img, mask , avMaskSize)  ;
    preProcessed = im2double(preProcessed);
   figure,imshow(preProcessed , []);
end

function Ih =  doPreProc( img, mask , avMaskSize)    
    G = im2double(img); 
    
    Gf = fakepad( G , mask);

    h = fspecial('average' ,avMaskSize);
    BgEst = filter2(h,Gf);
   
    Is = im2double(Gf) - BgEst;
   
    Is = Is .* mask;
    Isu = to_uint8(Is);
    Isu(~mask) = 0;
   
    [count,p] = imhist(Isu);
    count(1) = [];
    [c , ind ]= max(count);

    c1 = (Isu==0);
    c2 = (Isu==255);

    Ih = Isu + (128 - ind);
    Ih = Ih .* uint8(mask);
    %Ih(c1) = 0;
    %Ih(c2) = 0;
end

function uImg = to_uint8(img)
    minVal = min(min(img));
    maxVal = max(max(img));
    uImg = uint8(255 * (img-minVal) / (maxVal - minVal));
end

function padded = fakepad(img, mask, erosionsize, iterations)
    % padded = fakepad(img, mask, erosionsize, iterations)
    %
    % Creates an artificial region in the area outside the
    % mask. "iterations" is the number of times a one-pixel border is
    % added to the image, i.e. the size of the padding created.

    %
    % Copyright (C) 2006  João Vitor Baldini Soares
    %
    % This program is free software; you can redistribute it and/or
    % modify it under the terms of the GNU General Public License
    % as published by the Free Software Foundation; either version 2
    % of the License, or (at your option) any later version.
    %
    % This program is distributed in the hope that it will be useful,
    % but WITHOUT ANY WARRANTY; without even the implied warranty of
    % MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    % GNU General Public License for more details.
    %
    % You should have received a copy of the GNU General Public License
    % along with this program; if not, write to the Free Software
    % Foundation, Inc., 51 Franklin Street, Fifth Floor,
    % Boston, MA 02110-1301, USA.
    %

    % Default parameters.
    if(nargin == 2)
      erosionsize = 5;
      iterations = 50;
    end

    % Contour before erosion
    [nrows, ncols] = size(mask);
    mask(1,:) =     zeros(1, ncols);
    mask(nrows,:) = zeros(1, ncols);
    mask(:,1) =     zeros(nrows, 1);
    mask(:,ncols) = zeros(nrows, 1);

    % Erodes the mask to avoid weird region near the border.
    mask = imerode(mask, strel('disk', erosionsize, 0));

    dilated = img .* double(mask);

    oldmask = mask;

    filter = [1 1 1; 
          1 1 1;
              1 1 1];
    [filterrows, filtercols] = find(filter > 0);
    filterrows = filterrows - 2;
    filtercols = filtercols - 2;

    for i = 1:iterations
      % finds pixels on the outer border
      newmask = imdilate(oldmask, strel('diamond', 1));
      outerborder = newmask & ~oldmask;

      [rows, cols] = find(outerborder);
      % grows into the outer border.
      for j = 1:size(cols, 1)
        col = cols(j);
        row = rows(j);

        filtered = [];
        for k = 1:size(filtercols, 1)
          filtercol = filtercols(k);
          filterrow = filterrows(k);

          pixelrow = row + filterrow;
          pixelcol = col + filtercol;
          if (pixelrow <= nrows & pixelrow >= 1 & pixelcol <= ncols & ...
              pixelcol >= 1 & oldmask(pixelrow, pixelcol))
            filtered = [filtered dilated(pixelrow, pixelcol)];
          end
        end
        % Mean of values under the filter.
        dilated(row, col) = sum(filtered)/length(filtered);
      end

      oldmask = newmask;
    end

    padded = dilated;
end

