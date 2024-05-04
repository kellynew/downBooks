unit UnitMain;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, IdIOHandler, IdIOHandlerStack, IdSSL, IdSSLOpenSSL,
  ComCtrls, StdCtrls, Grids, UnitStringGrid, OleCtrls, SHDocVw;//, UnitTrayIcon;

type
  TfrmMain = class(TForm)
    sgBooks: TStringGrid;
    GroupBox1: TGroupBox;
    StatusBar1: TStatusBar;
    Timer1: TTimer;
    cbxND: TComboBox;
    Label1: TLabel;
    cbxKM: TComboBox;
    Label2: TLabel;
    Label3: TLabel;
    cbxCB: TComboBox;
    btnOpen: TButton;
    btnNext: TButton;
    btnPre: TButton;
    WebBrowser1: TWebBrowser;
    moLog: TMemo;
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure Timer1Timer(Sender: TObject);
    procedure cbxNDClick(Sender: TObject);
    procedure btnOpenClick(Sender: TObject);
    procedure btnNextClick(Sender: TObject);
    procedure btnPreviewClick(Sender: TObject);
    procedure WebBrowser1NewWindow2(Sender: TObject; var ppDisp: IDispatch;
      var Cancel: WordBool);
    procedure FormResize(Sender: TObject);
  private
    { Private declarations }
    FIndex:Integer;
  public
    { Public declarations }
  end;

var
  frmMain: TfrmMain;

implementation

{$R *.dfm}
{$R WindowsXP.res}

uses ShellAPI, SuperObject, WinInet;

type
    TBook=record
      id:string[36];
      title:string[80];
      cb:string[50];
      preview:string[180];
    end;

var mBooks:array[1..3000]of TBook;
    mCount:Integer;

//写文件
procedure WriteRec(const sFileName: string);
var fm: TFileStream;
begin
    fm := TFileStream.Create(sFileName, fmCreate or fmOpenWrite);
    try
        fm.Write(mBooks,SizeOf(mBooks));
    finally
        fm.Free;
    end;
end;

//读取记录
procedure ReadRec(const sFileName: string);
var fm: TFileStream;
begin
    if FileExists(sFileName) <> True then
        exit;
    fm := TFileStream.Create(sFileName, fmOpenRead);
    try
        fm.Read(mBooks,SizeOf(mBooks));
    finally
        fm.Free;
    end;
end;

function subString(aInputStr: string; const aStr_L, aStr_R: string; const ret: Integer = 0): string; //提取字符串
var
    i: integer;
begin
    Result := '';
    if Trim(aInputStr) = '' then
        Exit;
    i := Pos(aStr_L, aInputStr);
    if i = 0 then
        exit;
    delete(aInputStr, 1, i + Length(aStr_L) - 1);
    i := Pos(aStr_R, aInputStr);
    if i = 0 then
        exit;
    if (ret = 1) then
        Result := aStr_L + trim(Copy(aInputStr, 1, i - 1))
    else if (ret = 2) then
        Result := aStr_L + trim(Copy(aInputStr, 1, i - 1)) + aStr_R
    else
        Result := trim(Copy(aInputStr, 1, i - 1));
end;
function getUrl(const aURL,aFileName:string):string;
const
    dwFlags=INTERNET_FLAG_DONT_CACHE or INTERNET_FLAG_RELOAD or INTERNET_FLAG_SECURE or INTERNET_FLAG_NO_COOKIES or INTERNET_FLAG_NO_CACHE_WRITE;
    BuffSize=8192;
    HttpHeaders ='Accept: */*';
var FSession, FRequest: hInternet;
    Data: Array[0..BuffSize-1] of Char;//1024
    BytesToRead: DWord;
    mem:TMemoryStream;
    txt:string;
