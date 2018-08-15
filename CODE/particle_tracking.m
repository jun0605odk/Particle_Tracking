% Particle_tracking

clear all;
% close all;

%********** Parameters to be set **********
% % File name for image
% filename = 'Wt Abp1-mCH(250ms).tif';
% % filename = 'Mutant Abp1-mCH(250ms).tif';
% 
% % trimming   on=1 off=0
% trimming = 0; 
% 
% %unit conversion
% unit_time    = 1;    %s
% unit_length  = 64.5; %nm
% 
% 
% % Display on off
% disp_org_im   = 1;
% disp_trim_im  = 1;
% disp_track_im = 1;
% disp_freq     = 1;
% disp_msd      = 1;
% disp_msd_log  = 1;
% disp_move     = 1;
% 
% % For MSD.m 
% MSD_lenlower = 10;  %  Lower limit of trajectry length to be analyzed.
% MSD_lenupper = 60;  %  Upper limit of trajectry length to be analyzed.
% MSD_ts       = 0;   %  Start time point to be calculated for MSD.
% MSD_te       = 35;  %  End time point to be calculated for MSD.
% 
% % For bpass.m and pkfnd.m 
% lnoise     = 0; %  Characteristic lengthscale of noise in pixels.
%                 %  Additive noise averaged over this length should
%                 %  vanish. May assume any positive floating value.
%                 %  May be set to 0 or false, in which case only the
%                 %  highpass "background subtraction" operation is 
%                 %  performed.
%                 
% lobject    = 9; %  Expected size of the particle (diameter)
%                 %  Integer length in pixels somewhat 
%                 %  larger than a typical object. Can also be set to 
%                 %  0 or false, in which case only the lowpass 
%                 %  "blurring" operation defined by lnoise is done,
%                 %  without the background subtraction defined by
%                 %  lobject.  Defaults to false.
%                 
% threshold = 30; %  By default, after the convolution,
%                 %  any negative pixels are reset to 0.  Threshold
%                 %  changes the threshhold for setting pixels to
%                 %  0.  Positive values may be useful for removing
%                 %  stray noise or small particles.  Alternatively, can
%                 %  be set to -Inf so that no threshholding is
%                 %  performed at all.
% 
% % For pkfact.m
% thfactor = 0.0; % Find locations of the brightest pixels Need to change the
%                 % threshold argument to something that is specified or determined.
%                 % This parameter is a factor multipied by  the brightest
%                 % pixels. A rough guide is to accept 60-70% of the brightest
%                 % pixels.
% 
% % For track.m
% maxdisp = 5;    %  an estimate of the maximum distance that a particle 
%                 %  would move in a single time interval.
% 
% p_mem   = 0;    %  this is the number of time steps that a particle can be
%                 %  'lost' and then recovered again.  If the particle reappears
%                 %  after this number of frames has elapsed, it will be
%                 %  tracked as a new particle. The default setting is zero.
%                 %  this is useful if particles occasionally 'drop out' of
%                 %  the data.
%                 
% p_dim   = 2;    %  if the user would like to unscramble non-coordinate data
%                 %  for the particles (e.g. apparent radius of gyration for
%                 %  the particle images), then positionlist should
%                 %  contain the position data in positionlist(0:param.dim-1,*)
%                 %  and the extra data in positionlist(param.dim:d-1,*). It is then
%                 %  necessary to set dim equal to the dimensionality of the
%                 %  coordinate data to so that the track knows to ignore the
%                 %  non-coordinate data in the construction of the 
%                 %  trajectories. The default value is two.
%                 
% p_good  = 0;    %  set this keyword to eliminate all trajectories with
%                 %  fewer than param.good valid positions.  This is useful
%                 %  for eliminating very short, mostly 'lost' trajectories
%                 %  due to blinking 'noise' particles in the data stream.
% 
% p_quiet = 1;    %  set this keyword to 1 if you don't want any tex 

% %Set parameters by GUIDE 
GUIDE_for_pt

% change unit
unit = [];
unit(1) = unit_time;   %s  -> s
unit(2) = unit_length*(10^-3); %nm -> μm

