unit Service;
interface
uses crt;
const
  Enter=#13;
  Esc=#27;
  Left=#75;
  Right=#77;
  Del=#83;
  Up=#72;
  Down=#80;
  Cursor=#16;
type
  ShortString=string[80];
  Data=record
    Day:1..31;
    Month:1..12;
    Year:1700..2020;
  end;
  Book=record
    Name:ShortString;
    Avtor:ShortString;
    Count:word;
    DPubl:Data;
    Izdat:ShortString;
    Price:real;
    Index:ShortString;
  end;
  ColorRec=record
    TxtColor:byte;
    FonColor:byte;
    BorderColor:byte;
  end;
  FileOfBook=file of Book;
  FileOfColorRec=file of ColorRec;
var
  ColorBox:ColorRec;
function Select(MaxX,MaxY,NachCoord:byte):byte;
procedure MainWindow(MWx,MWy,MWx1,MWy1:byte; MWClr:ColorRec; NeedClear:boolean);
procedure UpAllSymbol(var Symbols:ShortString);
procedure ColorSelect(var ColorCfgFile:FileOfColorRec; var Col:ColorRec);
procedure ClearScreen;
procedure Recover(var BckP,Hd:FileOfBook);
procedure BackUp(var fl,BackUpFile:FileOfBook);
procedure CheckFile(var BDFile,BUpFile:FileOfBook; var ConfigFile:FileOfColorRec; var ResBD,ResBUp,ResCfg:boolean);
procedure SetConfig(CfgFnd:boolean; var DefColor:ColorRec; var ConfgFile:FileOfColorRec);
procedure SetFileBD(HdFnd,BUpFnd:boolean; var HdFl,BUpFl:FileOfBook);
procedure CurrentPart(Part:byte);
procedure Hint;
procedure Warning;
procedure ClearWin(Cx,Cy,Cx1,Cy1,FonCol:byte);
implementation
{-------------------стирание окон-------------------------------}
procedure ClearWin(Cx,Cy,Cx1,Cy1,FonCol:byte);
Begin
  Window(Cx,Cy,Cx1,Cy1);
  TextBackGround(FonCol);
  clrscr;
End;
{-----------------конец-----------------------------------------}
{------------------звуковой сигнал------------------------------}
procedure Warning;
Begin
  sound(900);
  delay(10000);
  nosound;
End;
{-----------------конец------------------------------------------}
{---------------подсказка----------------------------------------}
procedure Hint;
Begin
  MainWindow(1,21,80,25,ColorBox,true);
  writeln('      UP - Вверх     DOWN - Вниз     ENTER - Выбор     ESC - Выход');
End;
{-----------------конец------------------------------------------}
{---------------сохранение конфигураций--------------------}
procedure SaveCfg(var Cfg:FileOfColorRec; ClrBx:ColorRec);
Begin
  rewrite(Cfg);
  write(Cfg,ClrBx);
  close(Cfg);
End;
{-------------------конец----------------------------------}
{--------------создание резервной копии--------------------}
procedure BackUp(var fl,BackUpFile:FileOfBook);
var
  BackUpTemp:Book;
Begin
  reset(fl);
  rewrite(BackUpFile);
  while not eof(fl) do
    begin
      read(fl,BackUPTemp);
      write(BackUpFile,BackUpTemp);
    end;
  close(fl);
  close(BackUpFile);
End;
{-----------------конец-------------------------------------}
{--------------восстановление файла-------------------------}
procedure Recover(var BckP,Hd:FileOfBook);
var
  RecoverTemp:Book;
Begin
  reset(BckP);
  rewrite(Hd);
  while not eof(BckP) do
    begin
      read(BckP,RecoverTemp);
      write(Hd,RecoverTemp);
    end;
  close(BckP);
  Close(Hd);
End;
{-----------------конец-------------------------------------}
{---------------движение курсора----------------------------}
function Select(MaxX,MaxY,NachCoord:byte):byte;
var
  KeyUpDown:char;
  SelX,SelY:byte;
