package com.robot.core.config.xml
{
   import com.robot.core.config.*;
   import com.robot.core.manager.*;
   import flash.geom.*;
   import org.taomee.ds.*;
   import org.taomee.utils.*;
   
   public class MapXMLInfo
   {
      
      private static var _dataMap:HashMap;
      
      private static var _path:String = "210";
      
      setup();
      
      public function MapXMLInfo()
      {
         super();
      }
      
      private static function setup() : void
      {
         var item:XML = null;
         item = null;
         _dataMap = new HashMap();
         var onLoad:Function = function(_arg_1:XML):void
         {
            var _local_2:XMLList = _arg_1.elements("map");
            for each(item in _local_2)
            {
               _dataMap.add(uint(item.@id),item);
            }
            xmlLoader = null;
         };
         var xmlLoader:XmlLoader = new XmlLoader();
         xmlLoader.loadXML(_path,XmlConfig.getXmlVerByPath(_path),onLoad);
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
      
      public static function getDefaultPos(_arg_1:uint) : Point
      {
         var _local_2:XML = _dataMap.getValue(_arg_1);
         if(Boolean(_local_2))
         {
            return new Point(int(_local_2.@x),int(_local_2.@y));
         }
         return MainManager.getStageCenterPoint();
      }
      
      public static function getRoomDefaultFloPos(_arg_1:uint) : Point
      {
         if(_arg_1 < MapManager.ID_MAX)
         {
            return MainManager.getStageCenterPoint();
         }
         var _local_2:XML = _dataMap.getValue(_arg_1);
         if(Boolean(_local_2))
         {
            return new Point(int(_local_2.@fx),int(_local_2.@fy));
         }
         return MainManager.getStageCenterPoint();
      }
      
      public static function getRoomDefaultWapPos(_arg_1:uint) : Point
      {
         if(_arg_1 < MapManager.ID_MAX)
         {
            return MainManager.getStageCenterPoint();
         }
         var _local_2:XML = _dataMap.getValue(_arg_1);
         if(Boolean(_local_2))
         {
            return new Point(int(_local_2.@wx),int(_local_2.@wy));
         }
         return MainManager.getStageCenterPoint();
      }
      
      public static function getHeadPos(_arg_1:uint) : Point
      {
         if(_arg_1 < MapManager.ID_MAX)
         {
            return MainManager.getStageCenterPoint();
         }
         var _local_2:XML = _dataMap.getValue(_arg_1);
         if(Boolean(_local_2))
         {
            return new Point(int(_local_2.@hx),int(_local_2.@hy));
         }
         return MainManager.getStageCenterPoint();
      }
      
      public static function getIsLocal(_arg_1:uint) : Boolean
      {
         var _local_2:XML = _dataMap.getValue(_arg_1);
         if(!_local_2)
         {
            return false;
         }
         if(Boolean(_local_2.hasOwnProperty("@isLocal")))
         {
            return Boolean(uint(_local_2.@isLocal));
         }
         return false;
      }
   }
}