%****************************************


% Read image file
info = imfinfo(filename);
num_images = numel(info);

% Check parameters
if mod(lobject,2) == 0
    warning('Parameter error!');
    warning('lobject size must be an odd value');
    return;
end
if num_images < MSD_lenupper
    warning('Parameter error!');
    warning('"Flame length lenupper" exceeds maximum number of frame');
    warning(['Please set "Flame length lenupper" to ', num2str(num_images), ' or less'])
    return;
end

% Check BitsPerSamples
if ( num_images > 1 ) 
    for k=1:num_images-1
        if ( info(k).BitsPerSample ~= info(k+1).BitsPerSample)
            warning('BitsPerSample is different between images')
        end
    end
end

for frame = 1:num_images
    if ( info(k).BitsPerSample == 8 )
        I(:,:,frame) = uint8(imread(filename, frame, 'Info', info));
    elseif (info(k).BitsPerSample == 16 )
        I(:,:,frame) = uint16(imread(filename, frame, 'Info', info));
    elseif (info(k).BitsPerSample == 32 )
        I(:,:,frame) = uint32(imread(filename, frame, 'Info', info));
    end    
    
    %For check input movie
    if disp_org_im==1
        figure(1);
        imagesc(I(:,:,frame)); colormap(gray);
        title (['Original Image', '  (frame:', num2str(frame,'%3d'), ')'],...
                'FontSize',16)
        axis image;
        %pause(0.01); 
    end
end


%**********trimming**********
if trimming == 1
    
    I_trim = {};
    I_trim_save = {};
    c = 0;
    I_org = I;
    
    while 1
        
        c = c+1;
        
        % Specify the image range
        ax = figure(6);
        imagesc(I(:,:,1)); colormap(gray);
        if c>=2
            hold on;
            for i=1:c-1
                rectangle('Position',[rect{i}(1),rect{i}(2),...
                          rect{i}(3), rect{i}(4)],'EdgeColor','r')
            end
            hold off;
        end
        title ({'Specify the image range to be trimmed with the mouse.';...
            'and right click on the trimming image.'},'FontSize',13)
        axis image;
        [I_trim{c}, rect{c}] = imcrop;
        close;

        % trimming
        I_trim_save{c} = I_trim{c}; %decide size of I_trim_save
        I_trim_save{c} = zeros(int16(rect{c}(4)),int16(rect{c}(3)),num_images);
        for frame = 1:num_images
            [I_trim_save{c}(:,:,frame), rect{c}] = imcrop(I(:,:,frame),...
                                    [rect{c}(1),rect{c}(2),rect{c}(3),rect{c}(4)]);
            %display
            if disp_trim_im==1
                figure(5)
                imagesc(I_trim_save{c}(:,:,frame));colormap(gray);
                title (['Trimming Image', '  (frame:', num2str(frame), ')'],...
                        'FontSize',16)
                axis image
                % pause(0.2);
            end
            
        end
        
        flag = pt_GUIDE_pop_trim;
        if flag==0
            c_max = c;
            break
        end
        
    end
    
    I(:,:,:) = I(:,:,:).*0.+mean2(I(:,:,1));
    % I(:,:,frame) = I(:,:,frame).*0.+mean2(I(:,:,frame));
    for c = 1:c_max
        for frame = 1:num_images
            I(int16(rect{c}(2)):int16(rect{c}(2))+int16(rect{c}(4)-1),...
              int16(rect{c}(1)):int16(rect{c}(1))+int16(rect{c}(3)-1),...
              frame)...
            = I_trim_save{c}(:,:,frame);
        end
    end
    
end
%****************************


% Find locations of particles
pos_lst=[];
for frame=1:num_images
    
    if mod(frame,10)==0
        disp(['Frame number: ' num2str(frame)]);
    end   
    
    % Bandpass filter
%    Ib = bpass(I(1:400,1:400,frame),lnoise,lobject,threshold); 
    Ib = bpass(I(:,:,frame),lnoise,lobject,threshold); 
