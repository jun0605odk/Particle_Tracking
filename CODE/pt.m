% Particle_tracking

clear

%%%%%%% Parameters to be set %%%%%%%

% File name for image
filename = 'Wt Abp1-mCH(250ms).tif';
% filename = 'Mutant Abp1-mCH(250ms).tif';

% For bpass.m and pkfnd.m 
lnoise = 0;  %  Characteristic lengthscale of noise in pixels.
             %  Additive noise averaged over this length should
             %  vanish. May assume any positive floating value.
             %  May be set to 0 or false, in which case only the
             %  highpass "background subtraction" operation is 
             %  performed.
lobject = 9; %  Expected size of the particle (diameter)
             %  Integer length in pixels somewhat 
             %  larger than a typical object. Can also be set to 
             %  0 or false, in which case only the lowpass 
             %  "blurring" operation defined by lnoise is done,
             %  without the background subtraction defined by
             %  lobject.  Defaults to false.
threshold = 30; %  By default, after the convolution,
               %  any negative pixels are reset to 0.  Threshold
               %  changes the threshhold for setting pixels to
               %  0.  Positive values may be useful for removing
               %  stray noise or small particles.  Alternatively, can
               %  be set to -Inf so that no threshholding is
               %  performed at all.

% For pkfact.m
thfactor = 0.0; % Find locations of the brightest pixels Need to change the
                % threshold argument to something that is specified or determined.
                % This parameter is a factor multipied by  the brightest
                % pixels. A rough guide is to accept 60-70% of the brightest
                % pixels.

% For track.m
maxdisp = 5;  %  an estimate of the maximum distance that a particle 
              %  would move in a single time interval.

p_mem = 0;
p_dim = 2;
p_good = 0;
p_quiet = 1;               
% ;         param.mem: this is the number of time steps that a particle can be
% ;             'lost' and then recovered again.  If the particle reappears
% ;             after this number of frames has elapsed, it will be
% ;             tracked as a new particle. The default setting is zero.
% ;             this is useful if particles occasionally 'drop out' of
% ;             the data.
% ;         param.dim: if the user would like to unscramble non-coordinate data
% ;             for the particles (e.g. apparent radius of gyration for
% ;             the particle images), then positionlist should
% ;             contain the position data in positionlist(0:param.dim-1,*)
% ;             and the extra data in positionlist(param.dim:d-1,*). It is then
% ;             necessary to set dim equal to the dimensionality of the
% ;             coordinate data to so that the track knows to ignore the
% ;             non-coordinate data in the construction of the 
% ;             trajectories. The default value is two.
% ;         param.good: set this keyword to eliminate all trajectories with
% ;             fewer than param.good valid positions.  This is useful
% ;             for eliminating very short, mostly 'lost' trajectories
% ;             due to blinking 'noise' particles in the data stream.
%;          param.quiet: set this keyword to 1 if you don't want any tex             

% trimming   on=1 off=0
trimming = 1; 


% Check parameters
if mod(lobject,2) == 0
    warning('lobject size must be an odd value');
    out=[];
    return;
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Read image file
info = imfinfo(filename);
num_images = numel(info);

% Check BitsPerSamples
if ( num_images > 1 ) 
    for k=1:num_images-1
        if ( info(k).BitsPerSample ~= info(k+1).BitsPerSample)
            warning('BitsPerSample is different between images')%!
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
    figure(1);
% 	imagesc(I(1:400,1:400,frame)); colormap(gray);
%   subplot(2,2,1)%!
    imagesc(I(:,:,frame)); colormap(gray);
    title ('Image','FontSize',16)
    axis image;
%     figure(7);
%     histogram(I(:,:,frame));
%     axis([0 300 0 200000]);
 	%pause(0.01); 
end

%! trimming
if trimming == 1
    
    figure(6)
    imagesc(I(:,:,1)); colormap(gray);
    axis image;
    
    
    [I_trim, rect] = imcrop;
    I_org = I;
    I = zeros(int16(rect(4)),int16(rect(3)),num_images);
   
    for frame = 1:num_images
        
        [I_trim, rect] = imcrop(I_org(:,:,frame),[rect(1),rect(2),rect(3),rect(4)]);
  %      imagesc(I(rect(2):rect(2)+rect(4),rect(1):rect(1)+rect(3),frame))
        I(:,:,frame) = I_trim(:,:);
        figure(5)
        %imagesc(I_trim)
        imagesc(I(:,:,frame))
        colormap(gray)
        title ('trimming','FontSize',16)
        axis image
 %       pause(0.5); 
    end
end

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
%   figure(1);%!
%   subplot(2,2,2)%!
    figure(2)
    colormap(gray);
    imagesc(I(:,:,frame));%!
    %    imagesc(I(1:400,1:400,frame));
    axis image;
    hold on;
    title ('Particle Tracking','FontSize',14);
    plot(pk(:,1),pk(:,2),'go','MarkerSize',5,'LineWidth',1);  %!circle
    plot(cnt(:,1),cnt(:,2),'y.');                             %!point
    hold off    
    pause(0.01); 
    
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

% figure(1)%!
% subplot(2,2,3);%!
figure(3)
h = histogram(traj_length(:,2), max(traj_length(:,2)));
title ('frequency','FontSize',16);
xlabel('The number of frames');
ylabel('frequency');
% Trajectory analysis
msd = MSD(traj,10,60,0,35);
msd = [zeros(1,3);msd];
dlmwrite('msd.csv' ,msd);

ft = fittype('4*D*x^alpha');
f = fit(msd(:,1),msd(:,2),ft,'StartPoint',[msd(2,2)/4,1],...
        'Weights',sqrt(msd(:,3)),'Exclude',msd(:,1)>15)
    
% figure(1);
% subplot(2,2,4);
figure(4)
plot(f,msd(:,1),msd(:,2));
title ('MSD','FontSize',14);
xlabel('Time');
ylabel('MSD');
% figure(5);
% loglog(msd(:,1),msd(:,2:3));

dd = MSD_3(traj,I(:,:,1));
histogram(dd(:,1));
