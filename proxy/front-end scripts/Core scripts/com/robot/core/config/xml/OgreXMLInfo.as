package com.robot.core.config.xml
{
   import flash.geom.*;
   import org.taomee.ds.*;
   
   public class OgreXMLInfo
   {
      
      private static var _ogreMap:HashMap;
      
      private static var _bossMap:HashMap;
      
      private static var _specialMap:HashMap;
      
      private static var xmlClass:Class = OgreXMLInfo_xmlClass;
      
      setup();
      
      public function OgreXMLInfo()
      {
         super();
      }
      
      private static function setup() : void
      {
         var _local_1:XML = null;
         var _local_2:XMLList = null;
         var _local_3:XML = null;
         var _local_4:XMLList = null;
         var _local_5:XML = null;
         var _local_6:String = null;
         var _local_7:Array = null;
         var _local_8:int = 0;
         var _local_9:int = 0;
         var _local_10:Array = null;
         var _local_11:String = null;
         var _local_12:Array = null;
         var _local_13:int = 0;
         var _local_14:Array = null;
         _ogreMap = new HashMap();
         var _local_15:XMLList = XML(new xmlClass()).elements("ogre")[0].elements("item");
         for each(_local_1 in _local_15)
         {
            _local_6 = _local_1.@pList.toString();
            _local_7 = _local_6.split("|");
            _local_8 = int(_local_7.length);
            _local_9 = 0;
            while(_local_9 < _local_8)
            {
               _local_10 = _local_7[_local_9].split(",");
               _local_7[_local_9] = new Point(_local_10[0],_local_10[1]);
               _local_9++;
            }
            _ogreMap.add(uint(_local_1.@id),_local_7);
         }
         _bossMap = new HashMap();
         _local_2 = XML(new xmlClass()).elements("boss")[0].elements("item");
         for each(_local_3 in _local_2)
         {
            _bossMap.add(uint(_local_3.@id),_local_3);
         }
         _specialMap = new HashMap();
         _local_4 = XML(new xmlClass()).elements("special")[0].elements("item");
         for each(_local_5 in _local_4)
         {
            _local_11 = _local_5.@pList.toString();
            _local_12 = _local_11.split("|");
            _local_13 = int(_local_12.length);
            _local_9 = 0;
            while(_local_9 < _local_13)
            {
               _local_14 = _local_12[_local_9].split(",");
               _local_12[_local_9] = new Point(_local_14[0],_local_14[1]);
               _local_9++;
            }
            _specialMap.add(uint(_local_5.@id),_local_12);
         }
      }
      
      public static function getOgreList(_arg_1:uint) : Array
      {
         return _ogreMap.getValue(_arg_1);
      }
      
      public static function getBossList(mapID:uint, region:uint) : Array
      {
         var str:String = null;
         var arr:Array = null;
         var len:int = 0;
         var k:int = 0;
         var parr:Array = null;
         var xml:XML = _bossMap.getValue(mapID);
         if(Boolean(xml))
         {
            xml = xml.elements("region").(@id == region)[0];
            if(Boolean(xml))
            {
               str = xml.@pList.toString();
               arr = str.split("|");
               len = int(arr.length);
               k = 0;
               while(k < len)
               {
                  parr = arr[k].split(",");
                  arr[k] = new Point(parr[0],parr[1]);
                  k += 1;
               }
               return arr;
            }
         }
         return null;
      }
      
      public static function getSpecialList(_arg_1:uint) : Array
      {
         return _specialMap.getValue(_arg_1);
      }
   }
}

