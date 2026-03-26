package com.robot.core.config.xml
{
   import com.robot.core.manager.*;
   import org.taomee.ds.*;
   
   public class MachXMLInfo
   {
      
      private static var xmlClass:Class = MachXMLInfo_xmlClass;
      
      private static var _actionMap:HashMap = new HashMap();
      
      private static var _expMap:HashMap = new HashMap();
      
      private static var _linesMap:HashMap = new HashMap();
      
      private static var _superExpMap:HashMap = new HashMap();
      
      private static var _superLinesMap:HashMap = new HashMap();
      
      setup();
      
      public function MachXMLInfo()
      {
         super();
      }
      
      private static function setup() : void
      {
         var _local_1:XMLList = null;
         var _local_2:XML = null;
         _local_1 = XML(new xmlClass()).elements("action")[0].elements("item");
         for each(_local_2 in _local_1)
         {
            _actionMap.add(uint(_local_2.@id),_local_2);
         }
         _local_1 = XML(new xmlClass()).elements("exp")[0].elements("item");
         for each(_local_2 in _local_1)
         {
            _expMap.add(uint(_local_2.@id),_local_2);
         }
         _local_1 = XML(new xmlClass()).elements("lines")[0].elements("item");
         for each(_local_2 in _local_1)
         {
            _linesMap.add(uint(_local_2.@id),_local_2);
         }
         _local_1 = XML(new xmlClass()).elements("superExp")[0].elements("item");
         for each(_local_2 in _local_1)
         {
            _superExpMap.add(uint(_local_2.@id),_local_2);
         }
         _local_1 = XML(new xmlClass()).elements("superLines")[0].elements("item");
         for each(_local_2 in _local_1)
         {
            _superLinesMap.add(uint(_local_2.@id),_local_2);
         }
      }
      
      public static function getActionName(_arg_1:uint) : String
      {
         var _local_2:XML = _actionMap.getValue(_arg_1);
         if(Boolean(_local_2))
         {
            return String(_local_2.@name);
         }
         return "";
      }
      
      public static function getExpName(_arg_1:uint) : String
      {
         var _local_2:XML = null;
         if(MainManager.actorInfo.superNono)
         {
            _local_2 = _superExpMap.getValue(_arg_1);
         }
         else
         {
            _local_2 = _expMap.getValue(_arg_1);
         }
         if(Boolean(_local_2))
         {
            return String(_local_2.@name);
         }
         return "";
      }
      
      public static function getLinesName(_arg_1:uint) : String
      {
         var _local_2:XML = null;
         if(MainManager.actorInfo.superNono)
         {
            _local_2 = _superLinesMap.getValue(_arg_1);
         }
         else
         {
            _local_2 = _linesMap.getValue(_arg_1);
         }
         if(Boolean(_local_2))
         {
            return String(_local_2.@name);
         }
         return "";
      }
      
      public static function getActionIsAutoEnd(_arg_1:uint) : Boolean
      {
         var _local_2:XML = _actionMap.getValue(_arg_1);
         if(Boolean(_local_2))
         {
            return Boolean(int(_local_2.@autoEnd));
         }
         return true;
      }
      
      public static function getActionSouLoops(_arg_1:uint) : int
      {
         var _local_2:XML = _actionMap.getValue(_arg_1);
         if(Boolean(_local_2))
         {
            if(!_local_2.hasOwnProperty("@souLoops"))
            {
               return 0;
            }
            return int(_local_2.@souLoops);
         }
         return 0;
      }
      
      public static function getExpID() : Array
      {
         var arr:Array = null;
         var xmlArr:Array = null;
         arr = null;
         if(MainManager.actorInfo.superNono)
         {
            xmlArr = _superExpMap.getValues();
         }
         else
         {
            xmlArr = _expMap.getValues();
         }
         arr = [];
         xmlArr.forEach(function(_arg_1:XML, _arg_2:int, _arg_3:Array):void
         {
            var _local_6:int = 0;
            var _local_4:int = int(_arg_1.@odds);
            var _local_5:uint = uint(_arg_1.@id);
            while(_local_6 < _local_4)
            {
               arr.push(_local_5);
               _local_6++;
            }
         });
         return arr;
      }
      
      public static function getLinesIDForExp(_arg_1:uint, _arg_2:uint, _arg_3:uint) : Array
      {
         var _local_4:XML = null;
         var _local_5:String = null;
         var _local_6:Array = null;
         var _local_7:Array = null;
         var _local_8:uint = 0;
         var _local_9:String = null;
         var _local_10:String = null;
         if(MainManager.actorInfo.superNono)
         {
            _local_4 = _superExpMap.getValue(_arg_1);
         }
         else
         {
            _local_4 = _expMap.getValue(_arg_1);
         }
         if(Boolean(_local_4))
         {
            _local_5 = String(_local_4.@lines);
            _local_6 = _local_5.split(",");
            _local_7 = [];
            for each(_local_8 in _local_6)
            {
               if(MainManager.actorInfo.superNono)
               {
                  _local_4 = _superLinesMap.getValue(_local_8);
               }
               else
               {
                  _local_4 = _linesMap.getValue(_arg_1);
               }
               if(Boolean(_local_4))
               {
                  _local_9 = String(_local_4.@energy);
                  if(_local_9.indexOf(_arg_2.toString()) != -1)
                  {
                     _local_10 = String(_local_4.@mate);
                     if(_local_10.indexOf(_arg_3.toString()) != -1)
                     {
                        _local_7.push(_local_8);
                     }
                  }
               }
            }
            return _local_7;
         }
         return [];
      }
   }
}

