program BDLibrary;
uses Crt,Service;
var
  BackFile,HeadFile:FileOFBook;
  CfgFile:FileOfColorRec;
  OneBook:Book;
  BDFound,BackFound,CfgFound:boolean;
{-----------------������� ����-----------------------------}
function Menu:byte;
Begin
  ClearScreen;
  CurrentPart(1);
  Hint;
  MainWindow(18,7,58,17,ColorBox,true);
  writeln(' �������� ���ଠ�� � ����� �����');
  writeln(' ����     ���ଠ樨');
  writeln(' ��ᬮ��  ���ଠ樨');
  writeln(' �������   १. �����');
  writeln(' ����⠭����� 䠩� ��');
  writeln(' ����ன��');
  writeln(' ��室');
  Menu:=Select(1,7,1);
End;
{-----------------�����-------------------------------------}
{------------㤠����� �� 䠩��------------------------------}
procedure DelFromFile(var FileForDel:FileOfBook; PosInFile:integer; NeedMessage:boolean);
var
  TempFile:FileOfBook;
  DelBook:Book;
  NeedSave:char;
Begin
  if NeedMessage then
    begin
      repeat
        Warning;
        MainWindow(19,10,50,16,ColorBox,true);
        writeln('������� ��࠭��� �����?');
        writeln;
        writeln('ENTER - ��    ESC - ���');
        NeedSave:=ReadKey;
      until (NeedSave=Enter) or (NeedSave=Esc);
    if NeedSave=Esc then Exit;
  end;
  assign(TempFile,'Temp.tmp');
  rewrite(TempFile);
  reset(FileForDel);
  while not eof(FileForDel) do
    begin
      read(FileForDel,DelBook);
      if PosInFile<>FIlePos(FileForDel)-1 then write(TempFile,DelBook);
    end;
  close(TempFile);
  close(FileForDel);
  reset(TempFile);
  rewrite(FileForDel);
  while not eof(TempFile) do
    begin
      read(TempFile,DelBook);
      write(FileForDel,DelBook);
    end;
  close(TempFile);
  close(FileForDel);
  Erase(TempFile);
End;
{-----------------�����-------------------------------------}
{------------�८�ࠧ������ ��ப� � �᫮------------------}
function StrToReal(x1,y1,x2,y2:byte):real;
var
  RealResultat:real;
  Code,X,Y:integer;
  Stka:ShortString;
Begin
  Code:=1;
  x:=WhereX;
  y:=WhereY;
  while Code<>0 do
    begin
      readln(Stka);
      val(Stka,RealResultat,Code);
      If Code<>0 then
        begin
          Warning;
          MainWindow(18,21,x2,25,ColorBox,true);
          write('�訡��!!!  ������ �᫮!!!');
          MainWindow(x1,y1,x2,y2,ColorBox,false);
          GoToXY(x,y);
          ClrEol;
        end;
    end;
  ClearWin(18,21,x2,25,ColorBox.FonColor);
  MainWindow(x1,y1,x2,y2,ColorBox,false);
  GoToXY(1,y+1);
  StrToReal:=RealResultat;
End;
function StrToWord(x1,y1,x2,y2:byte):Word;
var
  WordResultat:word;
  Code,X,Y:integer;
  Stka:ShortString;
Begin
  Code:=1;
  x:=WhereX;
  y:=WhereY;
  while Code<>0 do
    begin
      readln(Stka);
      val(Stka,WordResultat,Code);
      If Code<>0 then
        begin
          Warning;
          MainWindow(18,21,x2,25,ColorBox,true);
          write('�訡��!!!  ������ �᫮!!!');
          MainWindow(x1,y1,x2,y2,ColorBox,false);
          GoToXY(x,y);
          ClrEol;
        end;
    end;
  ClearWin(18,21,x2,25,ColorBox.FonColor);
  MainWindow(x1,y1,x2,y2,ColorBox,false);
  GoToXY(1,y+1);
  StrToWord:=WordResultat;
End;
{-----------------�����-------------------------------------}
{---------------���������� � 䠩�---------------------------}
function AddToFile(var HdFile:FileOfBook; InfForRec:Book; NeedMessage:boolean):boolean;
var
  NeedSave:char;
