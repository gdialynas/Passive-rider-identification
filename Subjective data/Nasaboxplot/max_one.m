function [x, y] = max_one(xd, yd)
[y, indexofy] = max(yd);
x = xd(indexofy);