package com.robot.app.spt
{
   import com.robot.core.manager.*;
   
   public class PioneerTaskModel
   {
      
      private static var _infoA:Array;
      
      private static var xmlClass:Class = PioneerTaskModel_xmlClass;
      
      private static var xml:XML = XML(new xmlClass());
      
      public function PioneerTaskModel()
      {
         super();
      }
      
      public static function setup() : void
      {
         _infoA = new Array();
         makeListInfo();
      }
      
      public static function makeListInfo() : void
      {
         var _local_1:XML = null;
         var _local_2:SptInfo = null;
         var _local_3:XMLList = xml.elements("spt");
         _infoA = new Array();
         for each(_local_1 in _local_3)
         {
            _local_2 = new SptInfo();
            _local_2.id = uint(_local_1.@id);
            _local_2.description = _local_1.@description;
            _local_2.enterID = uint(_local_1.@enterID);
            _local_2.level = uint(_local_1.@lel);
            _local_2.onLine = Boolean(_local_1.@online);
            _local_2.seatID = uint(_local_1.@seatID);
            _local_2.status = uint(TasksManager.taskList[_local_2.id - 1]);
            _local_2.title = _local_1.@title;
            _local_2.fightCondition = _local_1.@fightCondition;
            _infoA.push(_local_2);
         }
      }
      
      public static function get infoA() : Array
      {
         if(!_infoA)
         {
            makeListInfo();
         }
         return _infoA;
      }
   }
}

