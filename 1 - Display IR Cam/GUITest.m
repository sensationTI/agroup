function varargout = GUITest(varargin)
% GUITEST MATLAB code for GUITest.fig
%      GUITEST, by itself, creates a new GUITEST or raises the existing
%      singleton*.
%
%      H = GUITEST returns the handle to a new GUITEST or the handle to
%      the existing singleton*.
%
%      GUITEST('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in GUITEST.M with the given input arguments.
%
%      GUITEST('Property','Value',...) creates a new GUITEST or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before GUITest_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to GUITest_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help GUITest

% Last Modified by GUIDE v2.5 13-Oct-2015 16:24:34

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @GUITest_OpeningFcn, ...
                   'gui_OutputFcn',  @GUITest_OutputFcn, ...
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


% --- Executes just before GUITest is made visible.
function GUITest_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to GUITest (see VARARGIN)

% Choose default command line output for GUITest
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);
fig = imread('flirLogo.png');
axes(handles.axes2);
imshow(fig);


hasIPT = license('test', 'image_toolbox');
if ~hasIPT
	% User does not have the toolbox installed.
	message = sprintf('Sorry, but you do not seem to have the Matlab Image Processing Toolbox.\nYou will not be able to run the Edge or Segmentation filter.\nContinue anyway?');
	reply = questdlg(message, 'Toolbox missing', 'Yes', 'No', 'Yes');
	if strcmpi(reply, 'No')
		% User said No, so exit.
		return;
	end
end

% UIWAIT makes GUITest wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = GUITest_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in pushbutton1.
function pushbutton1_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

%AddAssembly Flir.Atlas.Live.dll
atPath = getenv('FLIR_Atlas_MATLAB');
atLive = strcat(atPath,'Flir.Atlas.Live.dll');
asmInfo = NET.addAssembly(atLive);
%init camera discovery
test = Flir.Atlas.Live.Discovery.Discovery;
% search for cameras for 10 seconds
disc = test.Start(10);
% put the result in a list box
for i =0:disc.Count-1 
 s1 = strcat(char(disc.Item(i).Name),'::');
 s2 = strcat(s1,char(disc.Item(i).SelectedStreamingFormat));
 str{i+1} =  s2;   
end   
set(handles.listbox1,'string',str);
handles.disc = disc;
guidata(hObject,handles)

 
 


% --- Executes on selection change in listbox1.
function listbox1_Callback(hObject, eventdata, handles)
% hObject    handle to listbox1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns listbox1 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from listbox1
index_selected = get(hObject,'Value');