Begin
  if NeedMessage then
    begin
      repeat
        Warning;
        MainWindow(19,10,50,16,ColorBox,true);
        writeln('���࠭��� ���ଠ��?');
        writeln;
        writeln('ENTER - ��    ESC - ���');
        NeedSave:=ReadKey;
      until (NeedSave=Enter) or (NeedSave=Esc);
      if NeedSave=Esc then
        begin
          AddToFile:=false;
          Exit;
        end;
    end;
  AddToFile:=true;
  reset(HdFile);
  seek(HdFile,FileSize(HdFile));
  write(HdFile,InfForRec);
  close(HdFile);
End;
{-----------------�����-------------------------------------}
{-------------���������� ���.-------------------------------}
procedure Add(var NewBook:Book);
Begin
  ClearScreen;
  CurrentPart(2);
  MainWindow(18,7,60,20,ColorBox,true);
  with NewBook do
    begin
      write('��������: '); readln(Name);
      UpAllSymbol(Name);
      write('����: '); readln(Avtor);
      UpAllSymbol(Avtor);
      writeln('��� �������: ');
      write('��᫮: '); DPubl.Day:=StrToWord(18,7,60,20);
      write('�����: '); DPubl.Month:=StrToWord(18,7,60,20);
      write('���: '); DPubl.Year:=StrToWord(18,7,60,20);
      write('����⥫��⢮: '); readln(Izdat);
      UpAllSymbol(Izdat);
      write('����: '); Price:=StrToReal(18,7,60,20);
      write('������: '); readln(Index);
      write('������⢮ ����: '); Count:=StrToWord(18,7,60,20);
    end;
   AddToFile(HeadFile,NewBook,true);
End;
{-----------------�����-------------------------------------}
{------------�뢮� ���ଠ樨 � ⠡���---------------------}
procedure VivInfTabl(var OutFile:FileOFBook);
var
  OutBook:Book;
  OutX,OutY:byte;
  kolvo:byte;
  Key:char;
Begin
  reset(OutFile);
  MainWindow(1,1,80,25,ColorBox,true);
  kolvo:=3;
  writeln('��������         �����     ��� ���.    �-��  ���-��      ����      ������ ');
  while not eof(OutFile) do
    begin
      inc(kolvo,2);
      if kolvo>=21 then
        begin
          kolvo:=5;
          window(1,23,80,25);
          GoToXY(26,1);
          writeln('ENTER - �த������   ESC - ��室');
          Key:=ReadKey;
          if Key=Esc then Exit else
            begin
              MainWindow(1,1,80,25,ColorBox,true);
              writeln('��������         �����     ��� ���.    �-��  ���-��      ����      ������ ');
            end;
        end;
      read(OutFile,OutBook);
      with OutBook do
        begin
          window(3,kolvo,18,kolvo+3); write(FilePos(OutFile),'|',Name);
          window(20,kolvo,28,kolvo+3); write(Avtor);
          window(30,kolvo,39,kolvo+3);write(DPubl.Day:2,'/',DPubl.Month:2,'/',DPubl.Year:4);
          window(42,kolvo,46,kolvo+3);write(Count:4);
          window(48,kolvo,58,kolvo+3);write(Izdat);
          window(60,kolvo,68,kolvo+3);write(Price:4:0);
          window(70,kolvo,78,kolvo+3);writeln(Index);
        end;
    end;
  close(OutFile);
  window(1,23,80,25);
  GoToXY(30,1);
  writeln('ENTER - ��室');
  readln;
End;
{-----------------�����-------------------------------------}
{-------------��������� ���.--------------------------------}
function Change(var BookForChg:Book):boolean;
const
  Chng:boolean=false;
