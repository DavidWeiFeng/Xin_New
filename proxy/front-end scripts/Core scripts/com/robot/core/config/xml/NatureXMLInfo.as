package com.robot.core.config.xml
{
   import org.taomee.ds.*;
   
   public class NatureXMLInfo
   {
      
      private static var _dataMap:HashMap;
      
      private static var xmlClass:Class = NatureXMLInfo_xmlClass;
      
      setup();
      
      public function NatureXMLInfo()
      {
         super();
      }
      
      private static function setup() : void
      {
         var _local_1:XML = null;
         _dataMap = new HashMap();
         var _local_2:XMLList = XML(new xmlClass()).elements("item");
         for each(_local_1 in _local_2)
         {
            _dataMap.add(uint(_local_1.@id),_local_1);
         }
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
      
      public static function getAttack(_arg_1:uint) : Number
      {
         var _local_2:XML = _dataMap.getValue(_arg_1);
         if(Boolean(_local_2))
         {
            return Number(_local_2.@m_attack);
         }
         return -1;
      }
      
      public static function getDefence(_arg_1:uint) : Number
      {
         var _local_2:XML = _dataMap.getValue(_arg_1);
         if(Boolean(_local_2))
         {
            return Number(_local_2.@m_defence);
         }
         return -1;
      }
      
      public static function getSpAttack(_arg_1:uint) : Number
      {
         var _local_2:XML = _dataMap.getValue(_arg_1);
         if(Boolean(_local_2))
         {
            return Number(_local_2.@m_SA);
         }
         return -1;
      }
      
      public static function getSpDefence(_arg_1:uint) : Number
      {
         var _local_2:XML = _dataMap.getValue(_arg_1);
         if(Boolean(_local_2))
         {
            return Number(_local_2.@m_SD);
         }
         return -1;
      }
      
      public static function getSpeed(_arg_1:uint) : Number
      {
         var _local_2:XML = _dataMap.getValue(_arg_1);
         if(Boolean(_local_2))
         {
            return Number(_local_2.@m_speed);
         }
         return -1;
      }
      
      public static function getDesc(_arg_1:uint) : String
      {
         var _local_2:XML = _dataMap.getValue(_arg_1);
         if(Boolean(_local_2))
         {
            return String(_local_2.@desc);
         }
         return "";
      }
   }
}

