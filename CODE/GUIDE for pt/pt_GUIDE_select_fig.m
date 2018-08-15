function varargout = pt_GUIDE_select_fig(varargin)
% PT_GUIDE_SELECT_FIG MATLAB code for pt_GUIDE_select_fig.fig
%      PT_GUIDE_SELECT_FIG, by itself, creates a new PT_GUIDE_SELECT_FIG or raises the existing
%      singleton*.
%
%      H = PT_GUIDE_SELECT_FIG returns the handle to a new PT_GUIDE_SELECT_FIG or the handle to
%      the existing singleton*.
%
%      PT_GUIDE_SELECT_FIG('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in PT_GUIDE_SELECT_FIG.M with the given input arguments.
%
%      PT_GUIDE_SELECT_FIG('Property','Value',...) creates a new PT_GUIDE_SELECT_FIG or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before pt_GUIDE_select_fig_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to pt_GUIDE_select_fig_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help pt_GUIDE_select_fig

% Last Modified by GUIDE v2.5 08-Jul-2018 23:31:04

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @pt_GUIDE_select_fig_OpeningFcn, ...
                   'gui_OutputFcn',  @pt_GUIDE_select_fig_OutputFcn, ...
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


% --- Executes just before pt_GUIDE_select_fig is made visible.
function pt_GUIDE_select_fig_OpeningFcn(hObject, eventdata, handles, varargin)

number_str = num2str(varargin{1});

% initial value (object)
set(handles.checkbox_org_im,'Value',str2num(number_str(9)));
set(handles.checkbox_trim_im,'Value',str2num(number_str(8)));
set(handles.checkbox_track_im,'Value',str2num(number_str(7)));
set(handles.checkbox_freq,'Value',str2num(number_str(6)));
set(handles.checkbox_msd,'Value',str2num(number_str(5)));
set(handles.checkbox_msd_log,'Value',str2num(number_str(4)));
set(handles.checkbox_move,'Value',str2num(number_str(3)));

% initial value (return value)
handles.org_im   = str2num(number_str(9));
handles.trim_im  = str2num(number_str(8));
handles.track_im = str2num(number_str(7));
handles.freq     = str2num(number_str(6));
handles.msd      = str2num(number_str(5));
handles.msd_log  = str2num(number_str(4));
handles.move     = str2num(number_str(3));


handles.output = 100000000 + handles.org_im + 10*handles.trim_im +100*handles.track_im +...
                 1000*handles.freq + 10000*handles.msd + 100000*handles.msd_log +...
                 1000000*handles.move;

             
guidata(hObject, handles);

% UIWAIT makes pt_GUIDE_select_fig wait for user response (see UIRESUME)
uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = pt_GUIDE_select_fig_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;

delete(handles.figure1);



% --- Executes on button press in checkbox_org_im.
function checkbox_org_im_Callback(hObject, eventdata, handles)

handles.org_im = get(hObject,'Value');
guidata(hObject,handles);


% --- Executes on button press in checkbox_trim_im.
function checkbox_trim_im_Callback(hObject, eventdata, handles)

handles.trim_im = get(hObject,'Value');
guidata(hObject,handles);


% --- Executes on button press in checkbox_track_im.
function checkbox_track_im_Callback(hObject, eventdata, handles)

handles.track_im = get(hObject,'Value');
guidata(hObject,handles);


% --- Executes on button press in checkbox_freq.
function checkbox_freq_Callback(hObject, eventdata, handles)

handles.freq = get(hObject,'Value');
guidata(hObject,handles);

% --- Executes on button press in checkbox_msd.
function checkbox_msd_Callback(hObject, eventdata, handles)

handles.msd = get(hObject,'Value');
guidata(hObject,handles);


% --- Executes on button press in checkbox_msd_log.
function checkbox_msd_log_Callback(hObject, eventdata, handles)

handles.msd_log = get(hObject,'Value');
guidata(hObject,handles);


% --- Executes on button press in checkbox_move.
function checkbox_move_Callback(hObject, eventdata, handles)

handles.move = get(hObject,'Value');
guidata(hObject,handles);


% --- Executes on button press in pushbutton_ok.
function pushbutton_ok_Callback(hObject, eventdata, handles)

 handles.output = 100000000 + handles.org_im + 10*handles.trim_im +100*handles.track_im +...
                  1000*handles.freq + 10000*handles.msd + 100000*handles.msd_log +...
                  1000000*handles.move;
              
 guidata(hObject, handles);

 uiresume(handles.figure1);


% --- Executes on button press in pushbutton_all_display.
function pushbutton_all_display_Callback(hObject, eventdata, handles)

% initial value (object)
set(handles.checkbox_org_im,'Value',1);
set(handles.checkbox_trim_im,'Value',1);
set(handles.checkbox_track_im,'Value',1);
set(handles.checkbox_freq,'Value',1);
set(handles.checkbox_msd,'Value',1);
set(handles.checkbox_msd_log,'Value',1);
set(handles.checkbox_move,'Value',1);

% initial value (return value)
handles.org_im   = 1;
handles.trim_im  = 1;
handles.track_im = 1;
handles.freq     = 1;
handles.msd      = 1;
handles.msd_log  = 1;
handles.move     = 1;

guidata(hObject, handles);



% --- Executes on button press in pushbutton_only_graph.
function pushbutton_only_graph_Callback(hObject, eventdata, handles)

% initial value (object)
set(handles.checkbox_org_im,'Value',0);
set(handles.checkbox_trim_im,'Value',0);
set(handles.checkbox_track_im,'Value',0);
set(handles.checkbox_freq,'Value',1);
set(handles.checkbox_msd,'Value',1);
set(handles.checkbox_msd_log,'Value',1);
set(handles.checkbox_move,'Value',1);

% initial value (return value)
handles.org_im   = 0;
handles.trim_im  = 0;
handles.track_im = 0;
handles.freq     = 1;
handles.msd      = 1;
handles.msd_log  = 1;
handles.move     = 1;

guidata(hObject, handles);



% --- Executes on button press in pushbutton_no_display.
function pushbutton_no_display_Callback(hObject, eventdata, handles)

% initial value (object)
set(handles.checkbox_org_im,'Value',0);
set(handles.checkbox_trim_im,'Value',0);
set(handles.checkbox_track_im,'Value',0);
set(handles.checkbox_freq,'Value',0);
set(handles.checkbox_msd,'Value',0);
set(handles.checkbox_msd_log,'Value',0);
set(handles.checkbox_move,'Value',0);

% initial value (return value)
handles.org_im   = 0;
handles.trim_im  = 0;
handles.track_im = 0;
handles.freq     = 0;
handles.msd      = 0;
handles.msd_log  = 0;
handles.move     = 0;

guidata(hObject, handles);