Begin
  ClearScreen;
  with BookForChg do
    repeat
      CurrentPart(3);
      MainWindow(18,7,60,21,ColorBox,true);
      writeln(' ��������: ',Name);
      writeln(' ����: ',Avtor);
      writeln(' ��� �������: ');
      writeln(' ��᫮: ',DPubl.Day);
      writeln(' �����: ',DPubl.Month);
      writeln(' ���: ',DPubl.Year);
      writeln(' ����⥫��⢮: ',Izdat);
      writeln(' ����: ',Price:4:2);
      writeln(' ������: ',Index);
      writeln(' ������⢮ ����: ',Count);
      writeln(' ��室');
      case Select(1,11,1) of
        1: begin
             write('��������: ');
             ClrEol;
             readln(Name);
             UpAllSymbol(BookForChg.Name);
             Chng:=true;
           end;
        2: begin
             write('����: ');
             ClrEol;
             readln(BookForChg.Avtor);
             UpAllSymbol(BookForChg.Avtor);
             Chng:=true;
           end;
        4: begin
             write('��᫮: ');
             ClrEol;
             BookForChg.DPubl.Day:=StrToWord(18,7,60,21);
             Chng:=true;
           end;
        5: begin
             write('�����: ');
             ClrEol;
             BookForChg.DPubl.Month:=StrToWord(18,7,60,21);
             Chng:=true;
           end;
        6: begin
             write('���: ');
             ClrEol;
             BookForChg.DPubl.Year:=StrToWord(18,7,60,21);
             Chng:=true;
           end;
        7: begin
             write('����⥫��⢮: ');
             ClrEol;
             readln(BookForChg.Izdat);
             UpAllSymbol(BookForChg.Izdat);
             Chng:=true;
           end;
        8: begin
             write('����: ');
             ClrEol;
             BookForChg.Price:=StrToReal(18,7,60,21);
             Chng:=true;
           end;
        9: begin
             write('������: ');
             ClrEol;
             readln(BookForChg.Index);
             Chng:=true;
           end;
       10: begin
             write('������⢮ ����: ');
             ClrEol;
             BookForChg.Count:=StrToWord(18,7,60,21);
             Chng:=true;
           end;
       11: begin
             Change:=Chng;
             Exit;
           end;
      end;
    until false;
End;
{-----------------�����-------------------------------------}
{-------------�뢮� �� ������ ��.(����窠)-----------------}
procedure VivInfOne(var OutFile:FileOFBook; Variant:byte);
var
  OutBook,OutBook1:Book;
  Key:char;
  Pos:integer;