begin
    mem:=TMemoryStream.Create ;

    FSession := InternetOpen('Mozilla/5.0 (Windows NT 6.1; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/95.0.4638.69 Safari/537.36',INTERNET_OPEN_TYPE_PRECONFIG, nil, nil, 0); //创建会话
    FRequest := InternetOpenUrl(FSession, PChar(AURL), HttpHeaders, length(HttpHeaders), dwFlags, 0);
    Result:='';fillchar(data,BuffSize,0);
    while InternetReadFile(FRequest, @Data, SizeOf(Data), BytesToRead) do begin
        if BytesToRead=0 then break;
        mem.Write(Data, BytesToRead);
        frmMain.StatusBar1.Panels[4].Text := '大小 '+FormatFloat('###,###',mem.size);
        Application.ProcessMessages ;
    end;
    InternetCloseHandle(FRequest);
    InternetCloseHandle(FSession);
    if aFileName='' then begin
        SetLength(Result, mem.size);
        mem.Position :=0;
        mem.Read(Result[1], mem.Size);
        txt:=Utf8ToAnsi(Result);
        if txt<>'' then begin
            Result := txt;
        end;
    end
    else begin
        Result := IntToStr(mem.size);
        if mem.size>999 then begin
            mem.SaveToFile(aFileName);
        end;
    end;
    mem.Free;
end;

procedure TfrmMain.FormCreate(Sender: TObject);
begin
    {$I VMProtectBegin.inc}
    //AddIconToTray(Application.Icon.Handle,self); //添加图标到系统托盘
    sgBooks.FAutoRowNO := True;
    sgBooks.Cells[0,0]:='序号';
    sgBooks.Cells[1,0]:='标题';
    sgBooks.Cells[2,0]:='版本';
    WebBrowser1.Silent := True;
    WebBrowser1.Navigate('about:blank');
    {$I VMProtectEnd.inc}
end;

procedure TfrmMain.FormClose(Sender: TObject; var Action: TCloseAction);
begin
    if sgBooks.Cells[1, 1]<>''then begin
        WriteRec(ExtractFilePath(ParamStr(0))+'books.xl');
    end;
end;

procedure TfrmMain.Timer1Timer(Sender: TObject);
var json, obj:ISuperObject;
    oList, oArr, tag_list: TSuperArray;
    s,p:string;
    i,j,k:Integer;
