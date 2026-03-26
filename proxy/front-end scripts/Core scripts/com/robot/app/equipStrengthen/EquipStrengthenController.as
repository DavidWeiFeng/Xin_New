package com.robot.app.equipStrengthen
{
   import com.robot.core.*;
   import com.robot.core.config.*;
   import com.robot.core.config.xml.*;
   import com.robot.core.event.*;
   import com.robot.core.info.userItem.SingleItemInfo;
   import com.robot.core.manager.*;
   import com.robot.core.mode.*;
   import com.robot.core.net.*;
   import com.robot.core.ui.alert.*;
   import com.robot.core.utils.*;
   import flash.utils.*;
   import org.taomee.events.SocketEvent;
   
   public class EquipStrengthenController
   {
      
      public static var _allIdA:Array;
      
      public static var _listA:Array;
      
      private static var _choicePanel:AppModel;
      
      private static var _curInfo:EquipStrengthenInfo;
      
      private static var _updataPanel:AppModel;
      
      private static const _maxLev:uint = 3;
      
      public function EquipStrengthenController()
      {
         super();
      }
      
      public static function start() : void
      {
         if(Boolean(_updataPanel))
         {
            _updataPanel.hide();
         }
         _allIdA = EquipXmlConfig.getAllEquipId();
         _listA = new Array();
         ItemManager.addEventListener(ItemEvent.CLOTH_LIST,onList);
         ItemManager.getCloth();
      }
      
      private static function onList(_arg_1:ItemEvent) : void
      {
         var _local_2:SingleItemInfo = null;
         var _local_3:int = 0;
         ItemManager.removeEventListener(ItemEvent.CLOTH_LIST,onList);
         while(_local_3 < _allIdA.length)
         {
            _local_2 = ItemManager.getClothInfo(_allIdA[_local_3]);
            if(Boolean(_local_2))
            {
               if(_local_2.itemLevel < _maxLev && _local_2.itemLevel > 0)
               {
                  _listA.push(_local_2);
               }
            }
            _local_3++;
         }
         if(_listA.length > 0)
         {
            showChloicePanel(_listA);
         }
         else
         {
            Alarm.show("你没有可以升级的装备哦！");
         }
      }
      
      private static function showChloicePanel(_arg_1:Array) : void
      {
         if(!_choicePanel)
         {
            _choicePanel = new AppModel(ClientConfig.getAppModule("EquipStrengthenChoicePanel"),"正在打开");
            _choicePanel.setup();
         }
         _choicePanel.init(_arg_1);
         _choicePanel.show();
      }
      
      public static function destory() : void
      {
         ItemManager.removeEventListener(ItemEvent.CLOTH_LIST,onList);
         if(Boolean(_choicePanel))
         {
            _choicePanel.destroy();
            _choicePanel = null;
         }
         if(Boolean(_updataPanel))
         {
            _updataPanel.destroy();
            _updataPanel = null;
         }
         SocketConnection.removeCmdListener(CommandID.EQUIP_UPDATA,onUpDataHandler);
      }
      
      public static function makeInfo(_arg_1:SingleItemInfo) : void
      {
         _choicePanel.hide();
         EquipXmlConfig.getInfo(_arg_1.itemID,_arg_1.itemLevel + 1,showUpdataPanel);
      }
      
      public static function showUpdataPanel(_arg_1:EquipStrengthenInfo) : void
      {
         if(!_updataPanel)
         {
            _updataPanel = new AppModel(ClientConfig.getAppModule("EquipStrengthenPanel"),"正在打开");
            _updataPanel.setup();
         }
         _curInfo = _arg_1;
         _updataPanel.init(_arg_1);
         _updataPanel.show();
      }
      
      public static function startUpdat(_arg_1:uint) : void
      {
         SocketConnection.addCmdListener(CommandID.EQUIP_UPDATA,onUpDataHandler);
         SocketConnection.send(CommandID.EQUIP_UPDATA,_arg_1);
      }
      
      private static function onUpDataHandler(_arg_1:SocketEvent) : void
      {
         SocketConnection.removeCmdListener(CommandID.EQUIP_UPDATA,onUpDataHandler);
         var _local_2:ByteArray = _arg_1.data as ByteArray;
         var _local_3:uint = _local_2.readUnsignedInt();
         if(_local_3 != 1)
         {
            Alarm.show("升级失败！");
            return;
         }
         Alarm.show("恭喜你!" + TextFormatUtil.getRedTxt(ItemXMLInfo.getName(_curInfo.itemId)) + "强化成功了！");
      }
   }
}

