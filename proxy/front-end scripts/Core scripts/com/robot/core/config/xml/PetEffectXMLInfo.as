package com.robot.core.config.xml
{
   import org.taomee.ds.*;
   
   public class PetEffectXMLInfo
   {
      
      private static var _dataMap:HashMap;
      
      private static var _statXML:XMLList;
      
      private static var _effectXmlMap:HashMap;
      
      private static var _descToStarIntroMap:HashMap;
      
      private static var xmlClass:Class = PetEffectXMLInfo_xmlClass;
      
      setup();
      
      public function PetEffectXMLInfo()
      {
         super();
      }
      
      private static function setup() : void
      {
         var item:XML = null;
         var _id:uint = 0;
         var eid:uint = 0;
         var arg:String = null;
         var cacheKey:String = null;
         var desc:String = null;
         var starIntroMap:HashMap = null;
         _dataMap = new HashMap();
         var xl:XMLList = XML(new xmlClass()).elements("NewSeIdx");
         _statXML = xl.(@Stat == 1);
         for each(item in xl)
         {
            _id = uint(item.@ItemId);
            if(_id > 0)
            {
               _dataMap.add(_id,item);
            }
         }
         _effectXmlMap = new HashMap();
         _descToStarIntroMap = new HashMap();
         for each(item in xl)
         {
            _id = uint(item.@ItemId);
            if(_id > 0)
            {
               _effectXmlMap.add(_id,item);
            }
         }
         for each(item in _statXML)
         {
            eid = uint(item.@Eid);
            arg = Boolean(item.@Args) ? item.@Args : "";
            if(!(eid <= 0 || arg == ""))
            {
               if(uint(item.@Idx) > 1000)
               {
                  desc = Boolean(item.@Desc) ? item.@Desc : "";
                  if(desc != "")
                  {
                     starIntroMap = _descToStarIntroMap.getValue(desc) as HashMap;
                     if(!starIntroMap)
                     {
                        starIntroMap = new HashMap();
                        _descToStarIntroMap.add(desc,starIntroMap);
                     }
                     starIntroMap.add(int(item.@StarLevel),Boolean(item.@Intro) ? item.@Intro : "");
                  }
               }
            }
         }
      }
      
      public static function getItemIdForEffectId(_arg_1:uint) : uint
      {
         var effectXml:XML = _effectXmlMap.getValue(_arg_1) as XML;
         if(effectXml != null)
         {
            return uint(effectXml.@ItemId);
         }
         var _local_2:XML = _dataMap.getValue(_arg_1) as XML;
         return Boolean(_local_2) ? uint(_local_2.@ItemId) : 0;
      }
      
      public static function getDes(_arg_1:uint) : String
      {
         var effectXml:XML = _effectXmlMap.getValue(_arg_1) as XML;
         if(effectXml != null)
         {
            return Boolean(effectXml.@Des) ? effectXml.@Des : "";
         }
         var _local_2:XML = _dataMap.getValue(_arg_1) as XML;
         return Boolean(_local_2) ? _local_2.@Des : "";
      }
      
      public static function getEffect(eid:uint, arg:String, idx:Number = -1) : String
      {
         var xmllist:XMLList = null;
         var xml:XML = null;
         var effectXml:XML = _effectXmlMap.getValue(eid) as XML;
         if(effectXml != null)
         {
            if(effectXml.@Args == arg && (idx == -1 || uint(effectXml.@Idx) == idx))
            {
               return Boolean(effectXml.@Desc) ? effectXml.@Desc : "";
            }
         }
         xmllist = idx > 0 ? _statXML.(@Eid == eid && @Idx == idx) : _statXML.(@Eid == eid);
         if(xmllist.length() > 0)
         {
            xml = xmllist.(@Args == arg)[0];
            if(Boolean(xml))
            {
               return xml.@Desc;
            }
            return "";
         }
         return "";
      }
      
      public static function getEffectDes(param1:uint, param2:String) : String
      {
         var str:String;
         var xmllist:XMLList;
         var xl:XMLList;
         var xml:XML;
         var eid:uint;
         var arg:String;
         var effectXml:XML = _effectXmlMap.getValue(param1) as XML;
         if(effectXml != null)
         {
            if(effectXml.@Args == param2 && uint(effectXml.@Idx) > 1000)
            {
               return Boolean(effectXml.@Intro) ? effectXml.@Intro : "";
            }
         }
         str = null;
         xmllist = null;
         xl = null;
         xml = null;
         eid = param1;
         arg = param2;
         str = "";
         xmllist = _statXML.(@Eid == eid);
         if(xmllist.length() > 0)
         {
            xl = xmllist.(@Args == arg);
            if(Boolean(xl) && xl.length() > 0)
            {
               xml = xl.(@Idx > 1000)[0];
               if(Boolean(xml))
               {
                  str = xml.@Intro;
               }
            }
         }
         return str;
      }
      
      public static function getStarLevel(param1:uint, param2:String) : int
      {
         var level:int;
         var xmllist:XMLList;
         var xl:XMLList;
         var xml:XML;
         var eid:uint;
         var arg:String;
         var effectXml:XML = _effectXmlMap.getValue(param1) as XML;
         if(effectXml != null)
         {
            if(effectXml.@Args == param2 && uint(effectXml.@Idx) > 1000)
            {
               return Boolean(int(effectXml.@StarLevel)) ? int(effectXml.@StarLevel) : 0;
            }
         }
         level = 0;
         xmllist = null;
         xl = null;
         xml = null;
         eid = param1;
         arg = param2;
         level = 0;
         xmllist = _statXML.(@Eid == eid);
         if(xmllist.length() > 0)
         {
            xl = xmllist.(@Args == arg);
            if(Boolean(xl) && xl.length() > 0)
            {
               xml = xl.(@Idx > 1000)[0];
               if(Boolean(xml))
               {
                  level = int(xml.@StarLevel);
               }
            }
         }
         return level;
      }
      
      public static function getIntros(param1:String) : HashMap
      {
         var arr:HashMap;
         var xmllist:XMLList;
         var level:int;
         var item:XML;
         var desc:String;
         var cacheValue:Object = _descToStarIntroMap.getValue(param1);
         if(cacheValue != null)
         {
            return cacheValue as HashMap;
         }
         arr = null;
         xmllist = null;
         level = 0;
         item = null;
         desc = param1;
         arr = new HashMap();
         xmllist = _statXML.(@Desc == desc);
         level = 0;
         if(xmllist.length() > 0)
         {
            for each(item in xmllist)
            {
               arr.add(int(item.@StarLevel),item.@Intro);
            }
         }
         return arr;
      }
      
      public static function getDes2(eid:uint, arg:String, idx:Number = -1) : String
      {
         var xmllist:XMLList = null;
         var xml:XML = null;
         var effectXml:XML = _effectXmlMap.getValue(eid) as XML;
         if(effectXml != null)
         {
            if(effectXml.@Args == arg && (idx == -1 || uint(effectXml.@Idx) == idx))
            {
               return Boolean(effectXml.@Intro) ? effectXml.@Intro : "";
            }
         }
         xmllist = idx > 0 ? _statXML.(@Eid == eid && @Idx == idx) : _statXML.(@Eid == eid);
         if(xmllist.length() > 0)
         {
            xml = xmllist.(@Args == arg)[0];
            if(Boolean(xml))
            {
               return xml.@Intro;
            }
            return "";
         }
         return "";
      }
   }
}