% --- Executes during object creation, after setting all properties.
function listbox1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to listbox1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbuttonConnect.
function pushbuttonConnect_Callback(hObject, eventdata, handles)
% hObject    handle to pushbuttonConnect (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
index_selected = get(handles.listbox1,'Value');
disc = handles.disc;
% check if it is FlirFileFormat or mpeg streaming
if(strcmp(char(disc.Item(index_selected-1).SelectedStreamingFormat),'FlirFileFormat'))
    %It is FlirFileFormat init a ThermalCamera
    ImStream = Flir.Atlas.Live.Device.ThermalCamera(true);    
    ImStream.Connect(disc.Item(index_selected-1));
    %save the stream
    handles.ImStream = ImStream;
    handles.stop = 1;
    guidata(hObject,handles)
    %set the Iron palette
    pal = ImStream.ThermalImage.PaletteManager;
%     ImStream.ThermalImage.Palette = pal.Iron; 
    %read x y position
    x = str2num(get(handles.edit4,'String'));
    y = str2num(get(handles.edit3,'String'));
    oldX = x;
    oldY = y;
    %add spot
    spot = ImStream.ThermalImage.Measurements.Add(System.Drawing.Point(x, y));
    pause(1);
    while handles.stop
      %get the colorized image   
      img = ImStream.ThermalImage.ImageArray;
      %convert to Matlab type
      X = uint8(img);
      axes(handles.axes1);
      
      %Set Filter1 on or off 
      if get(handles.radiobutton2, 'value')
        X = Filter1(X);
      end  
      if get(handles.radiobutton3, 'value')
         X = Filter2(X);
      end    
       if get(handles.radiobutton4, 'value')
         X = Filter3(X);
      end    
      %show image with Matlab imshow
      imshow(X);
      %show overlay for spot (for full speed set it to off in gui)
      if get(handles.radiobutton1, 'value')
           x = str2num(get(handles.edit4,'String'));
           y = str2num(get(handles.edit3,'String'));
           if oldX ~= x  || oldY ~= y
               spot.X = x;
               spot.Y = y;
           end    
           plot(x, y, 'o', 5, 5);
           hold on;
           oldX = x;
           oldY = y;
      else
          hold off;
      end    
      drawnow
      handles = guidata(hObject);
     
      %Read temp from spot 
      Temperature = spot.Value.Value
    end
else
    %mpeg stream
   ImStream = Flir.Atlas.Live.Device.VideoOverlayCamera(true);
   %connect
    ImStream.Connect(disc.Item(index_selected-1));
    handles.ImStream = ImStream;
    handles.stop = 1;
    guidata(hObject,handles)
    pause(1);
    while handles.stop
        % get the Image
        img = ImStream.VisualImage.ImageArray;
        X = uint8(img);  
        axes(handles.axes1);
        imshow(X,[]);
        drawnow
        handles = guidata(hObject);
    end    
end
ImStream = handles.ImStream;
ImStream.Disconnect();
ImStream.Dispose();

% --- Executes on button press in pushbuttonDisconnect.
function pushbuttonDisconnect_Callback(hObject, eventdata, handles)
% hObject    handle to pushbuttonDisconnect (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.stop = 0;
guidata(hObject,handles);


% --- Executes on button press in pushbuttonNUC.
function pushbuttonNUC_Callback(hObject, eventdata, handles)
% hObject    handle to pushbuttonNUC (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
ImStream = handles.ImStream;
ImStream.RemoteControl.CameraAction.Nuc;
% --- Executes on button press in pushbuttonAuto.
function pushbuttonAuto_Callback(hObject, eventdata, handles)
% hObject    handle to pushbuttonAuto (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
ImStream = handles.ImStream;
ImStream.RemoteControl.Focus.Mode(Flir.Atlas.Live.Remote.FocusMode.Auto);

% --- Executes on button press in pushbuttonSave.
function pushbuttonSave_Callback(hObject, eventdata, handles)
% hObject    handle to pushbuttonSave (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
ImStream = handles.ImStream;
%read the input string
editString = get(handles.edit2,'string');
edit = strcat(editString,'.jpg');
%save snapshot
ImStream.GetImage().EnterLock();
ImStream.ThermalImage.SaveSnapshot(edit,ImStream.ThermalImage.Image);
ImStream.GetImage().ExitLock();


% --- Executes on button press in pushbuttonOpen.
function pushbuttonOpen_Callback(hObject, eventdata, handles)
% hObject    handle to pushbuttonOpen (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
[filename path] = uigetfile;
s1 = strcat(path,filename);
%Load Flir Atlas
atPath = getenv('FLIR_Atlas_MATLAB');
atImage = strcat(atPath,'Flir.Atlas.Image.dll');
asmInfo = NET.addAssembly(atImage);
%open a thermal image
file = Flir.Atlas.Image.ThermalImageFile;
file.Open(s1);
axes(handles.axes1);
%Get the image as an array
img = file.ImageArray;
%convert to Matlab type
X = uint8(img);
%Use matlabs Imshow to show the image
imshow(X);
%close file
file.Close;
handles.Filename = s1;
guidata(hObject,handles);


% --- Executes on button press in pushbuttonPlay.
function pushbuttonPlay_Callback(hObject, eventdata, handles)
% hObject    handle to pushbuttonPlay (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
%Load Flir Atlas
atPath = getenv('FLIR_Atlas_MATLAB');
atImage = strcat(atPath,'Flir.Atlas.Image.dll');
asmInfo = NET.addAssembly(atImage);
%start a playback player
file = Flir.Atlas.Image.ThermalImageFile(handles.Filename);
seq = file.ThermalSequencePlayer();
%number of frames
seq.Count
%loop the sequence
seq.Loop = 1;
seq.Play;
handles.Loop = 1;
handles.seq = seq;
guidata(hObject,handles);
while handles.Loop
   %get the image in signal values
    img = file.ImageProcessing.GetPixelsArray;
    X = double(img);
    pause(0.0001);%let matlab render the image
    axes(handles.axes1);
    imshow(X,[]);
    handles = guidata(hObject);

end


% --- Executes on button press in pushbuttonStop.
function pushbuttonStop_Callback(hObject, eventdata, handles)
% hObject    handle to pushbuttonStop (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
seq = handles.seq;
seq.Stop;
handles.Loop = 0;
guidata(hObject,handles);


% --- Executes on button press in pushbuttonStartRec.
function pushbuttonStartRec_Callback(hObject, eventdata, handles)
% hObject    handle to pushbuttonStartRec (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
ImStream = handles.ImStream;
editString = get(handles.edit2,'string');
edit = strcat(editString,'.seq');
%start recording
ImStream.Recorder.Start(edit);
% --- Executes on button press in pushbuttonStopRec.
function pushbuttonStopRec_Callback(hObject, eventdata, handles)
% hObject    handle to pushbuttonStopRec (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
ImStream = handles.ImStream;
%stop recording
ImStream.Recorder.Stop;


function edit2_Callback(hObject, eventdata, handles)
% hObject    handle to edit2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit2 as text
%        str2double(get(hObject,'String')) returns contents of edit2 as a double
handles.edit = get(hObject,'string');
guidata(hObject,handles);

% --- Executes during object creation, after setting all properties.
function edit2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit3_Callback(hObject, eventdata, handles)
% hObject    handle to edit3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit3 as text
%        str2double(get(hObject,'String')) returns contents of edit3 as a double


% --- Executes during object creation, after setting all properties.
function edit3_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit4_Callback(hObject, eventdata, handles)
% hObject    handle to edit4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit4 as text
%        str2double(get(hObject,'String')) returns contents of edit4 as a double


% --- Executes during object creation, after setting all properties.
function edit4_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in radiobutton1.
function radiobutton1_Callback(hObject, eventdata, handles)
% hObject    handle to radiobutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of radiobutton1


% --- Executes on button press in radiobutton2.
function radiobutton2_Callback(hObject, eventdata, handles)
% hObject    handle to radiobutton2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of radiobutton2


% --- Executes on button press in radiobutton3.
function radiobutton3_Callback(hObject, eventdata, handles)
% hObject    handle to radiobutton3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of radiobutton3


% --- Executes on button press in radiobutton4.
function radiobutton4_Callback(hObject, eventdata, handles)
% hObject    handle to radiobutton4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of radiobutton4
