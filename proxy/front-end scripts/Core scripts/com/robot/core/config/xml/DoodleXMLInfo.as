package com.robot.core.config.xml
{
   public class DoodleXMLInfo
   {
      
      private static var _dataList:XMLList;
      
      private static var _url:String;
      
      private static var _preUrl:String;
      
      public function DoodleXMLInfo()
      {
         super();
      }
      
      public static function setup(_arg_1:XML) : void
      {
         _url = _arg_1.@url.toString();
         _preUrl = _url.replace(/swf\//,"prev/");
         _dataList = _arg_1.elements("Item");
      }
      
      public static function getSwfURL(_arg_1:uint) : String
      {
         if(_arg_1 == 0)
         {
            return "";
         }
         return _url + _arg_1.toString() + ".swf";
      }
      
      public static function getPrevURL(_arg_1:uint) : String
      {
         if(_arg_1 == 0)
         {
            return "";
         }
         return _preUrl + _arg_1.toString() + ".swf";
      }
      
      public static function getName(id:uint) : String
      {
         return _dataList.(@ID == id.toString()).@name[0].toString();
      }
      
      public static function getPrice(id:uint) : uint
      {
         return uint(_dataList.(@ID == id.toString()).@Price[0].toString());
      }
      
      public static function getColor(id:uint) : uint
      {
         return uint(_dataList.(@ID == id.toString()).@Color[0]);
      }
      
      public static function getTexture(id:uint) : uint
      {
         return uint(_dataList.(@ID == id.toString()).@Texture[0]);
      }
      
      public static function getLength() : int
      {
         return _dataList.length();
      }
      
      public static function getList() : XMLList
      {
         return _dataList;
      }
   }
}

