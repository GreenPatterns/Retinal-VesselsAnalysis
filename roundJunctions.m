function [ roundV ] = roundJunctions( V )
%ROUNDJUNCTIONS Summary of this function goes here
%   Detailed explanation goes here

roundV = unique(round(V), 'rows', 'stable');
end

