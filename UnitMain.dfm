object frmMain: TfrmMain
  Left = 254
  Top = 185
  AutoScroll = False
  Caption = #33841#20048#30005#23376#25945#31185#20070#19979#36733' v1.3'
  ClientHeight = 711
  ClientWidth = 1147
  Color = clBtnFace
  Font.Charset = GB2312_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = #26032#23435#20307
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  OnClose = FormClose
  OnCreate = FormCreate
  OnResize = FormResize
  PixelsPerInch = 96
  TextHeight = 12
  object sgBooks: TStringGrid
    Left = 0
    Top = 0
    Width = 673
    Height = 573
    Align = alLeft
    ColCount = 3
    Ctl3D = False
    DefaultColWidth = 40
    DefaultRowHeight = 20
    RowCount = 3000
    Font.Charset = GB2312_CHARSET
    Font.Color = clWindowText
    Font.Height = -12
    Font.Name = 'Monaco'
    Font.Style = []
    Options = [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine, goRangeSelect, goColSizing, goEditing, goRowSelect, goThumbTracking]
    ParentCtl3D = False
    ParentFont = False
    TabOrder = 0
    OnClick = btnPreviewClick
    ColWidths = (
      40
      332
      273)
  end
  object GroupBox1: TGroupBox
    Left = 0
    Top = 643
    Width = 1147
    Height = 49
    Align = alBottom
    TabOrder = 1
    object Label1: TLabel
      Left = 8
      Top = 21
      Width = 24
      Height = 12
      Caption = #24180#27573
    end
    object Label2: TLabel
      Left = 105
      Top = 20
      Width = 24
      Height = 12
      Caption = #31185#30446
    end
    object Label3: TLabel
      Left = 235
      Top = 19
      Width = 24
      Height = 12
      Caption = #29256#26412
    end
    object cbxND: TComboBox
      Left = 40
      Top = 16
      Width = 57
      Height = 20
      Style = csDropDownList
      Ctl3D = False
      ItemHeight = 12
      ItemIndex = 0
      ParentCtl3D = False
      TabOrder = 0
      Text = #20840#37096
      OnClick = cbxNDClick
      Items.Strings = (
        #20840#37096
        #23567#23398
        #21021#20013
        #39640#20013)
    end
    object cbxKM: TComboBox
      Left = 136
      Top = 16
      Width = 89
      Height = 20
      Style = csDropDownList
      Ctl3D = False
      ItemHeight = 12
      ItemIndex = 0
      ParentCtl3D = False
      TabOrder = 1
      Text = #20840#37096
      OnClick = cbxNDClick
      Items.Strings = (
        #20840#37096
        #35821#25991
        #25968#23398
        #33521#35821
        #21382#21490
        #29289#29702
        #21270#23398
        #29983#29289
        #22320#29702
        #20449#24687
        #38899#20048
        #32654#26415
        #20307#32946
        #31185#23398
        #27963#21160#25163#20876)
    end
    object cbxCB: TComboBox
      Left = 272
      Top = 16
      Width = 137
      Height = 20
      Style = csDropDownList
      Ctl3D = False
      ItemHeight = 12
      ItemIndex = 0
      ParentCtl3D = False
      TabOrder = 2
      Text = #20840#37096
      OnClick = cbxNDClick
      Items.Strings = (
        #20840#37096
        #32479#32534#29256
        #20154#25945#29256
        #21271#24072#22823#29256
        #22806#30740#31038#29256
        #38397#25945#29256
        #20864#25945#29256
        #33487#25945#29256
        #38738#23707#29256
        #21326#19996#24072#22823#29256
        #36797#24072#22823#29256
        #35199#21335#24072#22823#29256
        #37325#24198#22823#23398#29256
        #28165#21326#22823#23398#29256
        #31908#25945#31908#20154#29256
        #31908#25945#31908#31185#29256
        #40065#25945#28248#25945#29256
        #31908#25945#29256
        #21271#20140#29256
        #27818#25945#29256
        #24029#25945#29256
        #37122#25945#29256
        #36797#28023#29256
        #28248#23569#29256
        #20864#23569#29256
        #33487#23569#29256
        #28248#25991#33402#29256
        #21326#25991#31038#29256
        #31908#25945#33457#22478#29256
        #23725#21335#32654#29256
        #27993#20154#32654#29256
        #26187#20154#29256
        #20864#20154#29256
        #20864#32654#29256
        #38485#26053#29256
        #38738#23707#29256
        #36195#32654#29256
        #35793#26519#29256
        #25945#31185#29256
        #28248#31185#29256
        #25509#21147#29256
        #31185#26222#29256
        #20154#38899#29256
        #20154#32654#29256
        #22823#35937#31038#29256
        #20154#25945#37122#25945#29256
        #27818#31185#25945#29256
        #35199#27872#21360#31038#29256
        #31185#23398#31038#29256
        #26410#26469#31038#29256
        #27818#22806#25945#29256
        #22320#36136#31038#29256
        #26690#25945#29256
        #22521#26234#23398#26657
        #30450#26657
        #32843#26657)
    end
    object btnOpen: TButton
      Left = 504
      Top = 10
      Width = 145
      Height = 33
      Caption = #25171#24320
      TabOrder = 3
      OnClick = btnOpenClick
    end
    object btnNext: TButton
      Tag = 1
      Left = 697
      Top = 10
      Width = 97
      Height = 33
      Caption = #19979#19968#39029
      TabOrder = 4
      OnClick = btnNextClick
    end
    object btnPre: TButton
      Tag = -1
      Left = 841
      Top = 10
      Width = 97
      Height = 33
      Caption = #19978#19968#39029
      TabOrder = 5
      OnClick = btnNextClick
    end
  end
  object StatusBar1: TStatusBar
    Left = 0
    Top = 692
    Width = 1147
    Height = 19
    Panels = <
      item
        Alignment = taCenter
        Text = #29366#24577
        Width = 50
      end
      item
        Alignment = taCenter
        Width = 100
      end
      item
        Alignment = taCenter
        Width = 200
      end
      item
        Width = 600
      end
      item
        Width = 50
      end>
  end
  object WebBrowser1: TWebBrowser
    Left = 673
    Top = 0
    Width = 474
    Height = 573
    Align = alClient
    TabOrder = 3
    OnNewWindow2 = WebBrowser1NewWindow2
    ControlData = {
      4C000000FD300000393B00000000000000000000000000000000000000000000
      000000004C000000000000000000000001000000E0D057007335CF11AE690800
      2B2E12620A000000000000004C0000000114020000000000C000000000000046
      8000000000000000000000000000000000000000000000000000000000000000
      00000000000000000100000000000000000000000000000000000000}
  end
  object moLog: TMemo
    Left = 0
    Top = 573
    Width = 1147
    Height = 70
    Align = alBottom
    Lines.Strings = (
      
        #22914#26524#36719#20214#19979#36733#30340'PDF'#25552#31034#25991#20214#25439#22351#25110#26080#27861#19979#36733#65292#35831#25226#38142#25509#20013'/assets_document/'#26367#25442#25104'/assets/'#65292#25110#25226'/asset' +
        's/'#26367#25442#25104'/assets_document/  '#22797#21046#38142#25509#21040#27983#35272#22120#19978#19979#36733)
    ScrollBars = ssVertical
    TabOrder = 4
  end
  object Timer1: TTimer
    OnTimer = Timer1Timer
    Left = 200
    Top = 248
  end
end
