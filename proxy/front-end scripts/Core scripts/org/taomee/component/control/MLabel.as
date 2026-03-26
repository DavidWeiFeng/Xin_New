package org.taomee.component.control
{
   import flash.text.TextField;
   import flash.text.TextFormat;
   import org.taomee.component.ITextContentComponent;
   import org.taomee.component.UIComponent;
   import org.taomee.component.manager.MComponentManager;
   
   public class MLabel extends UIComponent implements ITextContentComponent
   {
      
      private var htmlType:Boolean = false;
      
      private var oldStr:String;
      
      private var _cutToFit:Boolean = false;
      
      private var _autoFitWidth:Boolean = false;
      
      private var _isOverflow:Boolean = false;
      
      protected var txt:TextField;
      
      protected var tf:TextFormat;
      
      protected var uiTxt:UITextField;
      
      public function MLabel(_arg_1:String = "")
      {
         super();
         this.tf = new TextFormat();
         this.tf.size = MComponentManager.fontSize;
         this.tf.font = MComponentManager.font;
         this.tf.leading = 4;
         this.tf.letterSpacing = 1;
         this.uiTxt = new UITextField(new TextField());
         this.txt = this.uiTxt.txt;
         containSprite.addChild(this.uiTxt);
         this.txt.selectable = false;
         this.txt.wordWrap = false;
         if(_arg_1 == "")
         {
            _arg_1 = "MLabel";
         }
         this.oldStr = _arg_1;
         this.txt.text = _arg_1;
         this.txt.setTextFormat(this.tf);
         this.width = this.txt.textWidth + 2;
         this.height = this.txt.textHeight;
      }
      
      public function get textFormat() : TextFormat
      {
         return this.tf;
      }
      
      public function set autoFitWidth(_arg_1:Boolean) : void
      {
         this._autoFitWidth = _arg_1;
         updateView();
      }
      
      override protected function revalidate() : void
      {
         var _local_1:uint = 0;
         super.revalidate();
         this.txt.htmlText = this.oldStr;
         this.txt.setTextFormat(this.tf);
         this._isOverflow = false;
         if(this._autoFitWidth)
         {
            stopUpdate();
            this._autoFitWidth = false;
            this.width = this.txt.textWidth + 2;
            this._autoFitWidth = true;
            return;
         }
         if(!this._cutToFit && !this.htmlType)
         {
            _local_1 = 0;
            while(this.txt.textWidth > width && this.oldStr.length - _local_1 > 1)
            {
               _local_1++;
               this.txt.text = this.oldStr.substring(0,this.oldStr.length - _local_1) + "...";
               this.txt.setTextFormat(this.tf);
               this._isOverflow = true;
            }
            return;
         }
      }
      
      public function get isOverflow() : Boolean
      {
         return this._isOverflow;
      }
      
      public function get textField() : TextField
      {
         return this.txt;
      }
      
      override public function set height(_arg_1:Number) : void
      {
         super.height = _arg_1;
         this.uiTxt.height = _arg_1;
      }
      
      public function set align(_arg_1:String) : void
      {
         this.tf.align = _arg_1;
         updateView();
      }
      
      public function set text(_arg_1:String) : void
      {
         this.htmlType = false;
         this.oldStr = _arg_1;
         this.txt.text = _arg_1;
         updateView();
      }
      
      override public function set width(_arg_1:Number) : void
      {
         if(!this._autoFitWidth)
         {
            super.width = _arg_1;
            this.uiTxt.width = _arg_1;
         }
      }
      
      public function set fontSize(_arg_1:uint) : void
      {
         this.tf.size = _arg_1;
         updateView();
      }
      
      public function set cutToFit(_arg_1:Boolean) : void
      {
         this._cutToFit = _arg_1;
         updateView();
      }
      
      public function set textColor(_arg_1:uint) : void
      {
         this.tf.color = _arg_1;
         updateView();
      }
      
      public function get text() : String
      {
         return this.oldStr;
      }
      
      public function set italic(_arg_1:Boolean) : void
      {
         if(_arg_1)
         {
            this.tf.italic = true;
         }
         else
         {
            this.tf.italic = null;
         }
         updateView();
      }
      
      public function set htmlText(_arg_1:String) : void
      {
         this.htmlType = true;
         this.oldStr = _arg_1;
         this.txt.htmlText = _arg_1;
         updateView();
      }
      
      override public function destroy() : void
      {
         super.destroy();
         this.uiTxt = null;
         this.txt = null;
      }
      
      public function set selectable(_arg_1:Boolean) : void
      {
         this.txt.selectable = _arg_1;
      }
      
      public function set blod(_arg_1:Boolean) : void
      {
         if(_arg_1)
         {
            this.tf.bold = true;
         }
         else
         {
            this.tf.bold = null;
         }
         updateView();
      }
      
      public function get htmlText() : String
      {
         return this.oldStr;
      }
   }
}

