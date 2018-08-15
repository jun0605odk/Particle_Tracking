function varargout = pt_GUIDE_figure(varargin)
% PT_GUIDE_FIGURE MATLAB code for pt_GUIDE_figure.fig
%      PT_GUIDE_FIGURE, by itself, creates a new PT_GUIDE_FIGURE or raises the existing
%      singleton*.
%
%      H = PT_GUIDE_FIGURE returns the handle to a new PT_GUIDE_FIGURE or the handle to
%      the existing singleton*.
%
%      PT_GUIDE_FIGURE('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in PT_GUIDE_FIGURE.M with the given input arguments.
%
%      PT_GUIDE_FIGURE('Property','Value',...) creates a new PT_GUIDE_FIGURE or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before pt_GUIDE_figure_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to pt_GUIDE_figure_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help pt_GUIDE_figure

% Last Modified by GUIDE v2.5 10-Jul-2018 15:15:44

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @pt_GUIDE_figure_OpeningFcn, ...
                   'gui_OutputFcn',  @pt_GUIDE_figure_OutputFcn, ...
                   'gui_LayoutFcn',  [] , ...
                   'gui_Callback',   []);
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT


% --- Executes just before pt_GUIDE_figure is made visible.
function pt_GUIDE_figure_OpeningFcn(hObject, eventdata, handles, varargin)

handles.X1   = varargin{1}{1,1,1};
handles.Y1   = varargin{1}{2,1,1};
handles.X2_1 = varargin{1}{1,2,1};
handles.Y2_1 = varargin{1}{2,2,1};
handles.X2_2 = varargin{1}{1,2,2};
handles.Y2_2 = varargin{1}{2,2,2};
handles.Y3_1 = varargin{1}{2,3,1};
handles.Y3_2 = varargin{1}{2,3,2};
handles.Y4_1 = varargin{1}{2,4,1};
handles.Y4_2 = varargin{1}{2,4,2};

handles.im             = varargin{1}{3,1,1};
handles.ID_data        = varargin{1}{3,2,1};
handles.MFI_data       = varargin{1}{3,2,2};
handles.dst_ratio_data = varargin{1}{3,2,3};

handles.c      = 1;
handles.pause  = 1;
handles.skip   = 1;

handles.output = 0;
set(handles.popupmenu_value,'Value',1);


guidata(hObject, handles);


c = handles.c;
display_4figure(hObject,handles, c);


%uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = pt_GUIDE_figure_OutputFcn(hObject, eventdata, handles) 

varargout{1} = handles.output;






% --- Executes on button press in pushbutton_next.
function pushbutton_next_Callback(hObject, eventdata, handles)

if handles.c+(1*handles.skip) <= size(handles.ID_data,2)
    
    handles.c = handles.c + (1*handles.skip);
    guidata(hObject, handles);

    c = handles.c;

    display_4figure(hObject,handles, c);
    
else
    handles.c = size(handles.ID_data,2);
    guidata(hObject, handles);

    c = handles.c;

    display_4figure(hObject,handles, c);
    
    disp('exceeded the range of the tracking image')
end 



% --- Executes on button press in pushbutton_back.
function pushbutton_back_Callback(hObject, eventdata, handles)

if handles.c-(1*handles.skip) >= 1
    
    handles.c = handles.c - (1*handles.skip);
    guidata(hObject, handles);

    c = handles.c;

    display_4figure(hObject,handles, c);
    
else
    handles.c = 1;
    guidata(hObject, handles);

    c = handles.c;

    display_4figure(hObject,handles, c);
    
    disp('exceeded the range of the tracking image')
end 

   

% --- Executes on selection change in popupmenu_value.
function popupmenu_value_Callback(hObject, eventdata, handles)
% Determine the selected data set.
str = get(hObject, 'String');
val = get(hObject,'Value');
% Set current data to the selected data set.
switch str{val}
case '1' 
   handles.skip = 1;
case '2' 
   handles.skip = 2;
case '3' 
   handles.skip = 3;
case '5'
   handles.skip = 5;
case '10' 
   handles.skip = 10;
case '50'
   handles.skip = 50;
case '100'
   handles.skip = 100;
end
% Save the handles structure.
guidata(hObject,handles)





% --- Executes on button press in pushbutton_auto.
function pushbutton_auto_Callback(hObject, eventdata, handles)

set(handles.pushbutton_auto,'enable','off');


if handles.c >= size(handles.ID_data,2)
    warning('This is the final tracking image')
    set(handles.pushbutton_auto,'String','Auto');
    set(handles.pushbutton_auto,'enable','on');
    return
end

if handles.pause == 1 
    handles.pause = 0;
    set(handles.pushbutton_auto,'String','Stop');
    guidata(hObject, handles);
elseif (getappdata(hObject, 'CallbackRun') == 0)
    handles.pause = 1;
    set(handles.pushbutton_auto,'String','Auto');
    guidata(hObject, handles);
elseif (getappdata(hObject, 'CallbackRun') == 1)
    set(handles.pushbutton_auto,'String','Stop');
    guidata(hObject, handles);