%     figure(8);
%     histogram(Ib);
%     axis([0 160 0 200]);
%  	pause(0.1);
    
    % Find locations of the brightest pixels Need to change the 'th'
    % (threshold) argument to something that is specified or determined.
    % A rough guide is to accept 60-70% of the brightest pixels 
    th = max(Ib(:))*thfactor;
    pk = pkfnd(Ib,th,lobject);
    
    % Refine location estimates using centroid
    cnt = cntrd(Ib,pk,lobject+2);
    
    % cntrd can also accept "interactive" mode
    % cnt = cntrd(Ib, pk, lobject+2, 1);
    
    % Add frame number to tracking data
    cnt(:,5) = frame;
    
    % You can also add pk to cnt to check if
    % corrections are greater than one pixel.
    %     cnt = [pk(:,2), cnt];
    %     cnt = [pk(:,1), cnt];
    
    % Concatenate the new frame to the existing data
    pos_lst = [pos_lst, cnt'];

    % Code that can be used to make images to monitor tracking
    % Uncomment to use
    if disp_track_im==1
        figure(2)
        colormap(gray);
        imagesc(I(:,:,frame));%!
        axis image;
        hold on
        title (['Particle Tracking', '  (frame:', num2str(frame), ')'],...
                'FontSize',16)
        plot(pk(:,1),pk(:,2),'go','MarkerSize',5,'LineWidth',1);  %!circle
        plot(cnt(:,1),cnt(:,2),'y.');                             %!point
        hold off    
        pause(0.2); 
    end
    
end

% Format the position list so that we have five columns: ...
% x, y, brightnesses, sqare of the radius of gyration, frame
pos_lst = pos_lst';
dlmwrite('position_list.csv',pos_lst);


% Creating particle trajectories
% Format of traj: x, y, brightnesses, sqare of the radius of gyration,
%                 frame, particle ID
param = struct('mem',p_mem,'good',p_good,'dim',p_dim,'quiet',p_quiet);
traj = track(pos_lst,maxdisp,param);
dlmwrite('traj.csv',traj);
traj_length = tabulate(traj(:,6));


if disp_freq==1
    figure(3)
    h = histogram(traj_length(:,2), max(traj_length(:,2)));
    title ('frequency','FontSize',16);
    xlabel('The number of frames');
    ylabel('frequency');
end

% Trajectory analysis
msd = MSD(traj,unit,MSD_lenlower,MSD_lenupper,MSD_ts,MSD_te);
msd = [zeros(1,3);msd];
dlmwrite('msd.csv' ,msd);


ft = fittype('4*D*x^alpha');% name
f = fit(msd(:,1),msd(:,2),ft,'StartPoint',[msd(2,2)/4,1],...
        'Weights',sqrt(msd(:,3)),'Exclude',msd(:,1)>15)
disp(' ')
if disp_msd==1
    figure(4)
    plot(f,msd(:,1)*unit(1),msd(:,2));
    title ('MSD','FontSize',14);
    xlabel('Time[s]');%!!!!!! include skiped frame?
    ylabel('MSD[μm^2]'); 
end

% y = 2*msd(:,1) + 7*log(msd(:,1));
%ft = fittype('a*msd(:,1) + b*log(c)',...
%             'independent', {'msd(:,1)'},'coefficients',{'a','b','c'});
ft = fittype('a*x+b');
f = fit(log(msd(:,1)),log(msd(:,2)),ft,'StartPoint',[msd(2,2)/4,1],'Exclude',msd(:,1)==0)
disp(' ')
if disp_msd_log==1
    figure(5)
    plot(f);
    hold on;
    loglog(msd(:,1)*unit(1),msd(:,2));
    title ('log(MSD)','FontSize',14);
    xlabel('log(Time)');
    ylabel('log(MSD)');
    hold off;
end



dd = MSD_4(traj,unit,I(:,:,1),disp_move);
%dd = pt_GUIDE_figure(traj,I(:,:,1));
dlmwrite('dd.csv',dd);
% figure(8);
% histogram(dd(:,1));

