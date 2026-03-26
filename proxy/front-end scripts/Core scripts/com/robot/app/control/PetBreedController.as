package com.robot.app.control
{
   import com.robot.core.config.ClientConfig;
   import com.robot.core.manager.ModuleManager;
   
   public class PetBreedController
   {
      
      public function PetBreedController()
      {
         super();
      }
      
      public static function show() : void
      {
         ModuleManager.showModule(ClientConfig.getAppModule("PetBreedPanel"),"正在加载精灵培育仓....");
      }
   }
}

