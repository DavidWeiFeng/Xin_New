package com.robot.core.config.xml
{
   import org.taomee.ds.*;
   
   public class EmotionXMLInfo
   {
      
      private static var _hashMap:HashMap;
      
      private static var _xml:XML;
      
      private static var _xmllist:XMLList;
      
      private static var path:String;
      
      private static var xmlClass:Class = EmotionXMLInfo_xmlClass;
      
      setup();
      
      public function EmotionXMLInfo()
      {
         super();
      }
      
      private static function setup() : void
      {
         var _local_1:XML = null;
         _xml = XML(new xmlClass());
         path = _xml.@path;
         _hashMap = new HashMap();
         _xmllist = _xml.emotion;
         for each(_local_1 in _xmllist)
         {
            _hashMap.add(_local_1.@shortcut.toString(),_local_1);
         }
      }
      
      public static function getURL(_arg_1:String) : String
      {
         var _local_2:XML = _hashMap.getValue(_arg_1);
         if(!_local_2)
         {
            throw new Error("不存在该表情快捷键");
         }
         return path + _local_2.@id + ".swf";
      }
      
      public static function getDes(_arg_1:String) : String
      {
         var _local_2:XML = _hashMap.getValue(_arg_1);
         if(!_local_2)
         {
            throw new Error("不存在该表情快捷键");
         }
         return _local_2.@des;
      }
   }
}

