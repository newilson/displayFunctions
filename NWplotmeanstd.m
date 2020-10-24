function [Mmean, Mstd] = NWplotmeanstd(M,meandim,plt)
%
% M is an n dimensional matrix
% meandim is the dimension in which the averaging starts
% dimensions before meandim are untouched
%

if nargin<3, plt = false; end

si = size(M);

sivec = si(1:meandim-1);
sivec(meandim) = numel(M)/prod(sivec);
M = reshape(M,sivec);

Mmean = mean(M,meandim);
Mstd = std(M,0,meandim);

if plt
    figure
    boundedline(1:si(1),Mmean(:,1),Mstd(:,1),'b','alpha')
end
    