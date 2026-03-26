package com.robot.core.config.xml
{
   import com.robot.core.config.*;
   import org.taomee.ds.*;
   import org.taomee.utils.*;
   
   public class GoldProductXMLInfo
   {
      
      private static var _productMap:HashMap;
      
      private static var _itemMap:HashMap;
      
      private static var _xml:XML;
      
      private static var _xmllist:XMLList;
      
      private static var _path:String = "30001";
      
      public function GoldProductXMLInfo()
      {
         super();
      }
      
      public static function setup(callBack:Function) : void
      {
         var item:XML = null;
         item = null;
         _productMap = new HashMap();
         _itemMap = new HashMap();
         var onLoad:Function = function(_arg_1:XML):void
         {
            _xml = _arg_1;
            _xmllist = _xml.elements("item");
            for each(item in _xmllist)
            {
               _productMap.add(item.@productID.toString(),item);
               _itemMap.add(item.@itemID.toString(),item);
            }
            callBack();
            xmlLoader = null;
         };
         var xmlLoader:XmlLoader = new XmlLoader();
         xmlLoader.loadXML_Dll(_path,XmlConfig.getXmlVerByPath(_path),onLoad);
      }
      
      public static function getProductByItemId(_arg_1:uint) : uint
      {
         var _local_2:XML = _itemMap.getValue(_arg_1.toString());
         if(_local_2 == null)
         {
            return 0;
         }
         return uint(_local_2.@productID);
      }
      
      public static function getItemIDs(proID:uint) : Array
      {
         var xml:XML = null;
         var str:String = null;
         xml = _xmllist.(@productID == proID)[0];
         if(!Boolean(xml))
         {
            return null;
         }
         str = xml.@itemID;
         return str.split("|");
      }
      
      public static function getNameByProID(_arg_1:uint) : String
      {
         var _local_2:XML = _productMap.getValue(_arg_1);
         if(Boolean(_local_2))
         {
            return _local_2.@name;
         }
         return "";
      }
      
      public static function getNameByItemID(_arg_1:uint) : String
      {
         var _local_2:XML = _itemMap.getValue(_arg_1);
         if(Boolean(_local_2))
         {
            return _local_2.@name;
         }
         return "";
      }
      
      public static function getPriceByProID(proID:uint) : uint
      {
         var xml:XML = null;
         xml = _xmllist.(@productID == proID)[0];
         if(xml == null)
         {
            return 0;
         }
         return xml.@price;
      }
      
      public static function getPriceByItemID(id:uint) : uint
      {
         var xml:XML = null;
         try
         {
            xml = _xmllist.(@itemID == id)[0];
            return xml.@price;
         }
         catch(error:Error)
         {
            return 999999999;
         }
      }
      
      public static function getVipByProID(proID:uint) : Number
      {
         var xml:XML = null;
         xml = _xmllist.(@productID == proID)[0];
         return xml.@vip;
      }
      
      public static function getVipByItemID(id:uint) : Number
      {
         var xml:XML = null;
         xml = _xmllist.(@itemID == id)[0];
         return xml.@vip;
      }
   }
}