end

setappdata(hObject, 'CallbackRun', 0);
guidata(hObject, handles);

set(handles.pushbutton_next,'enable','off');
set(handles.pushbutton_back,'enable','off');
set(handles.popupmenu_value,'enable','off');
set(handles.pushbutton_auto,'enable','on');



for c=handles.c+1:size(handles.ID_data,2)
    
    if (getappdata(hObject, 'CallbackRun') == 1) || (handles.pause == 1)
        break
    end
    
    %set(handles.pushbutton_auto,'enable','off');

    handles.c = handles.c + 1;
    guidata(hObject, handles);
    
    display_4figure(hObject,handles, c);
    drawnow
    
    %set(handles.pushbutton_auto,'enable','on');
     
    pause(1)
    
    if c==size(handles.ID_data,2) 
        set(handles.pushbutton_auto,'String','Auto');
        disp('End of the image')
    end
   
    
end

set(handles.pushbutton_next,'enable','on');
set(handles.pushbutton_back,'enable','on');
set(handles.popupmenu_value,'enable','on');

guidata(hObject,handles);
setappdata(hObject, 'CallbackRun', 1);


    
function display_4figure(hObject,handles,c)

    % for save
    handles.c_save = c;
    guidata(hObject,handles);
    
    str0 = sprintf('   %s %-5d','No:',handles.c);%! track Nomber
    str1 = sprintf('    %s %-5d','ID:',handles.ID_data(c));%! track ID
    str2 = sprintf('   %s %7.2f','MFI:',handles.MFI_data(c));%! MFI(mean fluorescence intensity)
    str3 = sprintf('    %s %4.2f','dst ratio:',handles.dst_ratio_data(c));%! MFI(mean fluorescence intensity)

    
    imagesc(handles.axes1,handles.im);
    colormap(handles.axes1,gray);
    axis(handles.axes1,'image');
    hold(handles.axes1,'on')
    title (handles.axes1,'Particle Tracking','FontSize',14);
    plot(handles.axes1,handles.X1{c},handles.Y1{c},'ro','MarkerSize',5,'LineWidth',1);
    xlabel(handles.axes1,'X[pixel]')
    ylabel(handles.axes1,'Y[pixel]')
    hold(handles.axes1,'off')

    plot(handles.axes2,0,0,'bo')%! initial coordinate
    axis(handles.axes2,'equal');
    axis(handles.axes2,[-1 1 -1 1])
    hold(handles.axes2,'on')
    plot(handles.axes2,handles.X2_1{c},handles.Y2_1{c},'ro') % final coordinate
    plot(handles.axes2,handles.X2_2{c},handles.Y2_2{c},'-k.','MarkerSize',10)% traking line
    text(handles.axes2,0,-0.8,str3)
    title (handles.axes2,{'Movement of prticle';'(NOTE: the data has "skipped frames")'},'FontSize',13)%!
    legend(handles.axes2,{'Initial Point','Final  Point'},'FontSize',8)
    xlabel(handles.axes2,'X[μm]')
    ylabel(handles.axes2,'Y[μm]')
    hold(handles.axes2,'off')

    plot(handles.axes3,handles.Y3_1{c})
    hold(handles.axes3,'on')
    plot(handles.axes3,handles.Y3_2{c})
    axis(handles.axes3,[0 60 0 1])
    title (handles.axes3,{'Distance';'(NOTE: the data has "skipped frames")'},'FontSize',13)%!
    legend(handles.axes3,{'distance(bef\_frm to cur\_frm)','distance(1st\_frm to cur\_frm)'},'FontSize',8)%!
    xlabel(handles.axes3,'Frame')%!
    ylabel(handles.axes3,'distance[μm]')%!
    hold(handles.axes3,'off')

    yyaxis(handles.axes4,'left')
    plot(handles.axes4,handles.Y4_1{c})%brightness
    axis(handles.axes4,[0 60 0 1.5])
    ylabel(handles.axes4,'Fluorescence Intensity')%!
    yyaxis(handles.axes4,'right')
    plot(handles.axes4,handles.Y4_2{c})%distance
    axis(handles.axes4,[0 60 0 5])
    text(handles.axes4,40,0.5,str2)%! 
    title (handles.axes4,{'fluorescence intensity';'(NOTE: the data has "skipped frames")'},'FontSize',13)%!
    xlabel(handles.axes4,'Frame')%!
    ylabel(handles.axes4,'Distance[μm]')%!
    
%     disp([str1, str2, str3])
    disp([str0, str1, str2, str3])



% --- Executes during object creation, after setting all properties.
function popupmenu_value_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu_value (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --------------------------------------------------------------------
function uipushtool1_ClickedCallback(hObject, eventdata, handles)

%saveas(handles.axes1,'pt_move_1.png')
name = strcat('pt_move_ID_',num2str(handles.ID_data(handles.c_save)),'.png');
disp(' ')
disp(['figure was saved      NAME:',name])
disp(' ')
saveas(gcf,name)
