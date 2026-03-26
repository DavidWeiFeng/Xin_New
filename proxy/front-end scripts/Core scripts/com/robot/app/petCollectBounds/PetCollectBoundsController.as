package com.robot.app.petCollectBounds
{
   public class PetCollectBoundsController
   {
      
      private static var _panel:PetCollectBoundsPanel2;
      
      public function PetCollectBoundsController()
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
         _panel = new PetCollectBoundsPanel2();
         _panel.show();
      }
   }
}

