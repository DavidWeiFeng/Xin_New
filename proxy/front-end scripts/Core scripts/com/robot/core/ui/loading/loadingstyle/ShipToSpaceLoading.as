package com.robot.core.ui.loading.loadingstyle
{
   import flash.display.DisplayObjectContainer;
   
   public class ShipToSpaceLoading extends TitlePercentLoading implements ILoadingStyle
   {
      
      private static const KEY:String = "ShipToSpaceLoading";
      
      public function ShipToSpaceLoading(_arg_1:DisplayObjectContainer, _arg_2:String = "Loading...", _arg_3:Boolean = false)
      {
         super(_arg_1,_arg_2,_arg_3);
      }
      
      override protected function getKey() : String
      {
         return KEY;
      }
   }
}

