package com.robot.core.config.xml
{
   import org.taomee.ds.*;
   
   public class HatchTaskXMLInfo
   {
      
      private static var _dataMap:HashMap;
      
      private static const PRO:String = "pro";
      
      private static var xmlClass:Class = HatchTaskXMLInfo_xmlClass;
      
      setup();
      
      public function HatchTaskXMLInfo()
      {
         super();
      }
      
      public static function get dataMap() : HashMap
      {
         return _dataMap;
      }
      
      private static function setup() : void
      {
         var _local_1:XML = null;
         var _local_2:uint = 0;
         _dataMap = new HashMap();
         var _local_3:XMLList = XML(new xmlClass()).elements("task");
         for each(_local_1 in _local_3)
         {
            _local_2 = uint(_local_1.@ID);
            _dataMap.add(_local_2,_local_1);
         }
      }
      
      public static function getName(_arg_1:uint) : String
      {
         var _local_2:XML = _dataMap.getValue(_arg_1);
         if(Boolean(_local_2))
         {
            return _local_2.@name.toString();
         }
         return "";
      }
      
      public static function getTaskProCount(_arg_1:uint) : int
      {
         var _local_2:XML = _dataMap.getValue(_arg_1);
         if(Boolean(_local_2))
         {
            return _local_2.elements(PRO).length();
         }
         return 0;
      }
      
      public static function getTaskMapList(_arg_1:uint) : Array
      {
         var _local_3:uint = 0;
         var _local_2:Array = [];
         while(_local_3 < getTaskProCount(_arg_1))
         {
            _local_2.push(getProMap(_arg_1,_local_3));
            _local_3++;
         }
         return _local_2;
      }
      
      public static function isDir(_arg_1:uint) : Boolean
      {
         var _local_2:XML = _dataMap.getValue(_arg_1);
         if(Boolean(_local_2))
         {
            return Boolean(int(_local_2.@isDir));
         }
         return false;
      }
      
      public static function isMat(_arg_1:uint) : Boolean
      {
         var _local_2:XML = _dataMap.getValue(_arg_1);
         if(Boolean(_local_2))
         {
            return Boolean(int(_local_2.@isMat));
         }
         return false;
      }
      
      public static function getProName(_arg_1:uint, _arg_2:uint) : String
      {
         var _local_3:XML = _dataMap.getValue(_arg_1);
         if(Boolean(_local_3))
         {
            return _local_3.elements(PRO)[_arg_2].@name.toString();
         }
         return "";
      }
      
      public static function getProMCName(_arg_1:uint, _arg_2:uint) : String
      {
         var _local_3:XML = _dataMap.getValue(_arg_1);
         if(Boolean(_local_3))
         {
            return _local_3.elements(PRO)[_arg_2].@mc.toString();
         }
         return "";
      }
      
      public static function getProMap(_arg_1:uint, _arg_2:uint) : uint
      {
         var _local_3:XML = _dataMap.getValue(_arg_1);
         if(Boolean(_local_3))
         {
            return _local_3.elements(PRO)[_arg_2].@map;
         }
         return 0;
      }
      
      public static function getMapPro(_arg_1:uint, _arg_2:uint) : Array
      {
         var _local_3:XMLList = null;
         var _local_4:uint = 0;
         var _local_5:Array = [];
         var _local_6:XML = _dataMap.getValue(_arg_1);
         if(Boolean(_local_6))
         {
            _local_3 = _local_6.elements(PRO);
            _local_4 = 0;
            while(_local_4 < _local_3.length())
            {
               if(_local_3[_local_4].@map == _arg_2)
               {
                  _local_5.push(_local_4);
               }
               _local_4++;
            }
         }
         return _local_5;
      }
      
      public static function getProParent(_arg_1:uint, _arg_2:uint) : Boolean
      {
         var _local_3:Boolean = false;
         if(_arg_2 == 0)
         {
            return true;
         }
         var _local_4:XML = _dataMap.getValue(_arg_1);
         if(Boolean(_local_4))
         {
            return Boolean(_local_4.elements(PRO)[_arg_2 - 1].@isMat);
         }
         return false;
      }
      
      public static function getMapSoulBeadList(_arg_1:uint) : Array
      {
         var _local_2:XML = null;
         var _local_3:uint = 0;
         var _local_4:Array = [];
         var _local_5:XML = XML(new xmlClass());
         var _local_6:XMLList = _local_5..pro;
         for each(_local_2 in _local_6)
         {
            if(_local_2.@map == _arg_1)
            {
               _local_3 = uint(_local_2.parent().@ID);
               _local_4.push(_local_3);
            }
         }
         return _local_4;
      }
      
      public static function getProDes(_arg_1:uint, _arg_2:uint) : String
      {
         var _local_3:String = null;
         var _local_4:XML = _dataMap.getValue(_arg_1);
         if(Boolean(_local_4))
         {
            return String(_local_4.elements(PRO)[_arg_2].@des);
         }
         return "";
      }
   }
}