begin
    Timer1.Enabled := False;
    mCount :=0;
    p:=ExtractFilePath(ParamStr(0))+'books.xl';
    if FileExists(p) then begin
        ReadRec(p);
        StatusBar1.Panels[2].Text := '加载数据中 ...';
        StatusBar1.Refresh ;
        for i:=Low(mBooks) to High(mBooks) do begin
            if mBooks[i].title='' then Break;
            inc(mCount);
            sgBooks.Cells[1,i] := mBooks[i].title ;
            sgBooks.Cells[2,i] := mBooks[i].cb ;
            sgBooks.Cells[3,i] := IntToStr(i) ;
        end;
        StatusBar1.Panels[2].Text := '加载完成';
    end
    else begin
        s:=getUrl('https://s-file-1.ykt.cbern.com.cn/zxx/ndrs/resources/tch_material/version/data_version.json','');
        json:=SO(s);
        if (json=nil)or(s='')then begin
            StatusBar1.Panels[2].Text := '读取版本数据失败';
            Exit;
        end;
        StatusBar1.Panels[2].Text := '读取数据中 ...';
        StatusBar1.Refresh ;
        s:=json.S['urls'];
        oList:=SO('['+s+']').AsArray;
        if oList=nil then Exit;
        for i:= 0 to oList.Length-1 do begin
            StatusBar1.Panels[2].Text := '读取数据中 ...'+Format('%d/%d',[i+1,oList.Length]);
            StatusBar1.Refresh ;
            p:=oList.S[i];
            s:=getUrl(p,'');
            oArr:=SO(s).AsArray;
            if oArr=nil then Exit;
            for j:= 0 to oArr.Length-1 do begin
                inc(mCount);
                json:=oArr.O[j];
                mBooks[mCount].id := json.S['id'];
                mBooks[mCount].title := json.S['title'];
                tag_list := json.A['tag_list'];
                for k:=0 to tag_list.Length - 1 do begin
                    obj:=tag_list.O[k];
                    s:=obj.S['tag_name'];
                    if (Pos('版',s)>0) then begin
                        mBooks[mCount].cb := s;
                        Break;
                    end;
                end;
                if Pos('义务教育',mBooks[mCount].title)>0 then begin
                    mBooks[mCount].title := StringReplace(mBooks[mCount].title,'义务教育教科书·','',[rfReplaceAll]);
                    mBooks[mCount].title := StringReplace(mBooks[mCount].title,'义务教育教科书 · ','',[rfReplaceAll]);
                    mBooks[mCount].title := StringReplace(mBooks[mCount].title,'义务教育教科书','',[rfReplaceAll]);
                    mBooks[mCount].title := StringReplace(mBooks[mCount].title,'义务教育三至五年级','',[rfReplaceAll]);
                    mBooks[mCount].title := StringReplace(mBooks[mCount].title,'义务教育三至六年级·','',[rfReplaceAll]);
                end;
                if Pos('普通高中',mBooks[mCount].title)>0 then begin
                    mBooks[mCount].title := StringReplace(mBooks[mCount].title,'普通高中教科书','普高',[rfReplaceAll]);
                end;
                if Pos('?',mBooks[mCount].title)>0 then begin
                    mBooks[mCount].title := StringReplace(mBooks[mCount].title,'?','·',[rfReplaceAll]);
                end;
                if Pos('?',mBooks[mCount].cb)>0 then begin
                    mBooks[mCount].cb := StringReplace(mBooks[mCount].cb,'?','·',[rfReplaceAll]);
                end;

                if Pos('培智',mBooks[mCount].title)>0 then begin
                    mBooks[mCount].cb := '培智学校义务教育实验教科书生活';
                    mBooks[mCount].title := StringReplace(mBooks[mCount].title,'培智学校义务教育实验教科书生活','',[rfReplaceAll]);
                end
                else if Pos('盲校',mBooks[mCount].title)>0 then begin
                    mBooks[mCount].cb := '盲校义务教育实验教科书';
                    mBooks[mCount].title := StringReplace(mBooks[mCount].title,'盲校义务教育实验教科书','',[rfReplaceAll]);
                    mBooks[mCount].title := StringReplace(mBooks[mCount].title,'盲校义务教育实验','',[rfReplaceAll]);
                end
                else if Pos('聋校',mBooks[mCount].title)>0 then begin
                    mBooks[mCount].cb := '聋校义务教育实验教科书';
                    mBooks[mCount].title := StringReplace(mBooks[mCount].title,'聋校义务教育实验教科书','',[rfReplaceAll]);
                end;
                s:=json.S['custom_properties.preview.Slide1'];
                for k:=Length(s) downto 1 do begin
                    if s[k]='/' then begin
                        s:=Copy(s,1,k);
                        Break;
                    end;
                end;
                mBooks[mCount].preview := s;
                sgBooks.Cells[1,mCount] := mBooks[mCount].title ;
                sgBooks.Cells[2,mCount] := mBooks[mCount].cb ;
                sgBooks.Cells[3, mCount] := IntToStr(mCount) ;
            end;
        end;
        StatusBar1.Panels[2].Text := '读取完成';
    end;
    sgBooks.RowCount := mCount+1;
    StatusBar1.Panels[1].Text := Format('总数 %d',[mCount]);
end;

procedure TfrmMain.cbxNDClick(Sender: TObject); //筛选
var i,k:Integer;
begin
    k:=0;
    for i:=1 to mCount do begin
        if cbxND.ItemIndex>0 then begin //年段
            if cbxND.ItemIndex=1 then begin     //小学
                if (Pos('一年级',mBooks[i].title)=0)and
                    (Pos('二年级',mBooks[i].title)=0)and
                    (Pos('三年级',mBooks[i].title)=0)and
                    (Pos('四年级',mBooks[i].title)=0)and
                    (Pos('五年级',mBooks[i].title)=0)and
                    (Pos('六年级',mBooks[i].title)=0)then Continue
            end
            else if cbxND.ItemIndex=2 then begin    //初中
                if (Pos('七年级',mBooks[i].title)=0)and
                    (Pos('八年级',mBooks[i].title)=0)and
                    (Pos('九年级',mBooks[i].title)=0) then Continue
            end
            else if cbxND.ItemIndex=3 then begin    //高中
                if (Pos('普高',mBooks[i].title)=0)and(Pos('高中',mBooks[i].title)=0) then Continue
            end;
        end;
        if cbxKM.ItemIndex>0 then begin
            if (Pos(cbxKM.Text,mBooks[i].title)=0)then Continue
        end;
        if cbxCB.ItemIndex>0 then begin
            if (Pos(cbxCB.Text,mBooks[i].cb)=0)then Continue
        end;
        Inc(k);
        sgBooks.Cells[1, k] := mBooks[i].title ;
        sgBooks.Cells[2, k] := mBooks[i].cb ;
        sgBooks.Cells[3, k] := IntToStr(i) ;
    end;
    sgBooks.RowCount := k+1;
    StatusBar1.Panels[1].Text := Format('当前 %d',[k]);
