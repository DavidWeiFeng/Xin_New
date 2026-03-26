package com.robot.core.config.xml
{
   import com.robot.core.manager.*;
   import flash.geom.*;
   import org.taomee.ds.*;
   
   public class HelpXMLInfo
   {
      
      private static var _dataMap:HashMap;
      
      private static var xl:XMLList;
      
      private static var xmlClass:Class = HelpXMLInfo_xmlClass;
      
      private static const PRO:String = "pro";
      
      setup();
      
      public function HelpXMLInfo()
      {
         super();
      }
      
      private static function setup() : void
      {
         var _local_1:XML = null;
         _dataMap = new HashMap();
         xl = new XML(new xmlClass()).elements("help");
         for each(_local_1 in xl)
         {
            _dataMap.add(uint(_local_1.@id),_local_1);
         }
      }
      
      public static function getIdList() : Array
      {
         return _dataMap.getKeys();
      }
      
      public static function getType(_arg_1:uint) : uint
      {
         var _local_2:XML = _dataMap.getValue(_arg_1);
         return uint(_local_2.@type);
      }
      
      public static function getArrowPoint(_arg_1:uint) : Point
      {
         var _local_2:XML = _dataMap.getValue(_arg_1);
         return new Point(_local_2.@arrowX,_local_2.@arrowY);
      }
      
      public static function getMapId(_arg_1:uint) : uint
      {
         var _local_2:XML = _dataMap.getValue(_arg_1);
         return new uint(_local_2.@mapId);
      }
      
      public static function getIsBack(_arg_1:uint) : Boolean
      {
         var _local_2:Boolean = false;
         var _local_3:XML = _dataMap.getValue(_arg_1);
         if(_local_3.@isBack == "1")
         {
            _local_2 = true;
         }
         else
         {
            _local_2 = false;
         }
         return _local_2;
      }
      
      public static function getItemAry(_arg_1:uint) : Array
      {
         var _local_5:int = 0;
         var _local_2:XML = _dataMap.getValue(_arg_1);
         var _local_3:uint = uint(_local_2.elements(PRO).length());
         var _local_4:Array = new Array();
         while(_local_5 < _local_3)
         {
            _local_4.push(new Array(_local_2.elements(PRO)[_local_5].@item,_local_2.elements(PRO)[_local_5].@clickTo));
            _local_5++;
         }
         return _local_4;
      }
      
      public static function getComment(_arg_1:uint) : String
      {
         var _local_2:XML = _dataMap.getValue(_arg_1);
         var _local_3:String = String(_local_2.des);
         _local_3 = _local_3.replace(/#nick/g,MainManager.actorInfo.nick);
         return _local_3.replace("$","\r");
      }
   }
}

