function varargout = Playfair_Cipher_Algorithm(varargin)
% PLAYFAIR_CIPHER_ALGORITHM MATLAB code for Playfair_Cipher_Algorithm.fig
%      PLAYFAIR_CIPHER_ALGORITHM, by itself, creates a new PLAYFAIR_CIPHER_ALGORITHM or raises the existing
%      singleton*.
%
%      H = PLAYFAIR_CIPHER_ALGORITHM returns the handle to a new PLAYFAIR_CIPHER_ALGORITHM or the handle to
%      the existing singleton*.
%
%      PLAYFAIR_CIPHER_ALGORITHM('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in PLAYFAIR_CIPHER_ALGORITHM.M with the given input arguments.
%
%      PLAYFAIR_CIPHER_ALGORITHM('Property','Value',...) creates a new PLAYFAIR_CIPHER_ALGORITHM or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before Playfair_Cipher_Algorithm_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to Playfair_Cipher_Algorithm_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help Playfair_Cipher_Algorithm

% Last Modified by GUIDE v2.5 21-May-2022 16:20:50

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @Playfair_Cipher_Algorithm_OpeningFcn, ...
                   'gui_OutputFcn',  @Playfair_Cipher_Algorithm_OutputFcn, ...
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


% --- Executes just before Playfair_Cipher_Algorithm is made visible.
function Playfair_Cipher_Algorithm_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to Playfair_Cipher_Algorithm (see VARARGIN)

% Choose default command line output for Playfair_Cipher_Algorithm
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes Playfair_Cipher_Algorithm wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = Playfair_Cipher_Algorithm_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in Encode_btn.
function Encode_btn_Callback(hObject, eventdata, handles)
% hObject    handle to Encode_btn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

sentence=get(handles.text_tag,'string');
key=upper(get(handles.keyword_tag,'string'));


% Playfair Table Construction
key_len=length(key);
playfair_table=zeros(5,5);
alphabet_exist=zeros(1,26); % a table that, if the letter c (==char) isfound the it (the table) has 1 in index c-'A'+1 else it has 0
alphabet_exist(10)=1; % index 10 is letter J which is the same (for the algorithm) to I, so I don't want it in my Playfair table
j=1;
for i=1:key_len
    num=double(key(i));
    if(alphabet_exist((num-'A')+1)==0)
        playfair_table(floor((j-1)/5)+1, mod(j-1,5)+1)=num;
        alphabet_exist((num-'A')+1)=1;
        j=j+1;
    end
end
for i=1:26
    if(alphabet_exist(i)==0)
        playfair_table(floor((j-1)/5)+1, mod((j-1),5)+1)=i+'A'-1;
        alphabet_exist(i)=1;
        j=j+1;
    end
end
sentence=upper(sentence); %????? ??? ????????
s_len=length(sentence);

% I place an X between any 2 consecutive same latter while also in the end
% of the word if its length (after the additions of X's) is odd
prev=sentence(1);
i=2;
while(i<=s_len)
    current=sentence(i);
    if(prev==current)
        sentence=insertAfter(sentence,i-1,'X');
        s_len = s_len+1;
        i = i+1;
    end
    prev=current;
    i = i+1;
end
if(mod(s_len,2)==1)
    sentence=insertAfter(sentence,i-1,'Z');
    s_len=s_len+1;
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% I create the inverse of Playfair by the sense that if Playfair has the
% letter c (==char) on index i then the inverse has i on index c-'A'+1
inverse = zeros(1, 25);
for i=1:25
    inverse(playfair_table(floor((i-1)/5)+1,mod(i-1,5)+1)-'A'+1)=i;
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

encrypted_sentence=zeros(1,s_len);
decrypted_sentence=zeros(1,s_len);
 for i=1:s_len/2
     %encryption
     if(same_line(sentence(i*2-1), sentence(i*2), inverse))
         k=inverse(sentence(i*2-1)-'A'+1);
         encrypted_sentence(i*2-1) = playfair_table(floor((k-1)/5)+1,mod(mod(k-1,5)+1,5)+1);
         k=inverse(sentence(i*2)-'A'+1);
         encrypted_sentence(i*2) = playfair_table(floor((k-1)/5)+1,mod(mod(k-1,5)+1,5)+1);
     elseif(same_row(sentence(i*2-1), sentence(i*2), inverse))
         k=inverse(sentence(i*2-1)-'A'+1);
         encrypted_sentence(i*2-1) = playfair_table(mod(floor((k-1)/5)+1,5)+1,mod(k-1,5)+1);
         k=inverse(sentence(i*2)-'A'+1);
         encrypted_sentence(i*2) = playfair_table(mod(floor((k-1)/5)+1,5)+1,mod(k-1,5)+1);
     else
         k=inverse(sentence(i*2-1)-'A'+1);
         k_2=inverse(sentence(i*2)-'A'+1);
         encrypted_sentence(i*2-1) = playfair_table(floor((k-1)/5)+1,mod(k_2-1,5)+1);
         encrypted_sentence(i*2) = playfair_table(floor((k_2-1)/5)+1,mod(k-1,5)+1);
     end
     %decryption
     global decrypted_sentence
     if(same_line(encrypted_sentence(i*2-1), encrypted_sentence(i*2), inverse))
         k=inverse(encrypted_sentence(i*2-1)-'A'+1);
         decrypted_sentence(i*2-1) = playfair_table(floor((k-1)/5)+1,mod(mod(k-1,5)-1,5)+1);
         k=inverse(encrypted_sentence(i*2)-'A'+1);
         decrypted_sentence(i*2) = playfair_table(floor((k-1)/5)+1,mod(mod(k-1,5)-1,5)+1);
     elseif(same_row(encrypted_sentence(i*2-1), encrypted_sentence(i*2), inverse))
         k=inverse(encrypted_sentence(i*2-1)-'A'+1);
         decrypted_sentence(i*2-1) = playfair_table(mod(floor((k-1)/5)-1,5)+1,mod(k-1,5)+1);
         k=inverse(encrypted_sentence(i*2)-'A'+1);
         decrypted_sentence(i*2) = playfair_table(mod(floor((k-1)/5)-1,5)+1,mod(k-1,5)+1);
     else
         k=inverse(encrypted_sentence(i*2-1)-'A'+1);
         k_2=inverse(encrypted_sentence(i*2)-'A'+1);
         decrypted_sentence(i*2-1) = playfair_table(floor((k-1)/5)+1,mod(k_2-1,5)+1);
         decrypted_sentence(i*2) = playfair_table(floor((k_2-1)/5)+1,mod(k-1,5)+1);
     end
 end
 set(handles.encode_tag,'string',char(encrypted_sentence));

 
% We tend to use instead of 2 for loop from 1:m and from 1:n, 1 for loop
% fron 1:m*n to accesss tables of m lines and n rows.
% The reason that we can do that is because i (in the case of m*n access)
% connects to the row and line number with the equation:
% line_number=floor((i-1)/m)+1, row_number=mod(i-1,n)+1




function text_tag_Callback(hObject, eventdata, handles)
% hObject    handle to text_tag (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of text_tag as text
%        str2double(get(hObject,'String')) returns contents of text_tag as a double


% --- Executes during object creation, after setting all properties.
function text_tag_CreateFcn(hObject, eventdata, handles)
% hObject    handle to text_tag (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function keyword_tag_Callback(hObject, eventdata, handles)
% hObject    handle to keyword_tag (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of keyword_tag as text
%        str2double(get(hObject,'String')) returns contents of keyword_tag as a double


% --- Executes during object creation, after setting all properties.
function keyword_tag_CreateFcn(hObject, eventdata, handles)
% hObject    handle to keyword_tag (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function encode_tag_Callback(hObject, eventdata, handles)
% hObject    handle to encode_tag (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of encode_tag as text
%        str2double(get(hObject,'String')) returns contents of encode_tag as a double


% --- Executes during object creation, after setting all properties.
function encode_tag_CreateFcn(hObject, eventdata, handles)
% hObject    handle to encode_tag (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function decode_tag_Callback(hObject, eventdata, handles)
% hObject    handle to decode_tag (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of decode_tag as text
%        str2double(get(hObject,'String')) returns contents of decode_tag as a double


% --- Executes during object creation, after setting all properties.
function decode_tag_CreateFcn(hObject, eventdata, handles)
% hObject    handle to decode_tag (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in decode_btn.
function decode_btn_Callback(hObject, eventdata, handles)
% hObject    handle to decode_btn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

global decrypted_sentence;
 set(handles.decode_tag,'string',char(decrypted_sentence));
 
 
 
 
 
 
 
% --- Executes on button press in reset_btn.
function reset_btn_Callback(hObject, eventdata, handles)
% hObject    handle to reset_btn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
set(handles.text_tag,'string','');
set(handles.keyword_tag,'string','');
set(handles.decode_tag,'string','');
set(handles.encode_tag,'string','');