end;

procedure TfrmMain.btnOpenClick(Sender: TObject);
var i,k:Integer;
    p,url:string;
begin
    k:=sgBooks.Row;
    if sgBooks.Cells[3, k]='' then Exit;
    StatusBar1.Panels[2].Text := '下载中 ... ';
    i:=StrToIntDef(sgBooks.Cells[3, k], 1);
    url:='https://r1-ndr.ykt.cbern.com.cn/edu_product/esp/assets_document/'+mBooks[i].id+'.pkg/pdf.pdf';
    p:=ExtractFilePath(ParamStr(0))+'assets\'+mBooks[i].title+'_'+sgBooks.Cells[2, k]+'.pdf';
    if FileExists(p)=False then begin
        ForceDirectories(ExtractFilePath(p)) ;
        StatusBar1.Panels[3].Text :=p;
        StatusBar1.Refresh ;
        if StrToIntDef( getUrl(url,p), 0)<9999 then begin
//            url:='https://r1-ndr.ykt.cbern.com.cn/edu_product/esp/assets/'+mBooks[i].id+'.pkg/pdf.pdf';
//            if StrToIntDef( getUrl(url,p), 0)<5000999 then begin
                StatusBar1.Panels[3].Text := '下载失败 '+ url;
                moLog.Lines.Insert(0, url);
                Exit;
//            end;
        end;
    end;
    moLog.Lines.Insert(1, url);
    ShellExecute(0, 'OPEN', PChar('"'+p+'"'), nil,  nil, SW_HIDE);
    StatusBar1.Panels[3].Text := p;
    StatusBar1.Panels[2].Text := '下载完成';
end;

procedure TfrmMain.btnNextClick(Sender: TObject);
var k,d,i:Integer;
    s,url:string;
begin
    k:=sgBooks.Row;
    if sgBooks.Cells[3, k]='' then Exit;
    i:=StrToIntDef(sgBooks.Cells[3, k], 1);
    d:=TButton(Sender).Tag;
    if d<0 then begin
        if FIndex>1 then begin
            Inc(FIndex,d);
        end;
    end
    else Inc(FIndex,d);
    url:=format('%d.jpg',[FIndex]);
    s:='<img src="'+mBooks[i].preview+url+'" width="auto" height="100%">';
    WebBrowser1.OleObject.Document.clear;
    WebBrowser1.OleObject.Document.Write(s);
    WebBrowser1.OleObject.Document.close;
    StatusBar1.Panels[3].Text := sgBooks.Cells[2, k] + ' - '+ url;
end;

procedure TfrmMain.btnPreviewClick(Sender: TObject);
var i,k:Integer;
    s,url:string;
begin
    k:=sgBooks.Row;
    if sgBooks.Cells[3, k]='' then Exit;
    i:=StrToIntDef(sgBooks.Cells[3, k], 1);
    FIndex := 1;
    url:='1.jpg';
    s:='<img src="'+mBooks[i].preview+url+'" width="auto" height="100%">';
    WebBrowser1.OleObject.Document.clear;
    WebBrowser1.OleObject.Document.Write(s);
    WebBrowser1.OleObject.Document.close;
    StatusBar1.Panels[2].Text := sgBooks.Cells[1, k];
    StatusBar1.Panels[3].Text := sgBooks.Cells[2, k] + ' - '+ url;
    StatusBar1.Panels[4].Text := '';
end;

procedure TfrmMain.WebBrowser1NewWindow2(Sender: TObject;
  var ppDisp: IDispatch; var Cancel: WordBool);
begin
    Cancel := true;
end;

procedure TfrmMain.FormResize(Sender: TObject);
begin
    StatusBar1.Panels[3].Width := self.Width - 500;
end;

end.
