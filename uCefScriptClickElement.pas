unit uCefScriptClickElement;

interface

uses
  //
  //
  uCefScriptBase, uCefScriptNavBase, uCefWebAction;

type
  TScriptClickElement = class(TCefScriptNavBase)
  private
    FSpeed: Integer;
    FTag: string;
    FId: string;
    FName: string;
    FClass: string;
    FAttrName: string;
    FValueRegExpr: string;
  protected
    function DoNavEvent(const AWebAction: TCefWebAction): Boolean; override;
  public
    constructor Create(const ASpeed: Integer; const ATag, AId, AName,
        AClass, AAttrName, AAttrValueRegExpr: string;
        const ASetAsNav: Boolean;
        const AParent: TCefScriptBase); overload;
    constructor Create(const ASpeed: Integer; const AId: string;
        const ASetAsNav: Boolean;
        const AParent: TCefScriptBase); overload;
    constructor Create(const AId: string; const ASetAsNav: Boolean;
        const AParent: TCefScriptBase); overload;
    class function GetName: string; override;
  end;


implementation

uses
  //
  uCefUIFunc, uCefUtilConst;

{ TScriptClickElement }

constructor TScriptClickElement.Create(const ASpeed: Integer; const ATag, AId, AName,
    AClass, AAttrName, AAttrValueRegExpr: string; const ASetAsNav: Boolean;
    const AParent: TCefScriptBase);
begin
  inherited Create(ASetAsNav, AParent);
  FSpeed := ASpeed;
  FTag := ATag;
  FId := AId;
  FName := AName;
  FClass := AClass;
  FAttrName := AAttrName;
  FValueRegExpr := AAttrValueRegExpr;
  //
  if FSpeed = 0 then
    FSpeed := SPEED_DEF
end;

constructor TScriptClickElement.Create(const ASpeed: Integer; const AId: string;
  const ASetAsNav: Boolean; const AParent: TCefScriptBase);
begin
  Create(ASpeed, '', AId, '', '', '', '', ASetAsNav, AParent)
end;

constructor TScriptClickElement.Create(const AId: string;
  const ASetAsNav: Boolean; const AParent: TCefScriptBase);
begin
  Create(AParent.Controller.Speed, AId, ASetAsNav, AParent)
end;

function TScriptClickElement.DoNavEvent(const AWebAction: TCefWebAction): Boolean;
var bol: Boolean;
begin
  bol := CefUIScrollToElement(Chromium.Browser, FAbortEvent, FSpeed, FTag, FId, FName, FClass, FAttrName, FValueRegExpr);
  if not bol then
  begin
    FailMsg2('fail scroll to element');
    Exit(False);
  end;
  bol := CefUIMouseMoveToElement(Chromium.Browser, FAbortEvent, FController.Cursor, FSpeed, FTag, FId, FName, FClass, FAttrName, FValueRegExpr);
  if not bol then
  begin
    FailMsg2('fail mouse move to element');
    Exit(False);
  end;
  CefUIMouseClick(Self);// Chromium.Browser, FController.Cursor);
  Exit(True);
end;

class function TScriptClickElement.GetName: string;
begin
  Result := 'click';
end;

end.

