package com.robot.core.pet.petWar
{
   import com.robot.core.*;
   import com.robot.core.event.*;
   import com.robot.core.info.fightInfo.*;
   import com.robot.core.info.pet.PetInfo;
   import com.robot.core.manager.*;
   import com.robot.core.net.*;
   import com.robot.core.ui.alert.*;
   import com.robot.core.utils.*;
   import flash.utils.*;
   import org.taomee.events.SocketEvent;
   import org.taomee.manager.*;
   
   public class PetWarController
   {
      
      private static var _hasInit:Boolean = false;
      
      private static var _allPetA:Array = [];
      
      private static var _allPetMc:Array = [];
      
      public static var allPetIdA:Array = [];
      
      public static var myCapA:Array = [];
      
      public static var myPetInfoA:Array = [];
      
      public function PetWarController()
      {
         super();
      }
      
      public static function start(_arg_1:Function = null) : void
      {
         PetFightModel.mode = PetFightModel.MULTI_MODE;
         EventManager.addEventListener(PetFightEvent.GET_FIGHT_INFO_SUCCESS,onGetInfoSuceessHandler);
         EventManager.addEventListener(PetFightEvent.ALARM_CLICK,onClickHandler);
         SocketConnection.send(CommandID.START_PET_WAR);
         SocketConnection.addCmdListener(CommandID.START_PET_WAR,onStartHandler);
         PetFightModel.mode = PetFightModel.PET_MELEE;
      }
      
      private static function onClickHandler(_arg_1:PetFightEvent) : void
      {
         EventManager.removeEventListener(PetFightEvent.ALARM_CLICK,onClickHandler);
         PetFightModel.mode = PetFightModel.SINGLE_MODE;
      }
      
      private static function onExpHandler(_arg_1:SocketEvent) : void
      {
         SocketConnection.removeCmdListener(CommandID.PET_WAR_EXP_NOTICE,onExpHandler);
         var _local_2:ByteArray = _arg_1.data as ByteArray;
         var _local_3:uint = _local_2.readUnsignedInt();
         Alarm.show("祝贺你得到了 " + TextFormatUtil.getRedTxt(_local_3.toString()) + " 点积累经验!");
      }
      
      public static function onStartHandler(_arg_1:SocketEvent) : void
      {
         SocketConnection.removeCmdListener(CommandID.START_PET_WAR,onStartHandler);
      }
      
      public static function onGetInfoSuceessHandler(_arg_1:PetFightEvent) : void
      {
         EventManager.removeEventListener(PetFightEvent.GET_FIGHT_INFO_SUCCESS,onGetInfoSuceessHandler);
         var _local_2:PetWarInfo = _arg_1.dataObj as PetWarInfo;
         allPetIdA = _local_2.myPetA.concat(_local_2.otherPetA);
      }
      
      public static function destroy() : void
      {
      }
      
      public static function set allPetA(_arg_1:Array) : void
      {
         _allPetA = _arg_1;
      }
      
      public static function get allPetA() : Array
      {
         return _allPetA;
      }
      
      public static function getPetInfo(_arg_1:Number) : PetInfo
      {
         var _local_2:PetInfo = null;
         for each(_local_2 in _allPetA)
         {
            if(_local_2.catchTime == _arg_1)
            {
               return _local_2;
            }
         }
         return null;
      }
      
      public static function getMyPet(_arg_1:uint) : PetInfo
      {
         if(_arg_1 >= myPetInfoA.length)
         {
            return null;
         }
         return myPetInfoA[_arg_1];
      }
   }
}

