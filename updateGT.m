function  updateGT( )
fnam='data/chaseDB/mat_files/GT/VGT/VGT_image_11R.mat';
whos('-file',fnam); % see what you have...
mv=load(fnam);

 mv.GT = [mv.GT;70,1];
% mv.GT = [mv.GT;99,1];
% mv.GT = [mv.GT;73,0];
% mv.GT = [mv.GT;93,0];
% mv.GT = [mv.GT;110,0];
% mv.GT = [mv.GT;27,0];
% mv.GT = [mv.GT;41,0];
% mv.GT = [mv.GT;52,0];

save(fnam,'-struct','mv'); % <- save each field of MV as a var
whos('-file',fnam);
end

