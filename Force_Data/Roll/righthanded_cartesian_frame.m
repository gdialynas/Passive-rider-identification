function [y] = righthanded_cartesian_frame(u)

u_force_SP_X = u{1}.*-1;
u_force_SP_Y = u{2};
u_force_SP_Z = u{3}.*-1;

u_force_FPL_X = u{4}.*-1;
u_force_FPL_Z = u{5};

u_force_FPR_X = u{6};
u_force_FPR_Z = u{7};

u_force_HBL_X = u{8}.*-1;
u_force_HBL_Y = u{9}.*-1;
u_force_HBL_Z = u{10}.*-1;

u_force_HBR_X = u{11};
u_force_HBR_Y = u{12};
u_force_HBR_Z = u{13};

y = {    u_force_SP_X, u_force_SP_Y, u_force_SP_Z,...
         u_force_FPL_X, u_force_FPL_Z,...
         u_force_FPR_X, u_force_FPR_Z,...
         u_force_HBL_X, u_force_HBL_Y, u_force_HBL_Z,...
         u_force_HBR_X, u_force_HBR_Y, u_force_HBR_Z};
                  
