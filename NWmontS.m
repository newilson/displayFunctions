function mont = NWmontS(S)

si = size(S);
if length(si)==3, si(4) = 1; end

mont = permute(S,[1 3 2 4]);
mont = reshape(mont,[(si(1)*si(3)),(si(2)*si(4))]);
