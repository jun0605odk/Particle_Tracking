% GUIDE_for_pt

ini_val_data = textscan(fopen('ini_val.txt'),...
              '%s %s %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %d',...
              'Delimiter','\n');
input = {};
% input{1} = 0;
% input{2} = 0;
%number
for i=1:17
    input{1}(i) = ini_val_data{i+2};
end
%string
for i=1:2
    input{2}{i} = ini_val_data{i}{1};
end


ini_val = [];
if (size(input{2},2)==2) & (size(input{1},2)==17)
    change_ini = pt_GUIDE_pop;
else
    warning('ini_val.txt file is broken or not found!!!')
    warning('Can not read initial value!!!')
    change_ini = 1;
end


if change_ini == 1
    handles = pt_GUIDE_value(input{:});
    % input value
    filename     = handles.filename;
    trimming     = handles.trimming; 
    lnoise       = handles.lnoise; 
    lobject      = handles.lobject;
    threshold    = handles.threshold; 
    thfactor     = handles.thfactor;
    maxdisp      = handles.maxdisp; 
    p_mem        = handles.p_mem; 
    p_dim        = handles.p_dim; 
    p_good       = handles.p_good; 
    p_quiet      = handles.p_quiet;
    MSD_lenlower = handles.frame_lenlower;
    MSD_lenupper = handles.frame_lenupper;
    MSD_ts       = handles.ts;
    MSD_te       = handles.te;
    unit_time    = handles.unit_time;
    unit_length  = handles.unit_length;
    pathname     = handles.pathname;
    
    %****display fugure setting***    
    disp_org_im   = 0;
    disp_trim_im  = 0;
    disp_track_im = 0;
    disp_freq     = 0;
    disp_msd      = 0;
    disp_msd_log  = 0;
    disp_move     = 0;
    display_num_str = num2str(handles.display);
    if display_num_str(9) == '1'
        disp_org_im   = 1;
    end
    if display_num_str(8) == '1'
        disp_trim_im   = 1;
    end
    if display_num_str(7) == '1'
        disp_track_im   = 1;
    end
    if display_num_str(6) == '1'
        disp_freq   = 1;
    end
    if display_num_str(5) == '1'
        disp_msd   = 1;
    end
    if display_num_str(4) == '1'
        disp_msd_log   = 1;
    end
    if display_num_str(3) == '1'
        disp_move  = 1;
    end
    %*****************************
    
    cd(handles.cur_path)
    
    %save parameter
    if handles.save == 1

        disp('parameters were saved ')
        ini_val(1)  = handles.trimming; 
        ini_val(2)  = handles.lnoise; 
        ini_val(3)  = handles.lobject;
        ini_val(4)  = handles.threshold; 
        ini_val(5)  = handles.thfactor;
        ini_val(6)  = handles.maxdisp; 
        ini_val(7)  = handles.p_mem; 
        ini_val(8)  = handles.p_dim; 
        ini_val(9)  = handles.p_good; 
        ini_val(10) = handles.p_quiet;
        ini_val(11) = handles.frame_lenlower;
        ini_val(12) = handles.frame_lenupper;
        ini_val(13) = handles.ts;
        ini_val(14) = handles.te;
        ini_val(15) = handles.unit_time;
        ini_val(16) = handles.unit_length;
        ini_val(17) = handles.display;
        
        fileID = fopen('ini_val.txt','wt');
        fprintf(fileID,'%s\n',filename);
        fprintf(fileID,'%s\n',pathname);
        fprintf(fileID,'%6.2f\n',ini_val);
        fclose(fileID);

    end
    
elseif change_ini == 0
    filename     = input{2}{1}; 
    pathname     = input{2}{2};
    trimming     = input{1}(1);
    lnoise       = input{1}(2);
    lobject      = input{1}(3);
    threshold    = input{1}(4);
    thfactor     = input{1}(5);
    maxdisp      = input{1}(6);
    p_mem        = input{1}(7);
    p_dim        = input{1}(8); 
    p_good       = input{1}(9); 
    p_quiet      = input{1}(10);
    MSD_lenlower = input{1}(11);
    MSD_lenupper = input{1}(12);
    MSD_ts       = input{1}(13);
    MSD_te       = input{1}(14);
    unit_time    = input{1}(15);
    unit_length  = input{1}(16);
    
    %****display fugure setting***    
    disp_org_im   = 0;
    disp_trim_im  = 0;
    disp_track_im = 0;
    disp_freq     = 0;
    disp_msd      = 0;
    disp_msd_log  = 0;
    disp_move     = 0;
    display_num_str = num2str(input{1}(17));
    if display_num_str(9) == '1'
        disp_org_im   = 1;
    end
    if display_num_str(8) == '1'
        disp_trim_im   = 1;
    end
    if display_num_str(7) == '1'
        disp_track_im   = 1;
    end
    if display_num_str(6) == '1'
        disp_freq   = 1;
    end
    if display_num_str(5) == '1'
        disp_msd   = 1;
    end
    if display_num_str(4) == '1'
        disp_msd_log   = 1;
    end
    if display_num_str(3) == '1'
        disp_move  = 1;
    end
    
else
    disp('error')
end


%display
disp(['Time per frame  : ' num2str(unit_time),'   [s]'])    
disp(['Length per pixel: ' num2str(unit_length),'[μm]'])
disp(['filename :',fullfile(pathname, filename)])
if num2str(trimming) == '1'
    disp(['trimming : ','ON'])
elseif num2str(trimming) == '0'
    disp(['trimming : ','OFF'])
end
disp(['lnoise   : ' num2str(lnoise)])   
disp(['lobject  : ' num2str(lobject)])  
disp(['threshold: ' num2str(threshold)])
disp(['thfactor : ' num2str(thfactor)]) 
disp(['maxdisp  : ' num2str(maxdisp)])   
disp(['p_mem    : ' num2str(p_mem)])     
disp(['p_dim    : ' num2str(p_dim)])    
disp(['p_good   : ' num2str(p_good)])    
disp(['p_quiet  : ' num2str(p_quiet)])  
disp(['MSD Frame_length: ' num2str(MSD_lenlower),...
      ' ~ ',num2str(MSD_lenupper)])         
disp(['MSD Time_length :  ' num2str(MSD_ts),...
      ' ~ ',num2str(MSD_te)])  
disp(' ')
 

    