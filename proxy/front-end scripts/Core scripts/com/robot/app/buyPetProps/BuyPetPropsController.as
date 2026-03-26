package com.robot.app.buyPetProps
{
   import com.robot.core.CommandID;
   import com.robot.core.net.SocketConnection;
   import flash.external.ExternalInterface;
   import flash.utils.ByteArray;
   import org.taomee.events.SocketEvent;
   import org.taomee.utils.DisplayUtil;
   
   public class BuyPetPropsController
   {
      
      private static var _panel:BuyPetPropsPanel;
      
      public function BuyPetPropsController()
      {
         super();
      }
      
      public static function get panel() : BuyPetPropsPanel
      {
         if(_panel == null)
         {
            _panel = new BuyPetPropsPanel();
         }
         return _panel;
      }
      
      public static function show() : void
      {
         if(ExternalInterface.available)
         {
            SocketConnection.sendWithCallback(CommandID.GOLD_CHECK_REMAIN,function(_arg_1:SocketEvent):void
            {
               var _local_2:ByteArray = _arg_1.data as ByteArray;
               var _local_3:Number = _local_2.readUnsignedInt() / 100;
               var coins:Number = _local_2.readUnsignedInt();
               ExternalInterface.call("showStore",coins,_local_3);
            });
            return;
         }
         if(!DisplayUtil.hasParent(panel))
         {
            panel.show();
         }
      }
   }
}

