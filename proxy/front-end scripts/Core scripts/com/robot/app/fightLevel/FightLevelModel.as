package com.robot.app.fightLevel
{
   import com.robot.core.manager.*;
   
   public class FightLevelModel
   {
      
      private static var info:Array;
      
      private static var currentBossId:Array;
      
      private static var curLevel:uint;
      
      private static var nextBossId:Array;
      
      private static var xmlClass:Class = FightLevelModel_xmlClass;
      
      private static var xml:XML = XML(new xmlClass());
      
      private static const _maxLevel:uint = 800;
      
      private static var b1:Boolean = false;
      
      public function FightLevelModel()
      {
         super();
      }
      
      public static function setUp() : void
      {
         info = new Array();
         UserInfoManager.upDateMoreInfo(MainManager.actorInfo,upDatahandler);
      }
      
      private static function upDatahandler() : void
      {
         var _local_1:Object = null;
         var _local_2:uint = 0;
         var _local_3:int = 0;
         while(_local_3 < xml.level.length())
         {
            _local_1 = new Object();
            _local_1.id = xml.level[_local_3].@id;
            _local_1.itemId = xml.level[_local_3].@itemId;
            if(MainManager.actorInfo.maxStage == 0)
            {
               _local_1.isOpen = false;
            }
            else
            {
               if(MainManager.actorInfo.maxStage <= 10)
               {
                  _local_2 = 1;
               }
               else if(MainManager.actorInfo.maxStage == _maxLevel)
               {
                  _local_2 = uint(uint(_maxLevel / 10));
               }
               else if(MainManager.actorInfo.maxStage % 10 == 0)
               {
                  _local_2 = uint(uint(MainManager.actorInfo.maxStage / 10));
               }
               else
               {
                  _local_2 = uint(uint(uint(MainManager.actorInfo.maxStage / 10) + 1));
               }
               if(uint(_local_1.id) <= _local_2)
               {
                  _local_1.isOpen = true;
               }
               else
               {
                  _local_1.isOpen = false;
               }
            }
            info.push(_local_1);
            _local_3++;
         }
         FightChoiceController.show();
      }
      
      public static function get list() : Array
      {
         return info;
      }
      
      public static function set setBossId(_arg_1:Array) : void
      {
         currentBossId = _arg_1;
      }
      
      public static function get getBossId() : Array
      {
         return currentBossId;
      }
      
      public static function set setCurLevel(_arg_1:uint) : void
      {
         curLevel = _arg_1;
      }
      
      public static function get getCurLevel() : uint
      {
         return curLevel;
      }
      
      public static function set setNextBossId(_arg_1:Array) : void
      {
         nextBossId = _arg_1;
      }
      
      public static function get getNextBossId() : Array
      {
         return nextBossId;
      }
      
      public static function get maxLevel() : uint
      {
         return _maxLevel;
      }
   }
}

