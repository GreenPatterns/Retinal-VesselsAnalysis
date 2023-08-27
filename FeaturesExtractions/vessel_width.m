function thickness = vessel_width(BW)

%// Find all unique contours and assign them a unique ID.  Also determine how many there are
[lbl,N] = bwlabel(BW);
%// Initialize an array that determines the thickness of each stroke
thickness = [];
%// Tolerance to collect distances
tol = 1;

%// For each stroke...
for idx = 1 : N
    %// Step #1
    cntr = lbl == idx; %// Get a mask that segments out that stroke only
    d = bwdist(~cntr); %// Find distance transform on inverse
    %// Step #2
    max_dist = max(d(:)); %// Get the maximum distance from stroke to edge
    dists = d(abs(d - max_dist) <= tol); %// Collect those distances within a tolerance   
    maxDiameter  = 2 * max_dist;
    meanDiameter = 2 * mean(dists);
    thickness = [thickness;maxDiameter,meanDiameter];
%     [x, y] = find(d == max_dist);
    
end
end
