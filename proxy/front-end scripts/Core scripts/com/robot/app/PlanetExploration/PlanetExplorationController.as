package com.robot.app.PlanetExploration
{
   import com.robot.core.config.*;
   import com.robot.core.mode.*;
   
   public class PlanetExplorationController
   {
      
      private static var panel:AppModel;
      
      public function PlanetExplorationController()
      {
         super();
         panel = new AppModel(ClientConfig.getAppModule("PlanetExploration/PlanetExploration"),"正在打开...");
      }
      
      public static function getPanel() : AppModel
      {
         if(panel == null)
         {
            panel = new AppModel(ClientConfig.getAppModule("PlanetExploration/PlanetExploration"),"正在打开...");
         }
         return panel;
      }
      
      public static function init() : void
      {
         var _local_1:Object = null;
         if(panel != null)
         {
            _local_1 = new Object();
            _local_1.planetName = "双子阿尔法星";
            panel.init(_local_1);
         }
      }
   }
}

