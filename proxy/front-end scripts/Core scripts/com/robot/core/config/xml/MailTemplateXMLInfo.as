package com.robot.core.config.xml
{
   import com.robot.core.config.*;
   import flash.geom.*;
   import org.taomee.ds.*;
   import org.taomee.gemo.*;
   
   public class MailTemplateXMLInfo
   {
      
      private static var _hashMap:HashMap;
      
      private static var _xml:XML;
      
      private static var _xmllist:XMLList;
      
      private static var xmlClass:Class = MailTemplateXMLInfo_xmlClass;
      
      setup();
      
      public function MailTemplateXMLInfo()
      {
         super();
      }
      
      private static function setup() : void
      {
         var _local_1:XML = null;
         _hashMap = new HashMap();
         _xml = XML(new xmlClass());
         _xmllist = _xml.elements("item");
         for each(_local_1 in _xmllist)
         {
            _hashMap.add(uint(_local_1.@id),_local_1);
         }
      }
      
      public static function getTemplateSwf(_arg_1:uint) : String
      {
         return ClientConfig.getMapPath(_arg_1);
      }
      
      public static function getTitle(_arg_1:uint) : String
      {
         var _local_2:XML = _hashMap.getValue(_arg_1);
         if(_local_2 == null)
         {
            return "";
         }
         return _local_2;
      }
      
      public static function getTxtPos(_arg_1:uint) : Point
      {
         var _local_2:XML = _hashMap.getValue(_arg_1);
         return new Point(uint(_local_2.@x),uint(_local_2.@y));
      }
      
      public static function getTxtSize(_arg_1:uint) : IntDimension
      {
         var _local_2:XML = _hashMap.getValue(_arg_1);
         return new IntDimension(uint(_local_2.@width),uint(_local_2.@height));
      }
      
      public static function getCategoryList(type:uint) : Array
      {
         var l:XMLList = null;
         var array:Array = null;
         var i:XML = null;
         l = _xmllist.(@type == type.toString());
         array = [];
         for each(i in l)
         {
            array.push(i.@id);
         }
         return array;
      }
   }
}

