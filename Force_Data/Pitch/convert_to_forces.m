%function [SP_X, SP_Y, SP_Z, FPL_X, FPL_Z, FPR_X, FPR_Z, HBL_X, HBL_Y, HBL_Z, HBR_X, HBR_Y, HBR_Z] = convert_to_forces(u)
function [y] = convert_to_forces(u)

u             = cell2mat(u);

SP_X          = NaN(length(u),24);
SP_Y          = NaN(length(u),24);
SP_Z          = NaN(length(u),24);

FPL_X         = NaN(length(u),24);
FPL_Z         = NaN(length(u),24);

FPR_X         = NaN(length(u),24);
FPR_Z         = NaN(length(u),24);

HBL_X         = NaN(length(u),24);
HBL_Y         = NaN(length(u),24);
HBL_Z         = NaN(length(u),24);

HBR_X         = NaN(length(u),24);
HBR_Y         = NaN(length(u),24);
HBR_Z         = NaN(length(u),24);

count1 = 1; 
count2 = 25; 
count3 = 49; 
count4 = 73; 
count5 = 97; 
count6 = 121; 
count7 = 145; 
count8 = 169; 
count9 = 193; 
count10 = 217; 
count11 = 241; 
count12 = 265; 
count13 = 289; 

for col = 1:24
    sub = u(:,count1);
    SP_X(:,col)  = 59.861.*sub-1.426;
    count1 = count1+1;
end

for col = 1:24
    sub = u(:,count2);
    SP_Y(:,col)  = 38.842.*sub+18.909;
    count2 = count2+1;
end

for col = 1:24
    sub = u(:,count3);
    SP_Z(:,col)  = 314.64.*sub-6.7404;
    count3 = count3+1;
end

for col = 1:24
    sub = u(:,count4);
    FPL_X(:,col)  = 42.298.*sub+0.0009;
    count4 = count4+1;
end

for col = 1:24
    sub = u(:,count5);
    FPL_Z(:,col)  = 41.414.*sub+0.2628;
    count5 = count5+1;
end

for col = 1:24
    sub = u(:,count6);
    FPR_X(:,col)  = 42.4.*sub+0.0324;
    count6 = count6+1;
end

for col = 1:24
    sub = u(:,count7);
    FPR_Z(:,col)  = 41.604.*sub+0.6129;
    count7 = count7+1;
end

for col = 1:24
    sub = u(:,count8);
    HBL_X(:,col)  = 22.996.*sub-0.4607;
    count8 = count8+1;
end

for col = 1:24
    sub = u(:,count9);
    HBL_Y(:,col)  = 454.8.*sub-16.278;
    %HBL_Y(:,col)  = 45.48.*sub-16.278;
    count9 = count9+1;
end

for col = 1:24
    sub = u(:,count10);
    HBL_Z(:,col)  = 23.034.*sub-0.5227;
    count10 = count10+1;
end

for col = 1:24
    sub = u(:,count11);
    HBR_X(:,col)  = 24.693.*sub-0.6072;
    count11 = count11+1;
end

for col = 1:24
    sub = u(:,count12);
    HBR_Y(:,col)  = 382.65.*sub-0.2251;
    count12 = count12+1;
end

for col = 1:24
    sub = u(:,count13);
    HBR_Z(:,col)  = 24.806.*sub-0.6285;
    count13 = count13+1;
end

y =     {   SP_X, SP_Y, SP_Z,...
            FPL_X, FPL_Z,... 
            FPR_X, FPR_Z,...
            HBL_X, HBL_Y, HBL_Z,... 
            HBR_X, HBR_Y, HBR_Z};