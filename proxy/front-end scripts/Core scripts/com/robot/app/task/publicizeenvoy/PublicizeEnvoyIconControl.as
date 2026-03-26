package com.robot.app.task.publicizeenvoy
{
   import com.robot.core.manager.*;
   import flash.display.*;
   import flash.events.*;
   import org.taomee.manager.*;
   import org.taomee.utils.*;
   
   public class PublicizeEnvoyIconControl
   {
      
      private static var _iconMc:MovieClip;
      
      private static var _lightMC:MovieClip;
      
      private static var _isAlarm:Boolean = false;
      
      public function PublicizeEnvoyIconControl()
      {
         super();
      }
      
      public static function canGetTaskReword(_arg_1:uint, _arg_2:uint) : Boolean
      {
         var _local_3:Boolean = Boolean(BitUtil.getBit(_arg_2,0));
         var _local_4:Boolean = Boolean(BitUtil.getBit(_arg_2,1));
         var _local_5:Boolean = Boolean(BitUtil.getBit(_arg_2,2));
         if(_arg_1 >= 2 && _arg_1 <= 5)
         {
            if(!_local_3)
            {
               return true;
            }
         }
         else if(_arg_1 >= 5 && _arg_1 <= 10)
         {
            if(!_local_3 || !_local_4)
            {
               return true;
            }
         }
         else if(_arg_1 >= 10)
         {
            if(!_local_3 || !_local_4 || !_local_5)
            {
               return true;
            }
         }
         return false;
      }
      
      public static function check() : void
      {
         var _local_1:Boolean = false;
         var _local_2:uint = uint(MainManager.actorInfo.newInviteeCnt);
         var _local_3:uint = uint(MainManager.actorInfo.freshManBonus);
         var _local_4:Boolean = Boolean(BitUtil.getBit(_local_3,1));
         var _local_5:Boolean = Boolean(BitUtil.getBit(_local_3,2));
         var _local_6:Boolean = Boolean(BitUtil.getBit(_local_3,3));
         if(MainManager.actorInfo.dsFlag == 1)
         {
            if(_local_4 && _local_5 && _local_6)
            {
               return;
            }
            addIcon();
            _local_1 = canGetTaskReword(_local_2,_local_3);
            if(_local_1)
            {
               lightIcon();
            }
         }
      }
      
      public static function addIcon() : void
      {
         _iconMc = TaskIconManager.getIcon("PublicizeEnloy_ICON") as MovieClip;
         ToolTipManager.add(_iconMc,"赛尔召集令");
         TaskIconManager.addIcon(_iconMc);
         _lightMC = _iconMc["lightMC"];
         _lightMC.visible = false;
         _iconMc.buttonMode = true;
         _iconMc.visible = false;
         _iconMc.addEventListener(MouseEvent.CLICK,onClickHandler);
      }
      
      private static function onClickHandler(_arg_1:MouseEvent) : void
      {
         PublicizeEnvoyController.show(_isAlarm);
         _isAlarm = false;
      }
      
      public static function delIcon() : void
      {
         TaskIconManager.delIcon(_iconMc);
      }
      
      public static function lightIcon() : void
      {
         if(Boolean(_lightMC))
         {
            _lightMC.visible = true;
            _isAlarm = true;
         }
      }
   }
}

