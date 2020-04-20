function varargout = main(varargin)

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @main_OpeningFcn, ...
                   'gui_OutputFcn',  @main_OutputFcn, ...
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
% --- Executes just before main is made visible.
function main_OpeningFcn(hObject, eventdata, handles, varargin)
handles.output = hObject;
guidata(hObject, handles);
function varargout = main_OutputFcn(hObject, eventdata, handles) 
varargout{1} = handles.output;
function pushbutton2_Callback(hObject, eventdata, handles)

run fault
% --- Executes on button press in pushbutton3.
function pushbutton3_Callback(hObject, eventdata, handles)

run greenfunc
% --- Executes on button press in pushbutton5.
function pushbutton5_Callback(hObject, eventdata, handles)

run soil
% --- Executes on button press in pushbutton6.
function pushbutton6_Callback(hObject, eventdata, handles)

run model
function location_Callback(hObject, eventdata, handles)
% --- Executes during object creation, after setting all properties.
function location_CreateFcn(hObject, eventdata, handles)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
% --- Executes on button press in pushbutton7.
function pushbutton7_Callback(hObject, eventdata, handles)

global slip W L depth dip rake grid sample...
    Lx Ly Lz dx dy dz multilayer h E v ro location
ob_depth=0;%�۲����
r1=0;r2=sqrt((L/2+Lx/2)*(L/2+Lx/2)+(Ly/2+W*cos(dip/180*pi))*(Ly/2+W*cos(dip/180*pi)));%������ʼ����յ�
nr=ceil(r2/grid+1);%��������
zs1=0;zs2=W*sin(dip/180*pi)+depth;%������ʼ����յ�
nzs=ceil(zs2/grid+1);%��������
    for i=0:dz:Lz
        %д��edgrn�ļ�
        if multilayer~=1
            fid=fopen('edgrn.inp','w+');
            fprintf(fid,'%s\n','# �۲�����');
            fprintf(fid,'%s\n','# �������� ��ʼ�� �յ�');
            fprintf(fid,'%s\n','# �������� ��ʼ�� �յ�');
            fprintf(fid,'%d\n',ob_depth); 
            ob_depth=ob_depth+dz;
            fprintf(fid,'%d %d %d\n',nr,r1,r2);
            fprintf(fid,'%d %d %d\n',nzs,zs1,zs2);
            fprintf(fid,'%s\n','# �������ֲ�����');
            fprintf(fid,'%d\n',sample); 
            fprintf(fid,'%s\n','# ����ļ�λ�ú��ļ���');
            fprintf(fid,'%s %s %s %s\n',location,"'izmhs.ss'","'izmhs.ds'","'izmhs.cl'");
            fprintf(fid,'%s\n','# ������');
            j=0;
            for k=1:multilayer
                j=j+h(k);
                if j<zs2
                    num=2*multilayer-1;
                else                
                    num=2*k-1;
                    break
                end
            end
            fprintf(fid,'%d\n',num); 
            fprintf(fid,'%s\n','#������� ���m P������m/s S������m/s �ܶ�kg/m^3');
            j=0;
            for k=1:multilayer
                G(k)=E(k)/2/(1+v(k));%�ػ�����ģ��
                lmt(k)=E(k)*v(k)/(1+v(k))/(1-2*v(k));%��÷�����е�lmt
                VP(k)=sqrt((lmt(k)+2*G(k))/ro(k));%����ػ����ݲ�����
                VS(k)=sqrt(G(k)/ro(k));%����ػ��кᲨ����
                fprintf(fid,'%d  %d  %d  %d  %d\n',2*k-1,j,VP(k),VS(k),ro(k));
                j=j+h(k);
                if j<zs2             
                    fprintf(fid,'%d  %d  %d  %d  %d\n',2*k,j,VP(k),VS(k),ro(k));
                else
                    break
                end
            end
            fclose(fid);  
            ! edgrn-zidong
        end

        plane=[num2str(i),'mhs.disp'];%д�����Ϊi�׵Ĺ۲���Ĳ���������inp�ļ�
        fid=fopen('edcmp.inp','w+');
        fprintf(fid,'%s\n','# �۲���');
        fprintf(fid,'%d\n',2); 
        fprintf(fid,'%d %d %d\n',Lx/dx+1,L/2-Lx/2,L/2+Lx/2);
        fprintf(fid,'%d %d %d\n',Ly/dy+1,-1*Ly/2,Ly/2);
        fprintf(fid,'%s\n','# ����ļ���');
        fprintf(fid,'%s\n',"'./'");
        fprintf(fid,'%d %d %d %d\n',1,0,0,0');
        fprintf(fid,'%s %s %s %s\n',plane,"'izmhs.strn'","'izmhs.strss'","'izmhs.tilt'");
        fprintf(fid,'%s\n','# �ϲ��Դ����');
        fprintf(fid,'%d\n',1); 
        fprintf(fid,'%s\n','# ��Դ���� ��� λ���� ���Ͻǵ�����xyz ���� �� �� ��� ������');
        fprintf(fid,'%d %d %d %d %d %d %d %d %d %d\n',1,slip,0,0,depth,L,W,0,dip,rake); 
        fprintf(fid,'%s\n','#������� �ɲ�Ϊ1 ����Ϊ0����÷���� lambda mu');
        if multilayer==1
            fprintf(fid,'%d\n',0);
            lmt=E(1)*v(1)/(1+v(1))/(1-2*v(1));%��÷��һ����
            G=E(1)/2/(1+v(1));%��÷�ڶ�������������ģ��
            fprintf(fid,'%d %d %d\n',i,lmt,G); 
        else
            fprintf(fid,'%d\n',1); 
            fprintf(fid,'%s\n','# ���ֺ����ļ���λ�ú��ļ���');
            fprintf(fid,'%s %s %s %s\n',location,"'izmhs.ss'","'izmhs.ds'","'izmhs.cl'");
        end
        fclose(fid); 
        fprintf('��ʼ��%d�μ���\n',i/dz+1)
        ! edcmp-zidong
        fprintf('��%d�μ������\n',i/dz+1)
        %��һ��Ϊ����������֣��Լ���õ���*mhs.disp�ļ����ж�ȡ
        %x y z��ʾedcmp����������������ϵ
        %X Y Z��ʾabaqusģ�͵ľֲ�����ϵ
        %����֮���ƽ��ת������Ϊ[X Y Z]=[x y z]+[-L/2-Lx/2,+Ly/2,-Lz],��תת������Ϊ[-1 1 -1]
        A=importdata(plane);%��ȡedcmp����۲���ļ���������i����ȵ�����������
        B=A.data;%����B�洢�˵��λ����Ϣ�����зֱ�Ϊx, y���꣬ux,uy,uzλ����
        m=size(B,1);
        Z((1:m),1)=i;%���z������
        coor1=[B(:,1:2),Z];
        T1=[-L/2-Lx/2,+Ly/2,-Lz];
        COOR1=coor1+T1;
        COOR1(:,1)=COOR1(:,1)*-1;
        COOR1(:,3)=COOR1(:,3)*-1;
        %��ʱCOOR1Ϊ�۲���������ھֲ�����ϵ�µ�����
        COOR2=B(:,3:5);
        COOR2(:,1)=COOR2(:,1)*-1;
        COOR2(:,3)=COOR2(:,3)*-1;
        %��ʱCOOR2Ϊ�۲���������ھֲ�����ϵ�µ�λ��ֵ
        C=[COOR1,COOR2];    
        %��ʱC�����зֱ�ΪX��Y, Z���꣬UX,UY,UZλ����
    %     X1=reshape(C(:,1),[Lx/dx+1,Ly/dy+1]);
    %     Y1=reshape(C(:,2),[Lx/dx+1,Ly/dy+1]);
    %     Z1=reshape(C(:,3),[Lx/dx+1,Ly/dy+1]);
    %     X1=X1';
    %     Y1=Y1';
    %     Z1=Z1';
        %��UX UY UZ������������У�Ϊ��ά���Բ�ֵ��׼��
        UX=reshape(C(:,4),[Lx/dx+1,Ly/dy+1]);
        UY=reshape(C(:,5),[Lx/dx+1,Ly/dy+1]);
        UZ=reshape(C(:,6),[Lx/dx+1,Ly/dy+1]);
        UX=UX';
        UY=UY';
        UZ=UZ';
        Vx(:,:,Lz/dz+1-i/dz)=UX;%��ÿ���X����λ�ƴ洢��Vx���󣬴洢(Lz/dz+1)��
        Vy(:,:,Lz/dz+1-i/dz)=UY;
        Vz(:,:,Lz/dz+1-i/dz)=UZ; 

    end

coord_point=importdata('coord_point_suidao.rpt');%��ȡ׼���õ�ģ�ͱ߽�ڵ��ļ�����ýڵ��ź�����
fid_inp=fopen('disp.inp','w');
fprintf(fid_inp,'%s\n','*Boundary');
   
x=fliplr(0:dx:Lx);
y=(0:dy:Ly)';
z=0:dz:Lz;

x1=coord_point(:,2);
y1=coord_point(:,3);
z1=coord_point(:,4);
%��ά���Բ�ֵ��ģ�ͱ߽��ϸ����λ��ֵ
disp_x=interp3(x,y,z,Vx,x1,y1,z1);
disp_y=interp3(x,y,z,Vy,x1,y1,z1);
disp_z=interp3(x,y,z,Vz,x1,y1,z1);
DISP=[coord_point,disp_x,disp_y,disp_z];
%����õĸ��ڵ�λ��ֵд��disp.inp�ļ�
for k=1:size(DISP)
   for j=1:3
       fprintf(fid_inp,'%s%d%s%d%s%d%s%f\r\n','Part-1-1.',DISP(k,1),', ',j ,', ',j ,', ',DISP(k,j+4));
   end
end
fclose(fid_inp); 
fprintf('disp.inp�ļ�д�����\n')