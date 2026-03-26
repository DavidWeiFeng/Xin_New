package com.robot.app.control
{
   import com.robot.core.config.*;
   import com.robot.core.manager.*;
   import com.robot.core.mode.*;
   
   public class MinAnalyserController
   {
      
      private static var panel:AppModel;
      
      private static var arr:Array = [];
      
      public function MinAnalyserController()
      {
         super();
      }
      
      public static function showPanel() : void
      {
         TasksManager.getProStatusList(65,function(_arg_1:Array):void
         {
            if(!_arg_1[4])
            {
               arr.push(400023);
            }
            if(!_arg_1[5])
            {
               arr.push(400024);
            }
            if(!_arg_1[6])
            {
               arr.push(400025);
            }
         });
         if(panel == null)
         {
            panel = new AppModel(ClientConfig.getAppModule("MineralAnalyser"),"正在打开...");
            panel.init(arr);
         }
         panel.show();
      }
   }
}

