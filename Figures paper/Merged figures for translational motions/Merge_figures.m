%%Load data files for Heave, Sway, Surge
load('Heave.mat')
load('Sway.mat')
load('Surge.mat')
%% Constants
N   = 6000;                     % number of samples
fs  = 100;                      % sample frequency 
dt  = 1/fs;                     % time step between two samples
T   = N * dt;                   % total observation time
fv  = (0:1/T:fs-(1/T))';        % frequency vector

indv_linewidth = 1;             % linewidth for plots of indv. subjects
mean_linewidth = 2;             % linewidth for plot of mean rider
wcoh_siglevel_linewidth = 1.5;  % linewidth for the significance coherence leven
wcoh_siglevel_linestyle = '--'; % dashed line for the significance coherence leven
fontsize = 16;                  % general fontsize of figures  

indv_color = [0.7 0.7 0.7];     % grey color for plots of indv. subjects 
x_color    = 'r';               % red color for plot mean rider x-direction
y_color    = 'g';               % green color for plot mean rider y-direction
z_color    = 'b';               % blue color for plot mean rider z-direction
wcoh_siglevel_color = 'k';

std_deci_acc    = 2;            % number of decimals for std in plots
t               = (0:N-1).'*dt; % time vector

x_ticks       = [0.17 0.5 1 2 4 8 12];  % numbers which are shown on the x-axes
x_lim         = [0.1667 12];            % x-axis limit for frequency range
y_ticks       = [0 0.2 0.4 0.6 0.8 1];  % numbers which are shown on the y-axes
x_ticks_shade = [0.17 0.5 1 2 4 8 12];
x_lim_shade   = [0.1667 12];            % x-axis limit for frequency range

y_lim       = [10^-4 10];       % y-axis limit for normalised gain

std_shadow = 0.15;               % tranparency STD shadow

