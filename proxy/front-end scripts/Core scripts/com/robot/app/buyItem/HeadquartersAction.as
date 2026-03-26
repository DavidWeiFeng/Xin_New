package com.robot.app.buyItem
{
   import com.robot.core.CommandID;
   import com.robot.core.config.xml.ItemXMLInfo;
   import com.robot.core.config.xml.PetXMLInfo;
   import com.robot.core.manager.MainManager;
   import com.robot.core.manager.PetManager;
   import com.robot.core.net.SocketConnection;
   import com.robot.core.ui.alert.Alarm;
   import com.robot.core.ui.alert.Alert;
   import com.robot.core.ui.alert.IconAlert;
   import com.robot.core.utils.TextFormatUtil;
   import flash.utils.ByteArray;
   import org.taomee.events.SocketEvent;
   
   public class HeadquartersAction
   {
      
      public function HeadquartersAction()
      {
         super();
      }
      
      public static function buyItem(id:uint, isTip:Boolean = true, count:uint = 1) : void
      {
         var price:uint = 0;
         var name:String = null;
         var str:String = null;
         if(ItemXMLInfo.getVipOnly(id))
         {
            if(!MainManager.actorInfo.vip)
            {
               Alarm.show("你还没有开通超能NoNo，不能购买这个装备哦！");
               return;
            }
         }
         if(!isTip)
         {
            SocketConnection.send(CommandID.HEAD_BUY,id,count);
            return;
         }
         price = uint(ItemXMLInfo.getPrice(id));
         name = ItemXMLInfo.getName(id);
         if(price > 0)
         {
            if(MainManager.isRoomHalfDay)
            {
               str = "<font color=\'#ff0000\'>" + name + "</font>需要花费" + price.toString() + "个骄阳豆，<font color=\'#ff0000\'>（半价日只需要花费" + price / 2 + "个骄阳豆）</font>，要确定购买吗？";
            }
            else
            {
               str = "<font color=\'#ff0000\'>" + name + "</font>需要花费" + price.toString() + "个骄阳豆，" + "你现在拥有" + MainManager.actorInfo.coins + "个骄阳豆，要确定购买吗？";
            }
         }
         else
         {
            str = "<font color=\'#ff0000\'>" + name + "</font>免费赠送，你确定现在就要领取吗？";
         }
         IconAlert.show(str,id,function():void
         {
            SocketConnection.send(CommandID.HEAD_BUY,id,count);
         });
      }
      
      public static function buySinItem(_arg_1:uint, _arg_2:uint) : void
      {
         SocketConnection.send(CommandID.ITEM_BUY,_arg_1,_arg_2);
      }
      
      public static function exchangeSinItem(type:uint, need:uint) : void
      {
         if(MainManager.actorInfo.fightBadge < need)
         {
            Alert.show("你的战斗徽章数不够!");
            return;
         }
         Alert.show("你确定要兑换吗?",function():void
         {
            SocketConnection.addCmdListener(CommandID.EXCHANGE_CLOTH_COMPLETE,onEcHandler);
            SocketConnection.send(CommandID.EXCHANGE_CLOTH_COMPLETE,type);
         });
      }
      
      private static function onEcHandler(_arg_1:SocketEvent) : void
      {
         var _local_2:uint = 0;
         var _local_3:uint = 0;
         var _local_6:int = 0;
         SocketConnection.removeCmdListener(CommandID.EXCHANGE_CLOTH_COMPLETE,onEcHandler);
         var _local_4:ByteArray = _arg_1.data as ByteArray;
         _local_4.readUnsignedInt();
         _local_4.readUnsignedInt();
         MainManager.actorInfo.fightBadge = _local_4.readUnsignedInt();
         var _local_5:uint = _local_4.readUnsignedInt();
         while(_local_6 < _local_5)
         {
            _local_2 = _local_4.readUnsignedInt();
            _local_3 = _local_4.readUnsignedInt();
            Alarm.show(_local_3 + "个" + TextFormatUtil.getRedTxt(ItemXMLInfo.getName(_local_2)) + "已经放入你的背包。");
            _local_6++;
         }
      }
      
      public static function exchangePet(type:uint, need:uint) : void
      {
         var f:uint = uint(MainManager.actorInfo.fightBadge);
         if(MainManager.actorInfo.fightBadge < need)
         {
            Alert.show("你的战斗徽章数不够!");
            return;
         }
         Alert.show("你确定要兑换吗?",function():void
         {
            SocketConnection.addCmdListener(CommandID.EXCHANGE_PET_COMPLETE,onExtPetHandler);
            SocketConnection.send(CommandID.EXCHANGE_PET_COMPLETE,type);
         });
      }
      
      private static function onExtPetHandler(_arg_1:SocketEvent) : void
      {
         var _local_2:String = null;
         var _local_3:uint = 0;
         var _local_4:int = 0;
         var _local_5:uint = 0;
         var _local_6:uint = 0;
         var _local_7:String = null;
         SocketConnection.removeCmdListener(CommandID.EXCHANGE_PET_COMPLETE,onExtPetHandler);
         var _local_8:ByteArray = _arg_1.data as ByteArray;
         MainManager.actorInfo.fightBadge = _local_8.readUnsignedInt();
         var _local_9:uint = _local_8.readUnsignedInt();
         var _local_10:uint = _local_8.readUnsignedInt();
         if(_local_9 != 0)
         {
            _local_2 = PetXMLInfo.getName(_local_9);
            Alarm.show("一个" + TextFormatUtil.getRedTxt(_local_2) + "作为奖励已经放入你的精灵仓库！");
            PetManager.addStorage(_local_9,_local_10);
         }
         else
         {
            _local_3 = _local_8.readUnsignedInt();
            _local_4 = 0;
            while(_local_4 < _local_3)
            {
               _local_5 = _local_8.readUnsignedInt();
               _local_6 = _local_8.readUnsignedInt();
               _local_7 = ItemXMLInfo.getName(_local_5);
               Alarm.show(_local_6.toString() + "个" + TextFormatUtil.getRedTxt(_local_7) + "作为奖励已经放入你的背包！");
               _local_4++;
            }
         }
      }
   }
}

