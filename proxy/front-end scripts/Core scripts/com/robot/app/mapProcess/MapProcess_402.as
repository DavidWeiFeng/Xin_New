package com.robot.app.mapProcess
{
   import com.robot.core.manager.map.config.BaseMapProcess;
   import flash.external.ExternalInterface;
   
   public class MapProcess_402 extends BaseMapProcess
   {
      
      public function MapProcess_402()
      {
         super();
      }
      
      override protected function init() : void
      {
      }
      
      public function onPointClick() : void
      {
         ExternalInterface.call("PointFight");
      }
      
      override public function destroy() : void
      {
      }
   }
}

