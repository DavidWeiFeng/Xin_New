package com.robot.core.config.xml
{
   import org.taomee.ds.*;
   
   public class FortressItemXMLInfo
   {
      
      private static var _dataMap:HashMap;
      
      private static var xmlClass:Class = FortressItemXMLInfo_xmlClass;
      
      setup();
      
      public function FortressItemXMLInfo()
      {
         super();
      }
      
      private static function setup() : void
      {
         var _local_1:XML = null;
         _dataMap = new HashMap();
         var _local_2:XMLList = XML(new xmlClass()).elements("LiveItem");
         for each(_local_1 in _local_2)
         {
            _dataMap.add(uint(_local_1.@ID),_local_1);
         }
      }
      
      public static function getName(_arg_1:uint) : String
      {
         var _local_2:XML = _dataMap.getValue(_arg_1);
         if(Boolean(_local_2))
         {
            return String(_local_2.@Name);
         }
         return "";
      }
      
      public static function getPrice(_arg_1:uint) : uint
      {
         var _local_2:XML = _dataMap.getValue(_arg_1);
         if(Boolean(_local_2))
         {
            return uint(_local_2.@Price);
         }
         return 0;
      }
      
      public static function getDes(_arg_1:uint) : String
      {
         var _local_2:XML = _dataMap.getValue(_arg_1);
         if(Boolean(_local_2))
         {
            return String(_local_2.@Des);
         }
         return "";
      }
      
      public static function getPreBuildingID(_arg_1:uint) : uint
      {
         var _local_2:XML = _dataMap.getValue(_arg_1);
         if(Boolean(_local_2))
         {
            return uint(_local_2.@PreBuildingID);
         }
         return 0;
      }
      
      public static function getFormName(id:uint, form:uint) : String
      {
         var str:String = null;
         var item:XML = _dataMap.getValue(id);
         if(Boolean(item))
         {
            item = item.elements("Form").(uint(@ID) == form)[0];
            if(Boolean(item))
            {
               str = String(item.@Name);
               return str;
            }
         }
         return "";
      }
      
      public static function getNextLevel(id:uint, form:uint) : String
      {
         var str:String = null;
         var item:XML = _dataMap.getValue(id);
         if(Boolean(item))
         {
            item = item.elements("Form").(uint(@ID) == form)[0];
            if(Boolean(item))
            {
               str = String(item.@NeedTeamLv);
               return str;
            }
         }
         return "";
      }
      
      public static function getMaxLevel(_arg_1:uint) : String
      {
         var _local_2:XMLList = null;
         var _local_3:XML = _dataMap.getValue(_arg_1);
         if(Boolean(_local_3))
         {
            _local_2 = _local_3.elements("Form");
            if(Boolean(_local_2))
            {
               if(_local_2.length() == 0)
               {
                  return "";
               }
               _local_3 = _local_2[_local_2.length() - 1];
               return String(_local_3.@ID);
            }
         }
         return "";
      }
      
      public static function getNextLevExp(id:uint, form:uint) : uint
      {
         var str:String = null;
         var item:XML = _dataMap.getValue(id);
         if(Boolean(item))
         {
            item = item.elements("Form").(uint(@ID) == form)[0];
            if(Boolean(item))
            {
               str = String(item.@NeedTeamExp);
               if(str != "")
               {
                  return uint(str);
               }
            }
         }
         return 0;
      }
      
      public static function getMaxHP(id:uint, form:uint) : String
      {
         var str:String = null;
         var item:XML = _dataMap.getValue(id);
         if(Boolean(item))
         {
            item = item.elements("Form").(uint(@ID) == form)[0];
            if(Boolean(item))
            {
               str = String(item.@MaxHP);
               return str;
            }
         }
         return "";
      }
      
      public static function getAtk(id:uint, form:uint) : String
      {
         var str:String = null;
         var item:XML = _dataMap.getValue(id);
         if(Boolean(item))
         {
            item = item.elements("Form").(uint(@ID) == form)[0];
            if(Boolean(item))
            {
               str = String(item.@Atk);
               return str;
            }
         }
         return "";
      }
      
      public static function getDef(id:uint, form:uint) : String
      {
         var str:String = null;
         var item:XML = _dataMap.getValue(id);
         if(Boolean(item))
         {
            item = item.elements("Form").(uint(@ID) == form)[0];
            if(Boolean(item))
            {
               str = String(item.@Def);
               return str;
            }
         }
         return "";
      }
      
      public static function getScience(id:uint, form:uint) : String
      {
         var str:String = null;
         var item:XML = _dataMap.getValue(id);
         if(Boolean(item))
         {
            item = item.elements("Form").(uint(@ID) == form)[0];
            if(Boolean(item))
            {
               str = String(item.@Science);
               return str;
            }
         }
         return "";
      }
      
      public static function getResearch(id:uint, form:uint) : String
      {
         var str:String = null;
         var item:XML = _dataMap.getValue(id);
         if(Boolean(item))
         {
            item = item.elements("Form").(uint(@ID) == form)[0];
            if(Boolean(item))
            {
               str = String(item.@Research);
               return str;
            }
         }
         return "";
      }
      
      public static function getEnergy(id:uint, form:uint) : String
      {
         var str:String = null;
         var item:XML = _dataMap.getValue(id);
         if(Boolean(item))
         {
            item = item.elements("Form").(uint(@ID) == form)[0];
            if(Boolean(item))
            {
               str = String(item.@Energy);
               return str;
            }
         }
         return "";
      }
      
      public static function getNextForm(id:uint, form:uint) : uint
      {
         var item:XML = _dataMap.getValue(id);
         if(Boolean(item))
         {
            item = item.elements("Form").(uint(@ID) == form)[0];
            if(Boolean(item))
            {
               return uint(item.@NextForm);
            }
         }
         return 0;
      }
      
      public static function getNextFormNeedExp(id:uint, form:uint) : uint
      {
         var item:XML = _dataMap.getValue(id);
         if(Boolean(item))
         {
            item = item.elements("Form").(uint(@ID) == form)[0];
            if(Boolean(item))
            {
               return uint(item.@NeedTeamExp);
            }
         }
         return 0;
      }
      
      public static function getResIDs(id:uint, form:uint) : Array
      {
         var arr:Array = null;
         var i:int = 0;
         var item:XML = _dataMap.getValue(id);
         if(Boolean(item))
         {
            arr = [];
            item = item.elements("Form").(uint(@ID) == form)[0];
            if(Boolean(item))
            {
               i = 1;
               while(i <= 4)
               {
                  arr.push(int(item.attribute("ResID" + i.toString())));
                  i += 1;
               }
               return arr;
            }
            return [];
         }
         return [];
      }
      
      public static function getResMaxs(id:uint, form:uint) : Array
      {
         var arr:Array = null;
         var i:int = 0;
         var item:XML = _dataMap.getValue(id);
         if(Boolean(item))
         {
            arr = [];
            item = item.elements("Form").(uint(@ID) == form)[0];
            if(Boolean(item))
            {
               i = 1;
               while(i <= 4)
               {
                  arr.push(int(item.attribute("ResMax" + i.toString())));
                  i += 1;
               }
               return arr;
            }
            return [];
         }
         return [];
      }
      
      public static function getAllResMax(_arg_1:uint, _arg_2:uint) : uint
      {
         var _local_3:uint = 0;
         var _local_4:uint = 0;
         var _local_5:Array = getResMaxs(_arg_1,_arg_2);
         for each(_local_4 in _local_5)
         {
            _local_3 += _local_4;
         }
         return _local_3;
      }
      
      public static function getFunID(_arg_1:uint) : int
      {
         var _local_2:XML = _dataMap.getValue(_arg_1);
         if(!_local_2.hasOwnProperty("@Fun"))
         {
            return 0;
         }
         return int(_local_2.@Fun);
      }
      
      public static function getFunIsCom(_arg_1:uint) : Boolean
      {
         var _local_2:XML = _dataMap.getValue(_arg_1);
         if(!_local_2.hasOwnProperty("@isCom"))
         {
            return false;
         }
         return Boolean(int(_local_2.@isCom));
      }
      
      public static function getShootRadius(id:uint, form:uint) : uint
      {
         var item:XML = _dataMap.getValue(id);
         if(Boolean(item))
         {
            item = item.elements("Form").(uint(@ID) == form)[0];
            if(Boolean(item))
            {
               return uint(item.@ShootRadius);
            }
         }
         return 0;
      }
   }
}

