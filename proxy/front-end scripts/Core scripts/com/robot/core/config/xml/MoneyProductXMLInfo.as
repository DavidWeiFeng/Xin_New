package com.robot.core.config.xml
{
   import org.taomee.ds.*;
   
   public class MoneyProductXMLInfo
   {
      
      private static var _productMap:HashMap;
      
      private static var _itemMap:HashMap;
      
      private static var _xml:XML;
      
      private static var _xmllist:XMLList;
      
      private static var xmlClass:Class = MoneyProductXMLInfo_xmlClass;
      
      setup();
      
      public function MoneyProductXMLInfo()
      {
         super();
      }
      
      private static function setup() : void
      {
         var _local_1:XML = null;
         _productMap = new HashMap();
         _itemMap = new HashMap();
         _xml = XML(new xmlClass());
         _xmllist = _xml.elements("item");
         for each(_local_1 in _xmllist)
         {
            _productMap.add(_local_1.@productID.toString(),_local_1);
            _itemMap.add(_local_1.@itemID.toString(),_local_1);
         }
      }
      
      public static function getItemIDs(proID:uint) : Array
      {
         var xml:XML = null;
         var str:String = null;
         xml = _xmllist.(@productID == proID)[0];
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
         return ItemXMLInfo.getName(_arg_1);
      }
      
      public static function getPriceByProID(proID:uint) : Number
      {
         var xml:XML = null;
         xml = _xmllist.(@productID == proID)[0];
         return xml.@price;
      }
      
      public static function getPriceByItemID(id:uint) : Number
      {
         var xml:XML = null;
         xml = _xmllist.(@itemID == id)[0];
         return xml.@price;
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
      
      public static function getGoldByProID(proID:uint) : Number
      {
         var xml:XML = null;
         xml = _xmllist.(@productID == proID)[0];
         return xml.@gold;
      }
      
      public static function getGoldByItemID(id:uint) : Number
      {
         var xml:XML = null;
         xml = _xmllist.(@itemID == id)[0];
         return xml.@gold;
      }
   }
}

