package com.robot.core.manager
{
   import com.robot.core.manager.alert.AlertInfo;
   import com.robot.core.manager.alert.AlertType;
   import com.robot.core.ui.alert.IAlert;
   import com.robot.core.ui.alert2.Alarm;
   import com.robot.core.ui.alert2.Alert;
   import com.robot.core.ui.alert2.Answer;
   import com.robot.core.ui.alert2.ItemInBagAlarm;
   import com.robot.core.ui.alert2.PetInBagAlarm;
   import com.robot.core.ui.alert2.PetInStorageAlarm;
   import flash.display.DisplayObjectContainer;
   import flash.events.Event;
   
   public class AlertManager
   {
      
      private static var _currAlert:IAlert;
      
      private static var _list:Array = [];
      
      public function AlertManager()
      {
         super();
      }
      
      public static function show(_arg_1:String, _arg_2:String, _arg_3:String = "", _arg_4:DisplayObjectContainer = null, _arg_5:Function = null, _arg_6:Function = null, _arg_7:Function = null, _arg_8:Boolean = true, _arg_9:Boolean = true, _arg_10:Boolean = false) : void
      {
         var _local_11:AlertInfo = null;
         _local_11 = null;
         _local_11 = new AlertInfo();
         _local_11.type = _arg_1;
         _local_11.str = _arg_2;
         _local_11.iconURL = _arg_3;
         _local_11.parant = _arg_4;
         _local_11.applyFun = _arg_5;
         _local_11.cancelFun = _arg_6;
         _local_11.linkFun = _arg_7;
         _local_11.disMouse = _arg_8;
         _local_11.isGC = _arg_9;
         _local_11.isBreak = _arg_10;
         _list.push(_local_11);
         nextShow();
      }
      
      public static function showSimpleAlarm(_arg_1:String, _arg_2:Function = null) : void
      {
         show(AlertType.ALARM,_arg_1,"",null,_arg_2);
      }
      
      public static function showSimpleAlert(_arg_1:String, _arg_2:Function = null, _arg_3:Function = null) : void
      {
         show(AlertType.ALERT,_arg_1,"",null,_arg_2,_arg_3);
      }
      
      public static function showSimpleAnswer(_arg_1:String, _arg_2:Function = null, _arg_3:Function = null) : void
      {
         show(AlertType.ANSWER,_arg_1,"",null,_arg_2,_arg_3);
      }
      
      public static function showForInfo(_arg_1:AlertInfo) : void
      {
         _list.push(_arg_1);
         nextShow();
      }
      
      public static function nextShow() : void
      {
         var _local_1:AlertInfo = null;
         if(_list.length == 0)
         {
            return;
         }
         if(_currAlert == null)
         {
            _local_1 = _list.shift() as AlertInfo;
            switch(_local_1.type)
            {
               case AlertType.ALARM:
                  _currAlert = new Alarm(_local_1);
                  break;
               case AlertType.ALERT:
                  _currAlert = new Alert(_local_1);
                  break;
               case AlertType.ANSWER:
                  _currAlert = new Answer(_local_1);
                  break;
               case AlertType.ITEM_IN_BAG_ALARM:
                  _currAlert = new ItemInBagAlarm(_local_1);
                  break;
               case AlertType.ITEM_IN_STORAGE_ALARM:
                  break;
               case AlertType.PET_IN_BAG_ALARM:
                  _currAlert = new PetInBagAlarm(_local_1);
                  break;
               case AlertType.PET_IN_STORAGE_ALARM:
                  _currAlert = new PetInStorageAlarm(_local_1);
            }
            _currAlert.addEventListener(Event.CLOSE,onClose);
            _currAlert.show();
         }
      }
      
      public static function destroy() : void
      {
         if(Boolean(_currAlert))
         {
            if(_currAlert.info.isGC)
            {
               _currAlert.removeEventListener(Event.CLOSE,onClose);
               _currAlert.destroy();
               _currAlert = null;
            }
         }
         _list = _list.filter(function(_arg_1:AlertInfo, _arg_2:int, _arg_3:Array):Boolean
         {
            if(_arg_1.isGC)
            {
               return false;
            }
            return true;
         });
      }
      
      private static function onClose(_arg_1:Event) : void
      {
         var _local_2:Boolean = Boolean(_currAlert.info.isBreak);
         _currAlert.removeEventListener(Event.CLOSE,onClose);
         _currAlert.destroy();
         _currAlert = null;
         if(!_local_2)
         {
            nextShow();
         }
      }
   }
}

