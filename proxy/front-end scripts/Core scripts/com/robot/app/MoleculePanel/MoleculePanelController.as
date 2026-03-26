package com.robot.app.MoleculePanel
{
   public class MoleculePanelController
   {
      
      private static var _panel:MoleculePanel;
      
      public function MoleculePanelController()
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
         _panel = new MoleculePanel();
         _panel.show();
      }
   }
}