%% Plot Gain, phase and coherence with std shade
figure('name','Gain, phase and coherence 24 subjects and mean rider')
%---------------------------------------------------------------------------Surge-------------------------------------------------------------------------------------------------------
subplot(3,3,1)
    wfv_surge(1,1)=0.1; % make first elements of frequency vector none zero to allow stdshade function to work
    stdshade(wtf_mag_UB_surge',std_shadow,x_color,wfv_surge,[]); hold on; grid on; box off
    xlim(x_lim_shade)
    xticks(x_ticks_shade) 
    ylabel('Gain [-]')
    set(gca, 'XScale', 'log','FontSize',fontsize)
    title('X-axis')

subplot(3,3,4) 
    stdshade(wtf_phase_UB_surge',std_shadow,x_color,wfv_surge,[]); hold on; grid on; box off
    xlim(x_lim_shade)
    xticks(x_ticks_shade)
    ylabel('Phase [deg]')
    set(gca, 'XScale', 'log','FontSize',fontsize) 
    
subplot(3,3,7)
    line([wfv_surge(1),wfv_surge(301)],[wcoh_siglevel_surge,wcoh_siglevel_surge], 'Color', wcoh_siglevel_color, 'linewidth', wcoh_siglevel_linewidth, 'LineStyle', wcoh_siglevel_linestyle);hold on; grid on; box off
    stdshade(wcoh_UB_surge',std_shadow,x_color,wfv_surge,[]); hold on; grid on; box off
    ylim([0 1])
    xlim(x_lim_shade)
    xticks(x_ticks_shade)
    ylim([0  1]);
    yticks(y_ticks)
    ylabel('Coherence[-]')
    xlabel('Frequency [Hz]');
    set(gca, 'XScale', 'log','FontSize',fontsize)
%----------------------------------------------------------------------------Sway---------------------------------------------------------------------------------------------
subplot(3,3,2)
    wfv_sway(1,1)=0.1; % make first elements of frequency vector none zero to allow stdshade function to work
    stdshade(wtf_mag_UB_sway',std_shadow,y_color,wfv_sway,[]); hold on; grid on; box off
    xlim(x_lim_shade)
    xticks(x_ticks_shade) 
    set(gca, 'XScale', 'log','FontSize',fontsize)
    xlabel('(a)')
    title('Y-axis')
subplot(3,3,5)
    stdshade(wtf_phase_UB_sway',std_shadow,y_color,wfv_sway,[]); hold on; grid on; box off
    xlim(x_lim_shade)
    xticks(x_ticks_shade)   
    set(gca, 'XScale', 'log','FontSize',fontsize)
    xlabel('(b)')
subplot(3,3,8)
    line([wfv_sway(1),wfv_sway(301)],[wcoh_siglevel_sway,wcoh_siglevel_sway], 'Color', wcoh_siglevel_color, 'linewidth', wcoh_siglevel_linewidth, 'LineStyle', wcoh_siglevel_linestyle);hold on; grid on; box off
    stdshade(wcoh_UB_sway',std_shadow,y_color,wfv_sway,[]); hold on; grid on; box off
    ylim([0 1])
    xlim(x_lim_shade)
    xticks(x_ticks_shade)
    ylim([0  1]);
    yticks(y_ticks)
    xlabel('Frequency [Hz]');
    set(gca, 'XScale', 'log','FontSize',fontsize)
    title('(c)','FontWeight','Normal', 'Units', 'normalized', 'Position', [0.5, -0.5, 0]); % Set Title with correct Position
    legend('CSL')
    
 %%---------------------------------------------------------------------------------Heave---------------------------------------------------------------------------------
 
 subplot(3,3,3)
    wfv_heave(1,1)=0.1; % make first elements of frequency vector none zero to allow stdshade function to work
    %hold on; grid on;
    stdshade(wtf_mag_UB_heave',std_shadow,z_color,wfv_heave,[]); hold on; grid on; box off
    xlim(x_lim_shade)
    xticks(x_ticks_shade) 
    set(gca, 'XScale', 'log','FontSize',fontsize)
     title('Z-axis')
subplot(3,3,6)
    stdshade(wtf_phase_UB_heave',std_shadow,z_color,wfv_heave,[]); hold on; grid on; box off
    xlim(x_lim_shade)
    xticks(x_ticks_shade)     
    %ylim([-180  180]);
    set(gca, 'XScale', 'log','FontSize',fontsize)
subplot(3,3,9)
    %hold on; grid on;
    line([wfv_heave(1),wfv_heave(301)],[wcoh_siglevel_heave,wcoh_siglevel_heave], 'Color', wcoh_siglevel_color, 'linewidth', wcoh_siglevel_linewidth, 'LineStyle', wcoh_siglevel_linestyle);hold on; grid on; box off
    stdshade(wcoh_UB_heave',std_shadow,z_color,wfv_heave,[]); 
    ylim([0 1])
    xlim(x_lim_shade)
    xticks(x_ticks_shade)
    ylim([0  1]);
    yticks(y_ticks)
    xlabel('Frequency [Hz]');
    set(gca, 'XScale', 'log','FontSize',fontsize)
 %% Plot Gain, phase and coherence with std shade
figure('name','Gain, phase and coherence 24 subjects and mean rider')
%---------------------------------------------------------------------------Surge-------------------------------------------------------------------------------------------------------
subplot(3,3,1)
    wfv_surge(1,1)=0.1; % make first elements of frequency vector none zero to allow stdshade function to work
    stdshade(wtf_mag_UB_surge',std_shadow,x_color,wfv_surge,[]); hold on; grid on; box off
    xlim(x_lim_shade)
    xticks(x_ticks_shade) 
    ylabel('{X-axis}')
    set(gca, 'XScale', 'log','FontSize',fontsize)
    title('Gain [-]')
subplot(3,3,2) 
    stdshade(wtf_phase_UB_surge',std_shadow,x_color,wfv_surge,[]); hold on; grid on; box off
    xlim(x_lim_shade)
    xticks(x_ticks_shade)
    set(gca, 'XScale', 'log','FontSize',fontsize)
    title('Phase [deg]')
subplot(3,3,3)
    line([wfv_surge(1),wfv_surge(301)],[wcoh_siglevel_surge,wcoh_siglevel_surge], 'Color', wcoh_siglevel_color, 'linewidth', wcoh_siglevel_linewidth, 'LineStyle', wcoh_siglevel_linestyle);hold on; grid on; box off
    stdshade(wcoh_UB_surge',std_shadow,x_color,wfv_surge,[]); hold on; grid on; box off
    ylim([0 1])
    xlim(x_lim_shade)
    xticks(x_ticks_shade)
    ylim([0  1]);
    yticks(y_ticks)
    set(gca, 'XScale', 'log','FontSize',fontsize)
    title('Coherence [-]')

%----------------------------------------------------------------------------Sway---------------------------------------------------------------------------------------------
subplot(3,3,4)
    wfv_sway(1,1)=0.1; % make first elements of frequency vector none zero to allow stdshade function to work
    stdshade(wtf_mag_UB_sway',std_shadow,y_color,wfv_sway,[]); hold on; grid on; box off
    xlim(x_lim_shade)
    xticks(x_ticks_shade) 
    ylabel('{X-axis}')
    set(gca, 'XScale', 'log','FontSize',fontsize)
    ylabel('{Y-axis}')
subplot(3,3,5)
    stdshade(wtf_phase_UB_sway',std_shadow,y_color,wfv_sway,[]); hold on; grid on; box off
    xlim(x_lim_shade)
    xticks(x_ticks_shade)   
    set(gca, 'XScale', 'log','FontSize',fontsize)
subplot(3,3,6)
    line([wfv_sway(1),wfv_sway(301)],[wcoh_siglevel_sway,wcoh_siglevel_sway], 'Color', wcoh_siglevel_color, 'linewidth', wcoh_siglevel_linewidth, 'LineStyle', wcoh_siglevel_linestyle);hold on; grid on; box off
    stdshade(wcoh_UB_sway',std_shadow,y_color,wfv_sway,[]); hold on; grid on; box off
    ylim([0 1])
    xlim(x_lim_shade)
    xticks(x_ticks_shade)
    ylim([0  1]);
    yticks(y_ticks)
    set(gca, 'XScale', 'log','FontSize',fontsize)
    legend('CSL')
 %---------------------------------------------------------------------------------Heave---------------------------------------------------------------------------------
 
 subplot(3,3,7)
    wfv_heave(1,1)=0.1; % make first elements of frequency vector none zero to allow stdshade function to work
    %hold on; grid on;
    stdshade(wtf_mag_UB_heave',std_shadow,z_color,wfv_heave,[]); hold on; grid on; box off
    xlim(x_lim_shade)
    xticks(x_ticks_shade) 
    set(gca, 'XScale', 'log','FontSize',fontsize)
    ylabel('{Z-axis}')
    xlabel('Frequency [Hz]');
    title('(a)','FontWeight','Normal', 'Units', 'normalized', 'Position', [0.5, -0.5, 0]); % Set Title with correct Position
subplot(3,3,8)
    stdshade(wtf_phase_UB_heave',std_shadow,z_color,wfv_heave,[]); hold on; grid on; box off
    xlim(x_lim_shade)
    xticks(x_ticks_shade)     
    %ylim([-180  180]);
    set(gca, 'XScale', 'log','FontSize',fontsize)
    xlabel('Frequency [Hz]');
    title('(b)','FontWeight','Normal', 'Units', 'normalized', 'Position', [0.5, -0.5, 0]); % Set Title with correct Position
subplot(3,3,9)
    %hold on; grid on;
    line([wfv_heave(1),wfv_heave(301)],[wcoh_siglevel_heave,wcoh_siglevel_heave], 'Color', wcoh_siglevel_color, 'linewidth', wcoh_siglevel_linewidth, 'LineStyle', wcoh_siglevel_linestyle);hold on; grid on; box off
    stdshade(wcoh_UB_heave',std_shadow,z_color,wfv_heave,[]); 
    ylim([0 1])
    xlim(x_lim_shade)
    xticks(x_ticks_shade)
    ylim([0  1]);
    yticks(y_ticks)
    xlabel('Frequency [Hz]');
    set(gca, 'XScale', 'log','FontSize',fontsize)
    title('(c)','FontWeight','Normal', 'Units', 'normalized', 'Position', [0.5, -0.5, 0]); % Set Title with correct Position
   
    


    

