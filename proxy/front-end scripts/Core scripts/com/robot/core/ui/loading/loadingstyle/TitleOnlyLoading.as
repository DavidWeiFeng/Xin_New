package com.robot.core.ui.loading.loadingstyle
{
   import flash.display.DisplayObjectContainer;
   import flash.text.*;
   
   public class TitleOnlyLoading extends BaseLoadingStyle implements ILoadingStyle
   {
      
      private static const KEY:String = "titleOnlyLoading";
      
      protected var titleText:TextField;
      
      public function TitleOnlyLoading(_arg_1:DisplayObjectContainer, _arg_2:String = "Loading...", _arg_3:Boolean = false)
      {
         super(_arg_1,_arg_3);
         this.titleText = loadingMC["content_txt"];
         this.titleText.autoSize = TextFieldAutoSize.CENTER;
         this.titleText.text = _arg_2;
      }
      
      override public function changePercent(_arg_1:Number, _arg_2:Number) : void
      {
         super.changePercent(_arg_1,_arg_2);
      }
      
      override public function setTitle(_arg_1:String) : void
      {
         this.titleText.text = _arg_1;
      }
      
      override public function destroy() : void
      {
         this.titleText = null;
         super.destroy();
      }
      
      override protected function getKey() : String
      {
         return KEY;
      }
   }
}

