package com.robot.core.config.xml
{
   import com.robot.core.config.*;
   import com.robot.core.info.item.*;
   import com.robot.core.manager.*;
   import org.taomee.ds.*;
   import org.taomee.utils.*;
   
   public class ItemXMLInfo
   {
      
      private static var xmllist:XMLList;
      
      private static var _path:String = "221";
      
      public static var _dataMap:HashMap = new HashMap();
      
      public function ItemXMLInfo()
      {
         super();
      }
      
      public static function parseInfo(callBack:Function) : void
      {
         var item:XML = null;
         item = null;
         var onLoad:Function = function(_xml:XML):void
         {
            xmllist = _xml.descendants("Item");
            for each(item in xmllist)
            {
               _dataMap.add(item.@ID.toString(),item);
            }
            ClothInfo.parseInfo(_xml.Cat.(@ID == 1)[0]);
            DoodleXMLInfo.setup(_xml.Cat.(@ID == 2)[0]);
            callBack();
            xmlLoader = null;
         };
         var xmlLoader:XmlLoader = new XmlLoader();
         xmlLoader.loadXML(_path,XmlConfig.getXmlVerByPath(_path),onLoad);
      }
      
      public static function getName(id:uint) : String
      {
         var xml:XML = null;
         xml = xmllist.(@ID == id)[0];
         return xml.@Name;
      }
      
      public static function getLimitPetClass(param1:uint) : uint
      {
         return 0;
      }
      
      public static function getPrice(id:uint) : uint
      {
         var _local_2:XML = _dataMap.getValue(id);
         return _local_2.@Price;
      }
      
      public static function getSellPrice(id:uint) : uint
      {
         var _local_2:XML = _dataMap.getValue(id);
         return _local_2.@SellPrice;
      }
      
      public static function getRule(id:uint) : String
      {
         var _local_2:XML = _dataMap.getValue(id);
         if(Boolean(_local_2.hasOwnProperty("@Rule")))
         {
            return _local_2.@Rule;
         }
         return "";
      }
      
      public static function getType(id:uint) : String
      {
         var xml:XML = _dataMap.getValue(id);
         return xml.@type;
      }
      
      public static function getSwfURL(id:uint, level:uint = 1) : String
      {
         var xml:XML = _dataMap.getValue(id);
         if(level == 0 || level == 1)
         {
            return XML(xml.parent()).@url + id.toString() + ".swf";
         }
         return XML(xml.parent()).@url + id.toString() + "_" + level + ".swf";
      }
      
      public static function getPrevURL(_arg_1:uint, _arg_2:uint = 1) : String
      {
         return getSwfURL(_arg_1,_arg_2).replace(/swf\//,"prev/");
      }
      
      public static function getIconURL(_arg_1:uint, _arg_2:uint = 1) : String
      {
         return getSwfURL(_arg_1 >= 490001 && _arg_1 < 500000 ? 400507 : (_arg_1 == 400064 || _arg_1 == 400065 ? 3 : _arg_1),_arg_2).replace(/swf\//,"icon/");
      }
      
      public static function getLifeTime(id:uint) : uint
      {
         var xml:XML = _dataMap.getValue(id);
         return xml.@LifeTime;
      }
      
      public static function getHP(param1:uint) : uint
      {
         var _local_2:XML = _dataMap.getValue(param1);
         return _local_2.@HP;
      }
      
      public static function getPP(param1:uint) : uint
      {
         var _local_2:XML = _dataMap.getValue(param1);
         return _local_2.@PP;
      }
      
      public static function getSpeed(_arg_1:Array) : Number
      {
         var _local_2:uint = 0;
         var xml:XML = null;
         var _local_3:Number = NaN;
         for each(_local_2 in _arg_1)
         {
            xml = _dataMap.getValue(_local_2);
            if(String(xml.@type) == "foot")
            {
               if(Boolean(xml.hasOwnProperty("@speed")))
               {
                  return MainManager.DfSpeed;
               }
               return xml.@speed;
            }
         }
         return MainManager.DfSpeed;
      }
      
      public static function getFunID(id:uint) : int
      {
         var xml:XML = _dataMap.getValue(id);
         if(!xml.hasOwnProperty("@Fun"))
         {
            return 0;
         }
         return int(xml.@Fun);
      }
      
      public static function getFunIsCom(id:uint) : Boolean
      {
         var xml:XML = _dataMap.getValue(id);
         if(!xml.hasOwnProperty("@isCom"))
         {
            return false;
         }
         return Boolean(int(xml.@isCom));
      }
      
      public static function getDisabledDir(id:uint) : Boolean
      {
         var xml:XML = _dataMap.getValue(id);
         if(!xml.hasOwnProperty("@disabledDir"))
         {
            return false;
         }
         return Boolean(int(xml.@disabledDir));
      }
      
      public static function getDisabledStatus(id:uint) : Boolean
      {
         var xml:XML = _dataMap.getValue(id);
         if(!xml.hasOwnProperty("@disabledStatus"))
         {
            return false;
         }
         return Boolean(int(xml.@disabledStatus));
      }
      
      public static function getCatID(id:uint) : uint
      {
         var xml:XML = _dataMap.getValue(id);
         return xml.parent().@ID;
      }
      
      public static function getPlayID(id:uint) : uint
      {
         var xml:XML = _dataMap.getValue(id);
         return uint(xml.@Play);
      }
      
      public static function getPower(id:uint) : uint
      {
         var xml:XML = _dataMap.getValue(id);
         return uint(xml.@AddPower);
      }
      
      public static function getIQ(id:uint) : uint
      {
         var xml:XML = _dataMap.getValue(id);
         return uint(xml.@AddIQ);
      }
      
      public static function getAiLevel(id:uint) : uint
      {
         var xml:XML = _dataMap.getValue(id);
         return uint(xml.@UseAI);
      }
      
      public static function getVipOnly(id:uint) : Boolean
      {
         var xml:XML = _dataMap.getValue(id);
         return Boolean(uint(xml.@VipOnly));
      }
      
      public static function getItemVipName(id:uint) : String
      {
         var xml:XML = _dataMap.getValue(id);
         if(Boolean(xml.hasOwnProperty("@VipName")))
         {
            return String(xml.@VipName);
         }
         return "";
      }
      
      public static function getIsConsume(id:uint) : uint
      {
         var xml:XML = _dataMap.getValue(id);
         return uint(xml.@IsConsume);
      }
      
      public static function getIsSuper(id:uint) : Boolean
      {
         var xml:XML = _dataMap.getValue(id);
         return Boolean(uint(xml.@VipOnly));
      }
      
      public static function getUseEnergy(id:uint) : uint
      {
         var xml:XML = _dataMap.getValue(id);
         return xml.@UseEnergy;
      }
      
      public static function getIsFloor(id:uint) : Boolean
      {
         var xml:XML = _dataMap.getValue(id);
         return Boolean(uint(xml.@floor));
      }
      
      public static function getSound(id:uint) : String
      {
         var xml:XML = _dataMap.getValue(id);
         if(Boolean(xml))
         {
            if(Boolean(xml.hasOwnProperty("@sound")))
            {
               return String(xml.@sound);
            }
         }
         return "";
      }
      
      public static function getShotDis(id:uint) : uint
      {
         var xml:XML = null;
         var dis:uint = 0;
         xml = xmllist.(@ID == id)[0];
         if(Boolean(xml))
         {
            if(uint(xml.@PkFireRange) == 0)
            {
               dis = 100;
            }
            else
            {
               dis = uint(xml.@PkFireRange);
            }
         }
         else
         {
            dis = 100;
         }
         return dis;
      }
      
      public static function getIsShowInPetBag(id:uint) : Boolean
      {
         var xml:XML = _dataMap.getValue(id);
         if(Boolean(xml))
         {
            if(Boolean(xml.hasOwnProperty("@bShowPetBag")))
            {
               return Boolean(uint(xml.@bShowPetBag));
            }
         }
         return true;
      }
   }
}

