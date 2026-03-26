package com.robot.core.config.xml
{
   import com.robot.core.config.*;
   import org.taomee.ds.*;
   import org.taomee.utils.*;
   
   public class PetBookXMLInfo
   {
      
      private static var _dataMap:HashMap;
      
      private static var _path:String = "214";
      
      public static var isSetup:Boolean = false;
      
      public function PetBookXMLInfo()
      {
         super();
      }
      
      public static function setup(callBack:Function) : void
      {
         var item:XML = null;
         item = null;
         _dataMap = new HashMap();
         var onLoad:Function = function(_arg_1:XML):void
         {
            var _local_2:XMLList = _arg_1.elements("Monster");
            for each(item in _local_2)
            {
               _dataMap.add(item.@ID.toString(),item);
            }
            isSetup = true;
            callBack();
            xmlLoader = null;
         };
         var xmlLoader:XmlLoader = new XmlLoader();
         xmlLoader.loadXML(_path,XmlConfig.getXmlVerByPath(_path),onLoad);
      }
      
      public static function get dataList() : Array
      {
         return _dataMap.getValues();
      }
      
      public static function getPetXML(_arg_1:uint) : XML
      {
         return _dataMap.getValue(_arg_1);
      }
      
      public static function getName(_arg_1:uint) : String
      {
         return getPetXML(_arg_1).@DefName.toString();
      }
      
      public static function getType(_arg_1:uint) : String
      {
         return getPetXML(_arg_1).@Type.toString();
      }
      
      public static function getHeight(_arg_1:uint) : String
      {
         return getPetXML(_arg_1).@Height.toString();
      }
      
      public static function getWeight(_arg_1:uint) : String
      {
         return getPetXML(_arg_1).@Weight.toString();
      }
      
      public static function getFoundin(_arg_1:uint) : String
      {
         return getPetXML(_arg_1).@Foundin.toString();
      }
      
      public static function getFeatures(_arg_1:uint) : String
      {
         return getPetXML(_arg_1).@Features.toString();
      }
      
      public static function hasSound(_arg_1:uint) : Boolean
      {
         var _local_2:XML = getPetXML(_arg_1) as XML;
         if(Boolean(_local_2.hasOwnProperty("@hasSound")))
         {
            return Boolean(_local_2.@hasSound);
         }
         return false;
      }
      
      public static function food(_arg_1:uint) : String
      {
         return getPetXML(_arg_1).@Food.toString();
      }
   }
}

