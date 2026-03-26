package com.robot.app.ItemMixture
{
   public class ItemMixturePanelController
   {
      
      private static var _panel:ItemMixturePanel;
      
      public function ItemMixturePanelController()
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
         _panel = new ItemMixturePanel();
         _panel.show();
      }
   }
}

