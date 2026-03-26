package com.robot.core.config.xml
{
   import com.robot.core.config.*;
   import org.taomee.ds.*;
   import org.taomee.utils.*;
   
   public class PetShopXmlInfo
   {
      
      private static var _xmllist:XMLList;
      
      private static var _itemMap:HashMap;
      
      private static var _productMap:HashMap;
      
      private static var xml:XML;
      
      private static var _path:String = "30001";
      
      public static var isSetup:Boolean = false;
      
      public function PetShopXmlInfo()
      {
         super();
      }
      
      public static function setup(callBack:Function) : void
      {
         var onLoad:Function = function(_arg_1:XML):void
         {
            var _local_2:XML = null;
            _itemMap = new HashMap();
            _productMap = new HashMap();
            xml = _arg_1;
            _xmllist = xml.descendants("item");
            for each(_local_2 in _xmllist)
            {
               _itemMap.add(uint(_local_2.@itemID),_local_2);
               _productMap.add(_local_2.@productID.toString(),_local_2);
            }
            isSetup = true;
            callBack();
            xmlLoader = null;
         };
         var xmlLoader:XmlLoader = new XmlLoader();
         xmlLoader.loadXML_Dll(_path,XmlConfig.getXmlVerByPath(_path),onLoad);
      }
      
      public static function getItemIdArray() : Array
      {
         return _itemMap.getKeys();
      }
      
      public static function getItemIDs(proID:uint) : Array
      {
         var ttt:Array;
         var xml:XML = null;
         var str:String = null;
         trace("PetShopXmlInfo.getItemIDs",proID);
         ttt = new Array();
         xml = _xmllist.(@productID == proID)[0];
         if(Boolean(xml))
         {
            return ttt;
         }
         str = xml.@itemID;
         return str.split("|");
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
      
      public static function getProductByItemId(_arg_1:uint) : uint
      {
         var _local_2:XML = _itemMap.getValue(_arg_1.toString());
         if(_local_2 == null)
         {
            return 0;
         }
         return uint(_local_2.@productID);
      }
      
      public static function getPriceByProID(proID:uint) : Number
      {
         var xml:XML = null;
         trace("PetShopXmlInfo.getPriceByProID",proID);
         xml = _xmllist.(@productID == proID)[0];
         if(!Boolean(xml))
         {
            return 9999999999;
         }
         return xml.@price;
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
      
      public static function getMoneyTypeByItemID(_arg_1:uint) : uint
      {
         var _local_2:XML = _itemMap.getValue(_arg_1.toString());
         if(_local_2 == null)
         {
            return 0;
         }
         return uint(_local_2.@moneyType);
      }
   }
}

