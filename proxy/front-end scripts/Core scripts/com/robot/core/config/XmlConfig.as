package com.robot.core.config
{
   import org.taomee.ds.*;
   
   public class XmlConfig
   {
      
      private static var xml:XML;
      
      private static var hashMap:HashMap = new HashMap();
      
      private static var nameHashMap:HashMap = new HashMap();
      
      public function XmlConfig()
      {
         super();
      }
      
      public static function setup(_arg_1:XML) : void
      {
         var _local_2:XML = null;
         xml = _arg_1;
         for each(_local_2 in xml["xml"].elements())
         {
            hashMap.add(String(_local_2.@path),String(_local_2.@ver));
            nameHashMap.add(String(_local_2.@path),String(_local_2.@name));
         }
      }
      
      public static function getXmlVerByPath(_arg_1:String) : String
      {
         if(!hashMap.containsKey(_arg_1))
         {
            return "";
         }
         return hashMap.getValue(_arg_1);
      }
      
      public static function getXmlNameByPath(_arg_1:String) : String
      {
         if(!nameHashMap.containsKey(_arg_1))
         {
            return "";
         }
         return nameHashMap.getValue(_arg_1);
      }
   }
}

