clc;    % Clear the command window.
close all;  % Close all figures (except those of imtool.)
clear;  % Erase all existing variables.
workspace;  % Make sure the workspace panel is showing.
format long g;
format compact;
fontSize = 20;


%===============================================================================


[t1] = im2bw(imread('test.bmp'));
[t2] = im2bw(imread('test2.png'));
[s1] = im2bw(imread('sample.png'));
[binaryImage] = im2bw(imread('sample2.png'));
% Find max width, and what row it occurs on.

figure, subplot(2,2,1)
imshow(binaryImage);
axis on;
title('Binary Image, Image Analyst Method', 'FontSize', fontSize, 'Interpreter', 'None');
[maxWidth, rowOfMaxWidth] = max(sum(binaryImage, 2));
col1 = find(binaryImage(rowOfMaxWidth, :), 1, 'first');
col2 = find(binaryImage(rowOfMaxWidth, :), 1, 'last');
% Draw red line from col1 to col2 at row "rowOfMaxWidth".
line([col1, col2], [rowOfMaxWidth, rowOfMaxWidth], 'Color', 'r', 'LineWidth', 2);
fprintf('Image Analyst Method 2:\n    image width of %d occurs at row %d\n    between column %d and %d.\n', ...
	maxWidth, rowOfMaxWidth, col1, col2);

subplot(2,2,2)
imshow(t1);
axis on;
title('Binary Image, Image Analyst Method', 'FontSize', fontSize, 'Interpreter', 'None');
[maxWidth, rowOfMaxWidth] = max(sum(t1, 2));
col1 = find(t1(rowOfMaxWidth, :), 1, 'first');
col2 = find(t1(rowOfMaxWidth, :), 1, 'last');
% Draw red line from col1 to col2 at row "rowOfMaxWidth".
line([col1, col2], [rowOfMaxWidth, rowOfMaxWidth], 'Color', 'r', 'LineWidth', 2);

subplot(2,2,3)
imshow(s1);
axis on;
title('Binary Image, Image Analyst Method', 'FontSize', fontSize, 'Interpreter', 'None');
[maxWidth, rowOfMaxWidth] = max(sum(s1, 2));
col1 = find(s1(rowOfMaxWidth, :), 1, 'first');
col2 = find(s1(rowOfMaxWidth, :), 1, 'last');
% Draw red line from col1 to col2 at row "rowOfMaxWidth".
line([col1, col2], [rowOfMaxWidth, rowOfMaxWidth], 'Color', 'r', 'LineWidth', 2);

subplot(2,2,4)
imshow(t2);
axis on;
title('Binary Image, Image Analyst Method', 'FontSize', fontSize, 'Interpreter', 'None');
[maxWidth, rowOfMaxWidth] = max(sum(t2, 2));
col1 = find(t2(rowOfMaxWidth, :), 1, 'first');
col2 = find(t2(rowOfMaxWidth, :), 1, 'last');
% Draw red line from col1 to col2 at row "rowOfMaxWidth".
line([col1, col2], [rowOfMaxWidth, rowOfMaxWidth], 'Color', 'r', 'LineWidth', 2);
