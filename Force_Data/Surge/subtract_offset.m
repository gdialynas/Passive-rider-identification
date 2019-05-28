function [y] = subtract_offset(interface_force_t1)

SP_X_scaled = NaN(size(interface_force_t1{1}));
SP_Y_scaled = NaN(size(interface_force_t1{2}));
SP_Z_scaled = NaN(size(interface_force_t1{3}));

FPL_X_scaled = NaN(size(interface_force_t1{4}));
FPL_Z_scaled = NaN(size(interface_force_t1{5}));

FPR_X_scaled = NaN(size(interface_force_t1{6}));
FPR_Z_scaled = NaN(size(interface_force_t1{7}));

HBL_X_scaled = NaN(size(interface_force_t1{8}));
HBL_Y_scaled = NaN(size(interface_force_t1{9}));
HBL_Z_scaled = NaN(size(interface_force_t1{10}));

HBR_X_scaled = NaN(size(interface_force_t1{11}));
HBR_Y_scaled = NaN(size(interface_force_t1{12}));
HBR_Z_scaled = NaN(size(interface_force_t1{13}));

for i = 1:24
    SP_X = interface_force_t1{1};
    SP_X_sub = SP_X(:,i);
    SP_X_scaled_sub = SP_X_sub - mean(SP_X_sub(1,1));
    SP_X_scaled(:,i) = SP_X_scaled_sub;
end    

for i = 1:24
    SP_Y = interface_force_t1{2};
    SP_Y_sub = SP_Y(:,i);
    SP_Y_scaled_sub = SP_Y_sub - mean(SP_Y_sub(1,1));
    SP_Y_scaled(:,i) = SP_Y_scaled_sub;
end 

for i = 1:24
    SP_Z = interface_force_t1{3};
    SP_Z_sub = SP_Z(:,i);
    SP_Z_scaled_sub = SP_Z_sub - mean(SP_Z_sub(1,1));
    SP_Z_scaled(:,i) = SP_Z_scaled_sub;
end 

for i = 1:24
    FPL_X = interface_force_t1{4};
    FPL_X_sub = FPL_X(:,i);
    FPL_X_scaled_sub = FPL_X_sub - mean(FPL_X_sub(1,1));
    FPL_X_scaled(:,i) = FPL_X_scaled_sub;
end 

for i = 1:24
    FPL_Z = interface_force_t1{5};
    FPL_Z_sub = FPL_Z(:,i);
    FPL_Z_scaled_sub = FPL_Z_sub - mean(FPL_Z_sub(1,1));
    FPL_Z_scaled(:,i) = FPL_Z_scaled_sub;
end 

for i = 1:24
    FPR_X = interface_force_t1{6};
    FPR_X_sub = FPR_X(:,i);
    FPR_X_scaled_sub = FPR_X_sub - mean(FPR_X_sub(1,1));
    FPR_X_scaled(:,i) = FPR_X_scaled_sub;
end 

for i = 1:24
    FPR_Z = interface_force_t1{7};
    FPR_Z_sub = FPR_Z(:,i);
    FPR_Z_scaled_sub = FPR_Z_sub - mean(FPR_Z_sub(1,1));
    FPR_Z_scaled(:,i) = FPR_Z_scaled_sub;
end 

for i = 1:24
    HBL_X = interface_force_t1{8};
    HBL_X_sub = HBL_X(:,i);
    HBL_X_scaled_sub = HBL_X_sub - mean(HBL_X_sub(1,1));
    HBL_X_scaled(:,i) = HBL_X_scaled_sub;
end    

for i = 1:24
    HBL_Y = interface_force_t1{9};
    HBL_Y_sub = HBL_Y(:,i);
    HBL_Y_scaled_sub = HBL_Y_sub - mean(HBL_Y_sub(1,1));
    HBL_Y_scaled(:,i) = HBL_Y_scaled_sub;
end 

for i = 1:24
    HBL_Z = interface_force_t1{10};
    HBL_Z_sub = HBL_Z(:,i);
    HBL_Z_scaled_sub = HBL_Z_sub - mean(HBL_Z_sub(1,1));
    HBL_Z_scaled(:,i) = HBL_Z_scaled_sub;
end 

for i = 1:24
    HBR_X = interface_force_t1{11};
    HBR_X_sub = HBR_X(:,i);
    HBR_X_scaled_sub = HBR_X_sub - mean(HBR_X_sub(1,1));
    HBR_X_scaled(:,i) = HBR_X_scaled_sub;
end    

for i = 1:24
    HBR_Y = interface_force_t1{12};
    HBR_Y_sub = HBR_Y(:,i);
    HBR_Y_scaled_sub = HBR_Y_sub - mean(HBR_Y_sub(1,1));
    HBR_Y_scaled(:,i) = HBR_Y_scaled_sub;
end 

for i = 1:24
    HBR_Z = interface_force_t1{13};
    HBR_Z_sub = HBR_Z(:,i);
    HBR_Z_scaled_sub = HBR_Z_sub - mean(HBR_Z_sub(1,1));
    HBR_Z_scaled(:,i) = HBR_Z_scaled_sub;
end 

y = {   SP_X_scaled, SP_Y_scaled, SP_Z_scaled,...
        FPL_X_scaled, FPL_Z_scaled,...
        FPR_X_scaled, FPR_Z_scaled,...
        HBL_X_scaled, HBL_Y_scaled, HBL_Z_scaled,...
        HBR_X_scaled, HBR_Y_scaled, HBR_Z_scaled};
        
        