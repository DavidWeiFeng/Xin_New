package org.taomee.component.control
{
   import flash.text.TextFieldAutoSize;
   import org.taomee.component.ITextContentComponent;
   
   public class MText extends MLabel implements ITextContentComponent
   {
      
      public function MText(_arg_1:String = "")
      {
         super(_arg_1);
         txt.selectable = true;
         txt.wordWrap = true;
         txt.autoSize = TextFieldAutoSize.LEFT;
         if(_arg_1 == "")
         {
            text = "";
         }
         txt.setTextFormat(tf);
         width = txt.width;
         height = txt.height;
      }
   }
}

