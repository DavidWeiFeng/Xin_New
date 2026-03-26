package com.robot.core.ui.loading.loadingstyle
{
   import com.robot.core.manager.MainManager;
   import flash.display.DisplayObjectContainer;
   
   public class MainLoadingStyle extends TitlePercentLoading implements ILoadingStyle
   {
      
      private static const KEY:String = "mainLoad";
      
      public function MainLoadingStyle(_arg_1:DisplayObjectContainer, _arg_2:String = "Loading...", _arg_3:Boolean = false)
      {
         super(_arg_1,_arg_2,_arg_3);
      }
      
      override protected function initPosition() : void
      {
         if(parentMC == null)
         {
            parentMC = MainManager.getStage();
         }
         parentMC.addChild(loadingMC);
      }
      
      override protected function getKey() : String
      {
         return KEY;
      }
   }
}

