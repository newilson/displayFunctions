function vox = NWmont2vox(mont,nrows)
%
% mont is the pixel location in the montage image in [row,column]
% nrows is the number of rows in the 3D image (phase encodes)

if nargin<2, nrows = 16; end

col = mont(2); montrow = mont(1);

col = mod(col,nrows); % assumes ncols = nrows in 3D image

row = mod(montrow,nrows);
sl = ceil(montrow/nrows);

vox = [row,col,sl];