Begin
  reset(OutFile);
  repeat
    CurrentPart(Variant);
    MainWindow(1,20,80,25,ColorBox,true);
    writeln('    <- LEFT - �।��騩       ESC - ��室       ������騩 - RIGHT ->');
    writeln('                      ENTER - ��������    DEL - �������');
    Pos:=FilePos(OutFile);
    if Pos=FileSize(OutFile) then Seek(OutFIle,0);
    if FileSize(OutFile)=0 then Exit;
    read(OutFile,OutBook);
    MainWindow(18,6,60,18,ColorBox,true);
    with OutBook do
      begin
        writeln('����� ',#252,': ',FilePos(OutFile));
        writeln;
        writeln('��������: ',Name);
        writeln('����: ',Avtor);
        writeln('��� �������: ',DPubl.Day,'/',DPubl.Month,'/',DPubl.Year);
        writeln('����⥫��⢮: ',Izdat);
        writeln('����: ',Price:4:2);
        writeln('������: ',Index);
        writeln('������⢮ ����: ',Count);
      end;
    repeat
      Key:=ReadKey;
    until (Key=Esc) or (Key=Left) or (Key=Right) or (Key=Enter) or (Key=Del);
    if Key=Del then
      begin
        close(OutFile);
        DelFromFile(OutFile,Pos,true);
        reset(OutFile);
      end;
    if Key=Enter then
      begin
        ClearWin(1,19,80,25,ColorBox.FonColor);
        OutBook1:=OutBook;
        if Change(OutBook) then
          begin
            DelFromFile(OutFile,FilePos(OutFile)-1,false);
            if not AddToFile(OutFile,OutBook,true) then
              begin
                AddToFile(OutFile,OutBook1,false);
                ClearScreen;
              end
            else ClearScreen;
            reset(OutFile);
          end;
      end;
    if Key=Left then
      if FilePos(OutFile)-1>0 then Seek(OutFile,Pos-1) else Seek(OutFile,FileSize(OutFile)-1);
  until Key=Esc;
  close(OutFile);
End;
{-----------------�����-------------------------------------}
{--------------���� �뢮�� ���ଠ樨-----------------------}
procedure VivodInf;
Begin
  repeat
    ClearScreen;
    CurrentPart(5);
    Hint;
    MainWindow(20,7,50,15,ColorBox,true);
    writeln(' �뢮� � ⠡���');
    writeln(' �뢮� � ०��� ����窨');
    writeln(' ��室');
    case Select(1,3,1) of
      1: VivInfTabl(HeadFile);
      2: VivInfOne(HeadFile,5);
      3: Exit;
    end;
  until false;
End;
{-----------------�����-------------------------------------}
{-----------------����-------------------------------------}
procedure Search(var FileForSearch:FileOfBook);
const
  ResFound:boolean=false;
var
  TempBook:Book;
  SearchSt:ShortString;
  SearchWord:Word;
  SearchReal:Real;
  Slct:Byte;
  SearchRes:FileOfBook;
Begin
  assign(SearchRes,'SearchRes.tmp');
  repeat
    rewrite(SearchRes);
    reset(FileForSearch);
    ClearScreen;
    CurrentPart(4);
    Hint;
    MainWindow(18,6,50,19,ColorBox,true);
    writeln(' ������⢮ ����');
    writeln(' ����⥫��⢮');
    writeln(' ��������');
    writeln(' ����');
    writeln(' ������');
    writeln(' ��᫮');
    writeln(' �����');
    writeln(' ���');
    writeln(' ����');
    writeln(' ��室');
    Slct:=Select(1,10,1);
    ClearScreen;
    CurrentPart(4);
    MainWindow(18,10,55,15,ColorBox,true);
    writeln('������ ���ଠ�� ��� ���᪠:');
    case Slct of
      2,3,4,5: begin
                 write(Cursor); readln(SearchSt);
                 UpAllSymbol(SearchSt);
                 while FIlePos(FileForSearch)<FileSize(FileForSearch) do
                   begin
                     read(FileForSearch,TempBook);
                     with TempBook do
                       if (Name=SearchSt) or (Avtor=SearchSt) or (Izdat=SearchSt) or (Index=SearchSt) then
                         begin
                           write(SearchRes,TempBook);
                           DelFromFile(FileForSearch,FilePos(FileForSearch)-1,false);
                           reset(FileForSearch);
                           ResFound:=true;
                         end;
                   end;
                 close(SearchRes);
               end;
      1,6,7,8: begin
                 write(Cursor); SearchWord:=StrToWord(18,10,55,15);
                 while FIlePos(FileForSearch)<FileSize(FileForSearch) do
                   begin
                     read(FileForSearch,TempBook);
                     with TempBook do
                       if (DPubl.Day=SearchWord) or (DPubl.Month=SearchWord)
                         or (DPubl.Year=SearchWord) or (Count=SearchWord) then
                           begin
                             write(SearchRes,TempBook);
                             DelFromFile(FileForSearch,FilePos(FileForSearch)-1,false);
                             reset(FileForSearch);
                             ResFound:=true;
                           end;
                   end;
                 close(SearchRes);
                end;
            9: begin
                 write(Cursor); SearchReal:=StrToReal(18,10,55,15);
                 while FIlePos(FileForSearch)<FileSize(FileForSearch) do
                   begin
                     read(FileForSearch,TempBook);
                     if TempBook.Price=SearchReal then
                       begin
                         write(SearchRes,TempBook);
                         DelFromFile(FileForSearch,FilePos(FileForSearch)-1,false);
                         reset(FileForSearch);
                         ResFound:=true;
                       end;
                   end;
                 close(SearchRes);
               end;
           10: begin
                 Erase(SearchRes);
                 Exit;
               end;
    end;
    If not ResFound then
      begin
        ClearScreen;
        CurrentPart(7);
        MainWindow(18,9,55,15,ColorBox,true);
        writeln('���� �� ��� १���⮢!');
        writeln;
        writeln('������ ENTER ��� �த�������...');
        readln;
      end
    else
      begin
        VivInfOne(SearchRes,7);
        close(FileForSearch);
        reset(SearchRes);
        while not eof(SearchRes) do
          begin
            read(SearchRes,TempBook);
            AddToFile(FileForSearch,TempBook,false);
          end;
        close(SearchRes);
      end;
  until false;
End;
{-----------------�����-------------------------------------}
{----------------�᭮���� �ணࠬ��-------------------------}
BEGIN
  assign(HeadFile,'DBFile.db');
  assign(BackFile,'BackUp.bup');
  assign(CfgFile,'Lib.cfg');
  CheckFile(HeadFile,BackFile,CfgFile,BDFound,BackFound,CfgFound);
  SetConfig(CfgFound,ColorBox,CfgFile);
  SetFileBD(BDFound,BackFound,HeadFile,BackFile);
  repeat
    case Menu of
      1: begin
           Add(OneBook);
         end;
      2: begin
           Search(HeadFile);
         end;
      3: begin
           VivodInf;
         end;
      4: begin
           BackUp(HeadFile,BackFile);
         end;
      5: begin
           Recover(BackFile,HeadFile);
         end;
      6: begin
           ColorSelect(CfgFile,ColorBox);
         end;
      7: Exit;
    end;
  until false;
END.
{-----------------�����-------------------------------------}