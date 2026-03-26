package com.robot.core.config.xml
{
   import com.robot.core.config.*;
   import org.taomee.ds.*;
   import org.taomee.utils.*;
   
   public class ItemTipXMLInfo
   {
      
      private static var xmllist:XMLList;
      
      private static var xml:XML;
      
      private static var _path:String = "43";
      
      public static var isSetup:Boolean = false;
      
      public static var _map:HashMap = new HashMap();
      
      public function ItemTipXMLInfo()
      {
         super();
      }
      
      public static function setup(callBack:Function) : void
      {
         var onLoad:Function = function(_arg_1:XML):void
         {
            var _local_2:XML = null;
            _map = new HashMap();
            xml = _arg_1;
            xmllist = xml.descendants("item");
            for each(_local_2 in xmllist)
            {
               _map.add(uint(_local_2.@id),_local_2);
            }
            isSetup = true;
            callBack();
            xmlLoader = null;
         };
         var xmlLoader:XmlLoader = new XmlLoader();
         xmlLoader.loadXML(_path,XmlConfig.getXmlVerByPath(_path),onLoad);
      }
      
      public static function getItemDes(_arg_1:uint) : String
      {
         var _local_2:XML = _map.getValue(_arg_1);
         if(Boolean(_local_2))
         {
            return _local_2.@des;
         }
         return "";
      }
      
      public static function getItemColor(_arg_1:uint) : String
      {
         var _local_2:XML = _map.getValue(_arg_1);
         if(Boolean(_local_2))
         {
            return _local_2.@color;
         }
         return "#ffffff";
      }
      
      public static function getPetDes(id:uint, level:uint = 1) : String
      {
         var xml:XML = null;
         var str:String = null;
         var _x:XML = null;
         var i:XML = null;
         if(level == 0)
         {
            level = 1;
         }
         xml = _map.getValue(id);
         if(Boolean(xml))
         {
            str = "";
            _x = xml.pet.level.(@value == level.toString())[0];
            if(_x == null)
            {
               return "";
            }
            for each(i in _x.list)
            {
               str += i.@des + "\r";
            }
            return str;
         }
         return "";
      }
      
      public static function getTeamPKDes(id:uint, level:uint = 1) : String
      {
         var xml:XML = null;
         var str:String = null;
         var _x:XML = null;
         var i:XML = null;
         if(level == 0)
         {
            level = 1;
         }
         xml = _map.getValue(id);
         if(Boolean(xml))
         {
            str = "";
            _x = xml.teamPK.level.(@value == level.toString())[0];
            if(_x == null)
            {
               return "";
            }
            for each(i in _x.list)
            {
               str += i.@des + "\r";
            }
            return str;
         }
         return "";
      }
   }
}

