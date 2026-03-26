package org.taomee.component.control
{
   import flash.text.TextField;
   import org.taomee.component.UIComponent;
   
   internal class UITextField extends UIComponent
   {
      
      public var txt:TextField;
      
      public function UITextField(_arg_1:TextField)
      {
         super();
         this.txt = _arg_1;
         addChild(_arg_1);
      }
      
      override public function destroy() : void
      {
         super.destroy();
         this.txt = null;
      }
      
      override public function set width(_arg_1:Number) : void
      {
         super.width = _arg_1;
         this.txt.width = _arg_1;
      }
      
      override public function set height(_arg_1:Number) : void
      {
         super.height = _arg_1;
         this.txt.height = _arg_1;
      }
   }
}

