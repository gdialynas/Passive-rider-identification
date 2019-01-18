function [SP_X, SP_Y, SP_Z, FPL_X, FPL_Z, FPR_X, FPR_Z, HBL_X, HBL_Y, HBL_Z, HBR_X, HBR_Y, HBR_Z] = extract_individual_interface_forces(u)

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
count2 = 2; 
count3 = 3; 
count4 = 4; 
count5 = 5; 
count6 = 6; 
count7 = 7; 
count8 = 8; 
count9 = 9; 
count10 = 10; 
count11 = 11; 
count12 = 12; 
count13 = 13; 

for col = 1:24
    sub = u(:,count1);
    SP_X(:,col)  = sub;
    count1 = count1+13;
end

for col = 1:24
    sub = u(:,count3);
    SP_Y(:,col)  = sub;
    count3 = count3+13;
end

for col = 1:24
    sub = u(:,count2);
    SP_Z(:,col)  = sub;
    count2 = count2+13;
end

for col = 1:24
    sub = u(:,count4);
    FPL_X(:,col)  = sub;
    count4 = count4+13;
end

for col = 1:24
    sub = u(:,count5);
    FPL_Z(:,col)  = sub;
    count5 = count5+13;
end

for col = 1:24
    sub = u(:,count6);
    FPR_X(:,col)  = sub;
    count6 = count6+13;
end

for col = 1:24
    sub = u(:,count7);
    FPR_Z(:,col)  = sub;
    count7 = count7+13;
end

for col = 1:24
    sub = u(:,count8);
    HBL_X(:,col)  = sub;
    count8 = count8+13;
end

for col = 1:24
    sub = u(:,count10);
    HBL_Y(:,col)  = sub;
    count10 = count10+13;
end

for col = 1:24
    sub = u(:,count9);
    HBL_Z(:,col)  = sub;
    count9 = count9+13;
end

for col = 1:24
    sub = u(:,count12);
    HBR_X(:,col)  = sub;
    count12 = count12+13;
end

for col = 1:24
    sub = u(:,count13);
    HBR_Y(:,col)  = sub;
    count13 = count13+13;
end

for col = 1:24
    sub = u(:,count11);
    HBR_Z(:,col)  = sub;
    count11 = count11+13;
end
