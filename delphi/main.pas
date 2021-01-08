unit main;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  OleCtrls, vcfi, ComCtrls, StdCtrls, ExtCtrls, TeEngine,
  Series, TeeProcs, Chart,port, chartfx3,inifiles, TrayIcon, Menus;

type
  TForm1 = class(TForm)
    Label1: TLabel;
    Edit1: TEdit;
    Label2: TLabel;
    UpDown1: TUpDown;
    Chart1: TChart;
    inchart: TFastLineSeries;
    outchart: TFastLineSeries;
    Timer1: TTimer;
    Label3: TLabel;
    StatusBar1: TStatusBar;
    Edit2: TEdit;
    Edit3: TEdit;
    Edit4: TEdit;
    UpDown2: TUpDown;
    UpDown3: TUpDown;
    UpDown4: TUpDown;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    TrayIcon1: TTrayIcon;
    PopupMenu1: TPopupMenu;
    N1: TMenuItem;
    N2: TMenuItem;
    procedure Timer1Timer(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure Button1Click(Sender: TObject);
    procedure TrayIcon1Click(Sender: TObject);
    procedure N2Click(Sender: TObject);
    procedure FormHide(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

const
  inifilename:string='hot.ini';
  
var
  Form1: TForm1;
  buf:array[1..10] of integer;
  sum:integer;
  point:integer;
  Outvalue:integer;
  error,errorl,errorl2:single;
  mypath:string;
  inifile:Tinifile;
implementation

{$R *.DFM}


procedure TForm1.Timer1Timer(Sender: TObject);
var
  realvalue:single;
  givenvalue,i:integer;
begin
  givenvalue:=strtoint(edit1.text);
  sum:=0;
  for i:=1 to 10 do
  begin
    sum:=sum+PortReadByte($313);
    PortWriteByte($312,0);
    while((PortReadByte($312)and 1)=0) do;
  end;
  realvalue:=(sum*10)/256;
  label2.caption:='实际温度：'+floattostr(realvalue);
  inchart.addxy(inchart.xvalues.last+1,realvalue,'',clteecolor);
  if inchart.count>=200 then inchart.Delete(0);
//  if realvalue>givenvalue then dec(outvalue);
//  if realvalue<givenvalue then inc(outvalue);
  error:=givenvalue - realvalue;
  outvalue:=outvalue+trunc((strtoint(edit2.text)*(error-errorl)+strtoint(edit3.text)*error+strtoint(edit4.text)*(error-2*errorl+errorl2))/ 100);
  errorl2:=errorl;
  errorl:=error;
  if outvalue<0 then outvalue:=0;
  if outvalue>255 then outvalue:=255;
  label3.Caption:='输出量：'+inttostr(outvalue);
  outchart.Addxy(outchart.xvalues.last+1,outvalue,'',clteecolor);
  if outchart.count>=200 then outchart.Delete(0);
  PortWriteByte($311,outvalue);
  PortReadByte($311);
  PortWriteByte($312,0);
end;

procedure TForm1.FormCreate(Sender: TObject);
var i:integer;
begin
  PortWriteByte($312,0);
  inchart.FillSampleValues(1);
  outchart.FillSampleValues(1);
  outvalue:=10;
  for i:=1 to 10 do buf[point]:=0;
  sum:=0;
  point:=1;
  mypath:=extractfilepath(application.exename);
  inifile:=TIniFile.Create(mypath+inifilename);
  updown1.Position:=strtoint(inifile.readstring('GIVENVALUE','GIVEN','25'));
  updown2.Position:=strtoint(inifile.readstring('GIVENVALUE','KP','1000'));
  updown3.Position:=strtoint(inifile.readstring('GIVENVALUE','KI','100'));
  updown4.Position:=strtoint(inifile.readstring('GIVENVALUE','KD','200'));
  inifile.free;
  timer1.Enabled:=true;
end;

procedure TForm1.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  inifile:=TIniFile.Create(mypath+inifilename);
  inifile.Writestring('GIVENVALUE','GIVEN',edit1.text);
  inifile.Writestring('GIVENVALUE','KP',edit2.text);
  inifile.Writestring('GIVENVALUE','KI',edit3.text);
  inifile.Writestring('GIVENVALUE','KD',edit4.text);
  inifile.free;

end;

procedure TForm1.Button1Click(Sender: TObject);
begin
  inifile:=TIniFile.Create(mypath+inifilename);
  edit1.text:=inifile.readstring('GIVENVALUE','GIVEN','25');
  edit2.text:=inifile.readstring('GIVENVALUE','KP','1000');
  edit3.text:=inifile.readstring('GIVENVALUE','KI','100');
  edit4.text:=inifile.readstring('GIVENVALUE','KD','200');
  inifile.free;

end;

procedure TForm1.TrayIcon1Click(Sender: TObject);
begin
  form1.show;
end;

procedure TForm1.N2Click(Sender: TObject);
begin
  close;
end;

procedure TForm1.FormHide(Sender: TObject);
begin
  ShowWindow(Application.Handle, SW_HIDE);
  trayicon1.Active:=true;
end;

procedure TForm1.FormShow(Sender: TObject);
begin
  trayicon1.Active:=false;
end;

end.
