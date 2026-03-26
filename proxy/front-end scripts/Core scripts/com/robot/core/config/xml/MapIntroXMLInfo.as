package com.robot.core.config.xml
{
   import com.robot.core.config.*;
   import org.taomee.ds.*;
   import org.taomee.utils.*;
   
   public class MapIntroXMLInfo
   {
      
      private static var _dataMap:HashMap;
      
      private static var _path:String = "220";
      
      public function MapIntroXMLInfo()
      {
         super();
      }
      
      public static function setup(callback:Function) : void
      {
         var onLoad:Function = function(_arg_1:XML):void
         {
            var _local_2:XML = null;
            _dataMap = new HashMap();
            var _local_3:XMLList = _arg_1.elements("map");
            for each(_local_2 in _local_3)
            {
               _dataMap.add(uint(_local_2.@id),_local_2);
            }
            xmlLoader = null;
            callback();
         };
         var xmlLoader:XmlLoader = new XmlLoader();
         xmlLoader.loadXML(_path,XmlConfig.getXmlVerByPath(_path),onLoad);
      }
      
      public static function getType(_arg_1:uint) : uint
      {
         var _local_2:XML = _dataMap.getValue(_arg_1);
         if(Boolean(_local_2.hasOwnProperty("@type")))
         {
            return uint(_local_2.@type);
         }
         return 0;
      }
      
      public static function getDifficulty(_arg_1:uint) : uint
      {
         var _local_2:XML = _dataMap.getValue(_arg_1);
         if(Boolean(_local_2.hasOwnProperty("@difficulty")))
         {
            return uint(_local_2.@difficulty);
         }
         return 0;
      }
      
      public static function getLevel(_arg_1:uint) : String
      {
         var _local_2:XML = _dataMap.getValue(_arg_1);
         if(Boolean(_local_2.hasOwnProperty("@level")))
         {
            return String(_local_2.@level);
         }
         return "";
      }
      
      public static function getDes(_arg_1:uint) : String
      {
         var _local_2:XML = _dataMap.getValue(_arg_1);
         if(Boolean(_local_2.hasOwnProperty("@des")))
         {
            return String(_local_2.@des);
         }
         return "";
      }
      
      public static function getTasks(_arg_1:uint) : Array
      {
         var _local_2:String = null;
         var _local_3:Array = null;
         var _local_4:XML = _dataMap.getValue(_arg_1);
         if(Boolean(_local_4.hasOwnProperty("task")))
         {
            _local_2 = String(_local_4.task.@taskIDs);
            return _local_2.split("|");
         }
         return [];
      }
      
      public static function getSprites(_arg_1:uint) : Array
      {
         var _local_2:String = null;
         var _local_3:Array = null;
         var _local_4:XML = _dataMap.getValue(_arg_1);
         if(Boolean(_local_4.hasOwnProperty("sprite")))
         {
            _local_2 = String(_local_4.sprite.@petIDs);
            return _local_2.split("|");
         }
         return [];
      }
      
      public static function getMinerals(_arg_1:uint) : Array
      {
         var _local_2:String = null;
         var _local_3:Array = null;
         var _local_4:XML = _dataMap.getValue(_arg_1);
         if(Boolean(_local_4.hasOwnProperty("minerals")))
         {
            _local_2 = String(_local_4.minerals.@IDs);
            return _local_2.split("|");
         }
         return [];
      }
      
      public static function getGames(_arg_1:uint) : Array
      {
         var _local_2:String = null;
         var _local_3:Array = null;
         var _local_4:XML = _dataMap.getValue(_arg_1);
         if(Boolean(_local_4.hasOwnProperty("game")))
         {
            _local_2 = String(_local_4.game.@names);
            return _local_2.split("|");
         }
         return [];
      }
      
      public static function getNonos(_arg_1:uint) : Array
      {
         var _local_2:String = null;
         var _local_3:Array = null;
         var _local_4:XML = _dataMap.getValue(_arg_1);
         if(Boolean(_local_4.hasOwnProperty("nono")))
         {
            _local_2 = String(_local_4.nono.@names);
            return _local_2.split("|");
         }
         return [];
      }
      
      public static function getNewgoods(_arg_1:uint) : Array
      {
         var _local_2:String = null;
         var _local_3:Array = null;
         var _local_4:XML = _dataMap.getValue(_arg_1);
         if(Boolean(_local_4.hasOwnProperty("newgoods")))
         {
            _local_2 = String(_local_4.newgoods.@names);
            return _local_2.split("|");
         }
         return [];
      }
   }
}

