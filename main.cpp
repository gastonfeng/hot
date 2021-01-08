//---------------------------------------------------------------------------
#include <vcl.h>
#pragma hdrstop

#include "main.h"
//---------------------------------------------------------------------------
#pragma package(smart_init)
#pragma resource "*.dfm"
TForm1 *Form1;
//---------------------------------------------------------------------------
__fastcall TForm1::TForm1(TComponent* Owner)
        : TForm(Owner)
{
}
//---------------------------------------------------------------------------
void __fastcall TForm1::Timer1Timer(TObject *Sender)
{
  unsigned char realvaule;
  realvalue=ad(0);
  Label2->Caption="Êµ¼ÊÎÂ¶È£º"+inttostr(realvalue);
  Graph2->
}
//---------------------------------------------------------------------------
