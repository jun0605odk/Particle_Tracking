function varargout = pt_figure(varargin)
% PT_FIGURE MATLAB code for pt_figure.fig
%      PT_FIGURE, by itself, creates a new PT_FIGURE or raises the existing
%      singleton*.
%
%      H = PT_FIGURE returns the handle to a new PT_FIGURE or the handle to
%      the existing singleton*.
%
%      PT_FIGURE('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in PT_FIGURE.M with the given input arguments.
%
%      PT_FIGURE('Property','Value',...) creates a new PT_FIGURE or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before pt_figure_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to pt_figure_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help pt_figure

% Last Modified by GUIDE v2.5 25-Jun-2018 02:15:28

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @pt_figure_OpeningFcn, ...
                   'gui_OutputFcn',  @pt_figure_OutputFcn, ...
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


% --- Executes just before pt_figure is made visible.
function pt_figure_OpeningFcn(hObject, eventdata, handles, varargin)



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

handles.c     = 1;
handles.pause = 1;


guidata(hObject, handles);


c = handles.c;

   display_4figure(handles, c);


handles.output = 0;
% UIWAIT makes pt_figure wait for user response (see UIRESUME)
uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = pt_figure_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;






% --- Executes on button press in pushbutton_next.
function pushbutton_next_Callback(hObject, eventdata, handles)

handles.c = handles.c + 1;
guidata(hObject, handles);

c = handles.c;

display_4figure(handles, c);
    
    



% --- Executes on button press in pushbutton_back.
function pushbutton_back_Callback(hObject, eventdata, handles)


handles.c = handles.c - 1;
guidata(hObject, handles);

c = handles.c;

display_4figure(handles, c);
    
   



% --- Executes on button press in pushbutton_auto.
function pushbutton_auto_Callback(hObject, eventdata, handles)

if handles.pause == 1
    handles.pause = 0;
    handles.c = handles.c + 1;
    set(handles.pushbutton_auto,'String','Stop');
elseif handles.pause == 0
    handles.pause = 1;
    set(handles.pushbutton_auto,'String','Auto');
else
    disp('error check handles.pause')
end

handles.pause
guidata(hObject, handles);



for c=handles.c:size(handles.ID_data,2)
    if handles.pause == 1
        disp('bug0')
        break
    end
        
    handles.c = handles.c + 1;
    guidata(hObject, handles);

    display_4figure(handles, c);


    pause(1)
    
end

    
    
function display_4figure(handles,c)

    str1 = sprintf('   %s %-5d','ID:',handles.ID_data(c));%! track ID
    str2 = sprintf('   %s %7.2f','MFI:',handles.MFI_data(c));%! MFI(mean fluorescence intensity)
    str3 = sprintf('    %s %4.2f','dst ratio:',handles.dst_ratio_data(c));%! MFI(mean fluorescence intensity)
    

    colormap(handles.axes1,gray);
    imagesc(handles.axes1,handles.im);
    axis(handles.axes1,'image');
    hold(handles.axes1,'on')
    title (handles.axes1,'Particle Tracking','FontSize',14);
    plot(handles.axes1,handles.X1{c},handles.Y1{c},'ro','MarkerSize',5,'LineWidth',1);
    hold(handles.axes1,'off')

    plot(handles.axes2,0,0,'bo')%! initial coordinate
    axis(handles.axes2,'equal');
    axis(handles.axes2,[-15 15 -15 15])
    hold(handles.axes2,'on')
    plot(handles.axes2,handles.X2_1{c},handles.Y2_1{c},'ro') % final coordinate
    plot(handles.axes2,handles.X2_2{c},handles.Y2_2{c},'-k.','MarkerSize',10)% traking line
    text(handles.axes2,-5,-13,str3)%!
    title (handles.axes2,{'Movement of prticle';'(NOTE: the data has "skipped frames")'},'FontSize',13)%!
    legend(handles.axes2,{'Initial Point','Final  Point'},'FontSize',8)%!
    hold(handles.axes2,'off')

    plot(handles.axes3,handles.Y3_1{c})
    hold(handles.axes3,'on')
    plot(handles.axes3,handles.Y3_2{c})
    axis(handles.axes3,[0 60 0 20])
    title (handles.axes3,{'Distance';'(NOTE: the data has "skipped frames")'},'FontSize',13)%!
    legend(handles.axes3,{'distance(bef\_frm to cur\_frm)','distance(1st\_frm to cur\_frm)'},'FontSize',8)%!
    xlabel(handles.axes3,'Frame')%!
    ylabel(handles.axes3,'distance [pixel]')%!
    hold(handles.axes3,'off')

    yyaxis(handles.axes4,'left')
    plot(handles.axes4,handles.Y4_1{c})%brightness
    axis(handles.axes4,[0 60 0 1.5])
    ylabel(handles.axes4,'Fluorescence Intensity')%!
    yyaxis(handles.axes4,'right')
    plot(handles.axes4,handles.Y4_2{c})%distance
    axis(handles.axes4,[0 60 0 50])
    text(handles.axes4,40,5,str2)%! 
    title (handles.axes4,{'fluorescence intensity';'(NOTE: the data has "skipped frames")'},'FontSize',13)%!
    xlabel(handles.axes4,'Frame')%!
    ylabel(handles.axes4,'Distance')%!
    
    disp([str1, str2, str3])
