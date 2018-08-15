
dd = zeros(size(varargin{1},1),4);%!
dd(:,4) = varargin{1}(:,6);%!
MFI = zeros(size(max(varargin{1}(:,6))));

% Step through all particles in the tracked data set
for (particleid=1:max(varargin{1}(:,6)))
    
    % Find the starting row of the particleid in trackdata
    % This is the offset
    index = find(varargin{1}(:,6)==particleid,1);
    
    % Find the number of frames for the particle
    % NOTE that this is NOT equivalent to time steps of 1 if the data has
    % "skipped frames"
    totalframe = sum(varargin{1}(:,6)==particleid);
       
    % Caluculate moved distance
    if totalframe >= 2
        
        r_len = 0;%!
        for j=1:totalframe-1
            r2 = (varargin{1}(index+j,1)-varargin{1}(index+j-1,1))^2 ...
                     + (varargin{1}(index+j,2)-varargin{1}(index+j-1,2))^2;
            r_len = r_len + sqrt(r2);%!
            dd(index+j,1) = sqrt(r2); 
            dd(index+j,3) = r_len;%!
            
            r2 = (varargin{1}(index+j,1)-varargin{1}(index,1))^2 ...
                     + (varargin{1}(index+j,2)-varargin{1}(index,2))^2;
            dd(index+j,2) = sqrt(r2);
        end
        
    end
    
    % Caluculate MFI
    MFI(particleid) = sum(varargin{1}(index:index+totalframe-1,3)) / totalframe;%! MFI(mean fluorescence intensity)
    dst_ratio = dd(index+totalframe-1,2) / dd(index+totalframe-1,3);%! The ratio of root and distance
    
    
    % graphical representation
    if ( totalframe > 10 && dd(index+totalframe-1,2)>0)
        
        
        %!       
        str1 = sprintf('   %s %-5d','ID:',varargin{1}(index,6));%! track ID
        str2 = sprintf('   %s %7.2f','MFI:',MFI);%! MFI(mean fluorescence intensity)
        str3 = sprintf('    %s %4.2f','dst ratio:',dst_ratio);%! MFI(mean fluorescence intensity)
        disp([str1, str2, str3])
        
        %!
       
        colormap(gray);
        imagesc(handles.axes1,varargin{2});%!
        axis image;
        hold on;
        title ('Particle Tracking','FontSize',14);
        plot(handles.axes1,varargin{1}(index,1),varargin{1}(index,2),'ro','MarkerSize',5,'LineWidth',1);
        hold off    
      
        plot(handles.axes2,0,0,'bo')%! initial coordinate
        axis equal
        axis([-15 15 -15 15])
        hold on
        plot(handles.axes2,varargin{1}(index+totalframe-1,1)-varargin{1}(index,1), ...
             varargin{1}(index+totalframe-1,2)-varargin{1}(index,2),'ro') % final coordinate
        plot(handles.axes2,varargin{1}(index:index+totalframe-1,1)-varargin{1}(index,1),...
             varargin{1}(index:index+totalframe-1,2)-varargin{1}(index,2),'-k.','MarkerSize',10)% traking line
        text(-5,-13,str3)%!
        title ({'Movement of prticle';'(NOTE: the data has "skipped frames")'},'FontSize',13)%!
        legend({'Initial Point','Final  Point'},'FontSize',8)%!
        hold off
    
        plot(handles.axes3,dd(index:index+totalframe-1,1:2))
        axis([0 60 0 20])
        title ({'Distance';'(NOTE: the data has "skipped frames")'},'FontSize',13)%!
        legend({'distance(bef\_frm to cur\_frm)','distance(1st\_frm to cur\_frm)'},'FontSize',8)%!
        xlabel('Frame')%!
        ylabel('distance [pixel]')%!
        
        yyaxis left
        plot(handles.axes4,varargin{1}(index:index+totalframe-1,3))%brightness
        axis([0 60 0 2500])
        ylabel('Fluorescence Intensity')%!
        yyaxis right
        plot(handles.axes4,dd(index:index+totalframe-1,3))%distance
        axis([0 60 0 50])
        text(40,5,str2)%! 
        title ({'fluorescence intensity';'(NOTE: the data has "skipped frames")'},'FontSize',13)%!
        xlabel('Frame')%!
        ylabel('Distance')%!
       
%        figure(13);
%        plot(varargin{1}(index:index+totalframe-1,4)); 
%        axis([0 60 0 10]);
       
%        pause(0.5);   
        
    end
end

MFI_all = sum(MFI) / max(varargin{1}(:,6));
str4 = sprintf('%s %-5d','MFI (all)',MFI_all);%! track ID
disp([str4])





