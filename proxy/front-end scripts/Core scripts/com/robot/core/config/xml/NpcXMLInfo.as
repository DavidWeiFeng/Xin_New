package com.robot.core.config.xml
{
   import com.robot.core.manager.*;
   import org.taomee.ds.*;
   
   public class NpcXMLInfo
   {
      
      private static var _dataMap:HashMap;
      
      private static var xl:XMLList;
      
      private static var xmlClass:Class = NpcXMLInfo_xmlClass;
      
      setup();
      
      public function NpcXMLInfo()
      {
         super();
      }
      
      private static function setup() : void
      {
         var _local_1:XML = null;
         _dataMap = new HashMap();
         xl = XML(new xmlClass()).elements("npc");
         for each(_local_1 in xl)
         {
            _dataMap.add(uint(_local_1.@id),_local_1);
         }
      }
      
      public static function getIDList() : Array
      {
         return _dataMap.getKeys();
      }
      
      public static function getName(_arg_1:uint) : String
      {
         var _local_2:XML = _dataMap.getValue(_arg_1);
         if(Boolean(_local_2))
         {
            return String(_local_2.@name);
         }
         return "";
      }
      
      public static function getType(_arg_1:uint) : String
      {
         var _local_2:XML = _dataMap.getValue(_arg_1);
         if(Boolean(_local_2))
         {
            return String(_local_2.@type);
         }
         throw new Error("没有该NPC");
      }
      
      public static function getNpcXmlByMap(id:uint) : XMLList
      {
         var xmlList:XMLList = null;
         xmlList = xl.(@mapID == id.toString());
         return xmlList;
      }
      
      public static function getStartIDs(id:uint) : Array
      {
         var array:Array = null;
         var str:String = null;
         var i1:int = 0;
         array = null;
         str = xl.(@id == id).@startTask.toString();
         if(str == "")
         {
            return [];
         }
         array = str.split("|");
         array.forEach(function(_arg_1:*, _arg_2:int, _arg_3:Array):void
         {
            array[_arg_2] = uint(_arg_1);
         });
         if(MainManager.checkIsNovice())
         {
            i1 = 0;
            while(i1 < array.length)
            {
               if(array[i1] == 1 || array[i1] == 2 || array[i1] == 3 || array[i1] == 4)
               {
                  array.splice(i1,1);
                  i1 -= 1;
               }
               i1 += 1;
            }
            if(array.length == 0)
            {
               array = [];
            }
         }
         return array;
      }
      
      public static function getEndIDs(id:uint) : Array
      {
         var array:Array = null;
         var str:String = null;
         array = null;
         str = xl.(@id == id).@endTask.toString();
         if(str == "")
         {
            return [];
         }
         array = str.split("|");
         array.forEach(function(_arg_1:*, _arg_2:int, _arg_3:Array):void
         {
            array[_arg_2] = uint(_arg_1);
         });
         return array;
      }
      
      public static function getNpcProIDs(id:uint) : Array
      {
         var array:Array = null;
         var str:String = null;
         array = null;
         str = xl.(@id == id).@proTask.toString();
         if(str == "")
         {
            return [];
         }
         array = str.split("|");
         array.forEach(function(_arg_1:*, _arg_2:int, _arg_3:Array):void
         {
            array[_arg_2] = uint(_arg_1);
         });
         return array;
      }
   }
}

