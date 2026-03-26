package com.robot.app.leiyiTrain
{
   public class LeiyiEnergyPanelController
   {
      
      private static var _panel:LeiyiEnergyPanel;
      
      public function LeiyiEnergyPanelController()
      {
         super();
      }
      
      public static function show() : void
      {
         if(_panel != null)
         {
            _panel.destroy();
            _panel = null;
         }
         _panel = new LeiyiEnergyPanel();
         _panel.show();
      }
   }
}

