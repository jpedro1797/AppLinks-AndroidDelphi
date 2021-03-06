unit frmRegistro;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls,
  FMX.Edit, FMX.Controls.Presentation, FMX.Layouts,
  FMX.Helpers.Android,
  IdURI,
{$IFDEF ANDROID}
  Androidapi.Jni.GraphicsContentViewText,
  Androidapi.Jni.Net,
  Androidapi.Jni.JavaTypes,
  Androidapi.JNIBridge,
  Androidapi.Helpers,
  Androidapi.Jni.App,
  Androidapi.Jni,
{$ENDIF ANDROID}
  FireDAC.Stan.Param,
  FMX.Objects;

type
  TRegistro = class(TFrame)
    Fundo: TRectangle;
    LyAll: TLayout;
    LyView: TLayout;
    spbEdit: TSpeedButton;
    spbTrash: TSpeedButton;
    LyEdit: TLayout;
    spbCancel: TSpeedButton;
    spbSave: TSpeedButton;
    Titulo: TLabel;
    edtLink: TEdit;
    spbGo: TSpeedButton;
    procedure spbEditClick(Sender: TObject);
    procedure spbTrashClick(Sender: TObject);
    procedure spbCancelClick(Sender: TObject);
    procedure spbSaveClick(Sender: TObject);
    procedure spbGoClick(Sender: TObject);
  private
    procedure Editar(Aid: Integer);
    procedure AbrirLink(Alink: string);

    { Private declarations }
  public
    { Public declarations }
  end;

implementation

{$R *.fmx}

uses DataM;

procedure TRegistro.AbrirLink(Alink: string);
var
  Intent: JIntent;
begin
  try
    Intent := TJIntent.JavaClass.init(TJIntent.JavaClass.ACTION_VIEW,
      TJnet_Uri.JavaClass.parse(StringToJString(TIdURI.URLEncode(Alink))));

    TAndroidHelper.Activity.startActivity(Intent);
  except
    on E: Exception do
      ShowMessage(E.Message);

  end;
end;

procedure TRegistro.Editar(Aid: Integer);
begin
  DM.qryAux.Close;
  DM.qryAux.SQL.Clear;
  DM.qryAux.SQL.Add(' UPDATE links SET link =:link WHERE id=:id ');
  DM.qryAux.Params[0].Value := edtLink.Text;
  DM.qryAux.Params[1].Value := Aid;
  DM.qryAux.ExecSQL;
end;

procedure TRegistro.spbCancelClick(Sender: TObject);
begin
  LyEdit.Visible := false;
  LyView.Visible := true;
  edtLink.Text := '';
end;

procedure TRegistro.spbEditClick(Sender: TObject);
begin
  LyEdit.Visible := true;
  LyView.Visible := false;
end;

procedure TRegistro.spbGoClick(Sender: TObject);
begin
  DM.qryAux.Close;
  DM.qryAux.SQL.Clear;
  DM.qryAux.SQL.Add('SELECT * FROM links WHERE id=:id ');
  DM.qryAux.Params[0].Value := Tag;
  DM.qryAux.Open();

  AbrirLink('http://' + DM.qryAux.FieldByName('link').AsString);
end;

procedure TRegistro.spbSaveClick(Sender: TObject);
begin
  LyEdit.Visible := false;
  LyView.Visible := true;
  Editar(Tag);
end;

procedure TRegistro.spbTrashClick(Sender: TObject);
begin
  if TagString = 'trash' then
  begin
    DM.qryAux.Close;
    DM.qryAux.SQL.Clear;
    DM.qryAux.SQL.Add(' UPDATE links SET status = 0 WHERE id=:id ');
    DM.qryAux.Params[0].Value := Tag;
    try
      DM.qryAux.ExecSQL;
    finally
      TagString := 'untrash';
      spbTrash.IconTintColor := TAlphaColorRec.Black;
    end;
  end
  else
  begin
    DM.qryAux.Close;
    DM.qryAux.SQL.Clear;
    DM.qryAux.SQL.Add(' UPDATE links SET status = 1 WHERE id=:id ');
    DM.qryAux.Params[0].Value := Tag;
    try
      DM.qryAux.ExecSQL;
    finally
      TagString := 'trash';
      spbTrash.IconTintColor := TAlphaColorRec.Red;
    end;
  end;
end;

end.