Begin
  SelX:=MaxX;
  SelY:=NachCoord;
  GoToXY(SelX,SelY);
  write(cursor);
  repeat
    KeyUpDown:=ReadKey;
    if KeyUpDown=Up then
      begin
        GoToXY(SelX,SelY);
        write(#32);
        dec(SelY);
        if SelY<NachCoord then SelY:=MaxY;
        GoToXY(SelX,SelY);
        write(cursor);
      end;
    if KeyUpDown=Down then
      begin
        GoToXY(SelX,SelY);
        write(#32);
        inc(SelY);
        if SelY>MaxY then SelY:=NachCoord;
        GoToXY(SelX,SelY);
        write(cursor);
      end;
  until (KeyUpDown=Enter) or (KeyUpDown=Esc);
  if KeyUpDown=Esc then Select:=MaxY else Select:=SelY;
End;
{-------------------конец----------------------------------}
{-----------палитра цветов---------------------------------}
function Colors(Param:byte):byte;
var
  ColInd:byte;
Begin
  clrscr;
  ClearScreen;
  MainWindow(22,4,40,25,ColorBox,true);
  case Param of
    1: writeln('Цвет текста: ');
    2: writeln('Цвет фона: ');
    3: writeln('Цвет рамки: ');
  end;
  for ColInd:=0 to 15 do
    begin
      TextColor(ColInd);
      writeln(' Цвет',ColInd );
    end;
  writeln(' Выход');
  case Select(1,18,2) of
    2: Colors:=0;
    3: Colors:=1;
    4: Colors:=2;
    5: Colors:=3;
    6: Colors:=4;
    7: Colors:=5;
    8: Colors:=6;
    9: Colors:=7;
    10: Colors:=8;
    11: Colors:=9;
    12: Colors:=10;
    13: Colors:=11;
    14: Colors:=12;
    15: Colors:=13;
    16: Colors:=14;
    17: Colors:=15;
    18: Colors:=16;
  end;
End;
{----------------конец-------------------------------------}
{---------------выбор цвета--------------------------------}
procedure ColorSelect(var ColorCfgFile:FileOfColorRec; var Col:ColorRec);
var
  Cl:ColorRec;
  ColF:byte;
Begin
  repeat
    ClearScreen;
    CurrentPart(6);
    Hint;
    MainWindow(25,7,50,16,Col,true);
    Cl:=Col;
    writeln('Настройка цветов');
    writeln(' Цвет текста');
    writeln(' Цвет фона');
    writeln(' Цвет рамки');
    writeln(' По умолчанию');
    writeln(' Выход');
    case Select(1,6,2) of
      2: begin
           ColF:=Colors(1);
           if ColF=16 then Col.TxtColor:=Cl.TxtColor else Col.TxtColor:=ColF;
         end;
      3: begin
           ColF:=Colors(2);
           if ColF=16 then Col.FonColor:=Cl.FonColor else Col.FonColor:=ColF;
         end;
      4: begin
           ColF:=Colors(3);
           if ColF=16 then Col.BorderColor:=Cl.BorderColor else Col.BorderColor:=ColF;
         end;
      5: with Col do
           begin
             TxtColor:=1;
             FonColor:=7;
             BorderColor:=9;
           end;
      6: begin
           SaveCfg(ColorCfgFile,Col);
           Exit;
         end;
    end;
  until false;
End;
{-----------------конец------------------------------------}
{---------название текущей части программы-----------------}
procedure CurrentPart(Part:byte);
Begin
  MainWindow(1,1,80,5,ColorBox,true);
  case Part of
    1: begin
         GoToXY(30,1);
         writeln('БАЗА ДАННЫХ');
       end;
    2: begin
         GoToXY(30,1);
         writeln('ДОБАВЛЕНИЕ ИНФОРМАЦИИ');
       end;
    3: begin
         GoToXY(30,1);
         writeln('ИЗМЕНЕНИЕ ИНФОРМАЦИИ');
       end;
    4: begin
         GoToXY(30,1);
         writeln('ПОИСК ИНФОРМАЦИИ');
       end;
    5: begin
         GoToXY(30,1);
         writeln('ПРОСМОТР ИНФОРМАЦИИ');
       end;
    6: begin
         GoToXY(30,1);
         writeln('НАСТРОЙКА');
       end;
    7: begin
         GoToXY(30,1);
         writeln('РЕЗУЛЬТАТЫ ПОИСКА');
       end;
  end;
End;
{-----------------конец------------------------------------}
{-----------очистка экрана---------------------------------}
procedure ClearScreen;
Begin
  window(1,1,80,25);
  TextBackGround(ColorBox.FonColor);
  TextColor(ColorBox.BorderColor);
  clrscr;
  TextColor(ColorBox.TxtColor);
End;
{-------------------конец-----------------------------------}
{---------------прорисовка окна-----------------------------}
procedure MainWindow(MWx,MWy,MWx1,MWy1:byte; MWClr:ColorRec; NeedClear:boolean);
const
  UBorder=#220;
  LBorder=#221;
  RBorder=#222;
  DBorder=#223;
var
  bord,Dx,Dy:byte;
Begin
  window(MWx,MWy,MWx1,MWy1);
  if NeedClear then
    begin
      TextBackGround(MWClr.FonColor);
      clrscr;
    end;
  TextColor(MWClr.BorderColor);
  Dx:=MWx1-MWx;
  Dy:=MWy1-MWy+1;
  for bord:=1 to Dx do
    begin
      GoToXY(bord,1);
      write(UBorder);
      GoToXY(bord,Dy);
      write(DBorder);
    end;
  for bord:=2 to Dy-1 do
    begin
      GoToXy(1,bord);
      write(LBorder);
      GoToXY(Dx,bord);
      write(RBorder);
    end;
  window(MWx+2,MWy+2,MWx1-2,MWy1-1);
  TextColor(MWClr.TxtColor);
End;
{-------------------конец----------------------------------}
{-----преобразование символов строки в заглавные-----------}
procedure UpAllSymbol(var Symbols:ShortString);
var
  StringIndex:byte;
Begin
  for StringIndex:=1 to length(Symbols) do
    Symbols[StringIndex]:=UpCase(Symbols[StringIndex]);
End;
{-------------------конец----------------------------------}
{----------------проверка файлов---------------------------}
procedure CheckFile(var BDFile,BUpFile:FileOfBook; var ConfigFile:FileOfColorRec; var ResBD,ResBUp,ResCfg:boolean);
Begin
  {$I-}
  reset(BDFile);
  {$I+}
  if IoResult=0 then ResBD:=true else ResBD:=false;
  {$I-}
  reset(ConfigFile);
  {$I+}
  if IoResult=0 then ResCfg:=true else ResCfg:=false;
  {$I-}
  reset(BUpFile);
  {$I+}
  if IoResult=0 then ResBUp:=true else ResBUp:=false;
End;
{-------------------конец----------------------------------}
{----установка настроек по умолч. при утере файла конфиг---}
procedure SetConfig(CfgFnd:boolean; var DefColor:ColorRec; var ConfgFile:FileOfColorRec);
Begin
  clrscr;
    if not CfgFnd then
      begin
        with DefColor do
          begin
            TxtColor:=1;
            FonColor:=7;
            BorderColor:=9;
          end;
        Warning;
        MainWindow(15,7,55,18,DefColor,true);
        writeln('Файл конфигураций не найден!!!');
        writeln('Установлены настройки по умолчанию!!!');
        writeln('Нажмите ENTER для продолжения...');
        readln;
      end
    else
      begin
        reset(ConfgFile);
        read(ConfgFile,DefColor);
        close(ConfgFile);
      end;
  SaveCfg(ConfgFile,DefColor);
End;
{-------------------конец----------------------------------}
{-----восстановление при отсутствии файла БД---------------}
procedure SetFileBD(HdFnd,BUpFnd:boolean; var HdFl,BUpFl:FileOfBook);
Begin
  if (not HdFnd) and BUpFnd then
    begin
      Warning;
      MainWindow(15,7,65,18,ColorBox,true);
      writeln('Файл БД не найден!!!');
      writeln;
      writeln('Файл будет восстановлен из резервной копии!!!');
      writeln;
      writeln;
      writeln;
      writeln('Нажмите ENTER для продолжения...');
      readln;
      Recover(BUpFl,HdFl);
    end
  else
    if (not HdFnd) and (not BUpFnd) then
      begin
        Warning;
        rewrite(HdFl);
        close(HdFl);
        MainWindow(15,7,55,18,ColorBox,true);
        writeln('Файл БД не найден!!!');
        writeln;
        writeln('Резервная копия не найдена!!!');
        writeln;
        writeln('Вся информация утеряна!!!');
        writeln;
        writeln('Нажмите ENTER для продолжения...');
        readln;
      end;
  if HdFnd and (not BUpFnd) then
    begin
      Warning;
      MainWindow(15,7,55,18,ColorBox,true);
      writeln('Резервная копия не найдена!!!');
      writeln;
      writeln('Желательно регулярно сохранять ');
      writeln;
      writeln('      резервные копии БД!!!');
      writeln;
      writeln('Нажмите ENTER для продолжения...');
      readln;
    end;
End;
{-------------------конец----------------------------------}
End.