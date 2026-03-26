package com.robot.core.config.xml
{
   import com.robot.core.config.*;
   import org.taomee.ds.*;
   import org.taomee.utils.*;
   
   public class PetXMLInfo
   {
      
      private static var _dataMap:HashMap;
      
      private static var _xml:XML;
      
      private static var _path:String = "226";
      
      public function PetXMLInfo()
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
            _xml = _arg_1;
            var _local_2:XMLList = _xml.elements("Monster");
            for each(item in _local_2)
            {
               _dataMap.add(item.@ID.toString(),item);
            }
            callBack();
            xmlLoader = null;
         };
         var xmlLoader:XmlLoader = new XmlLoader();
         xmlLoader.loadXML(_path,XmlConfig.getXmlVerByPath(_path),onLoad);
      }
      
      public static function getIdList() : Array
      {
         return _dataMap.getKeys();
      }
      
      public static function flyPetY(param1:uint) : Number
      {
         var _loc2_:XML = _dataMap.getValue(param1);
         if(Boolean(_loc2_) && Boolean(_loc2_.hasOwnProperty("@nameY")))
         {
            return Number(_loc2_.@nameY);
         }
         return 0;
      }
      
      public static function flyPetSpeed(param1:uint) : Number
      {
         var _loc2_:XML = _dataMap.getValue(param1);
         if(Boolean(_loc2_) && Boolean(_loc2_.hasOwnProperty("@speed")))
         {
            return Number(_loc2_.@speed);
         }
         return 0;
      }
      
      public static function petScale(param1:uint) : Number
      {
         var _loc2_:XML = _dataMap.getValue(param1);
         if(Boolean(_loc2_) && Boolean(_loc2_.hasOwnProperty("@scale")))
         {
            return Number(_loc2_.@scale);
         }
         return 1;
      }
      
      public static function getCanLearnSPSkillList(param1:uint) : Array
      {
         var _loc2_:XML = null;
         var _loc3_:XMLList = null;
         var _loc4_:XML = null;
         var _loc5_:Array = [];
         _loc2_ = _dataMap.getValue(param1);
         if(_loc2_ == null)
         {
            return _loc5_;
         }
         _loc3_ = _loc2_.elements("LearnableMoves")[0].elements("SpMove");
         for each(_loc4_ in _loc3_)
         {
            _loc5_.push(uint(_loc4_.@ID));
         }
         return _loc5_;
      }
      
      public static function get dataList() : Array
      {
         return _dataMap.getValues();
      }
      
      public static function getName(_arg_1:uint) : String
      {
         var _local_2:XML = _dataMap.getValue(_arg_1);
         if(Boolean(_local_2))
         {
            return _local_2.@DefName.toString();
         }
         return "";
      }
      
      public static function getPetGenderCN(param1:uint) : String
      {
         if(param1 == 1)
         {
            return "雄性";
         }
         if(param1 == 2)
         {
            return "雌性";
         }
         return "无性别";
      }
      
      public static function getType(_arg_1:uint) : String
      {
         var _local_2:XML = _dataMap.getValue(_arg_1);
         if(Boolean(_local_2))
         {
            return _local_2.@Type.toString();
         }
         return "";
      }
      
      public static function getTypeList(t:uint) : XMLList
      {
         return _xml.(@Type == t);
      }
      
      public static function getClass(_arg_1:uint) : Class
      {
         var _local_2:XML = _dataMap.getValue(_arg_1);
         if(_local_2 == null)
         {
            return null;
         }
         if(!_local_2.hasOwnProperty("@className"))
         {
            return null;
         }
         var _local_3:Class = Utils.getClass(_local_2.@className.toString());
         if(Boolean(_local_3))
         {
            return _local_3;
         }
         return null;
      }
      
      public static function getEvolvFlag(_arg_1:uint) : uint
      {
         var _local_2:XML = _dataMap.getValue(_arg_1);
         return _local_2.@EvolvFlag;
      }
      
      public static function getEvolvingLv(_arg_1:uint) : uint
      {
         var _local_2:XML = _dataMap.getValue(_arg_1);
         return _local_2.@EvolvingLv;
      }
      
      public static function getSkillListForLv(_arg_1:uint, _arg_2:uint) : Array
      {
         var _local_3:XML = null;
         var _local_4:XMLList = null;
         var _local_5:XML = null;
         var _local_6:Array = [];
         _local_3 = _dataMap.getValue(_arg_1);
         if(_local_3 == null)
         {
            return _local_6;
         }
         _local_4 = _local_3.elements("LearnableMoves")[0].elements("Move");
         for each(_local_5 in _local_4)
         {
            if(uint(_local_5.@LearningLv) <= _arg_2)
            {
               _local_6.push(uint(_local_5.@ID));
            }
         }
         return _local_6;
      }
      
      public static function getTypeCN(_arg_1:uint) : String
      {
         var _local_2:uint = uint(getType(_arg_1));
         return SkillXMLInfo.dict["key_" + _local_2]["cn"];
      }
      
      public static function getTypeEN(_arg_1:uint) : String
      {
         var _local_2:uint = uint(getType(_arg_1));
         return SkillXMLInfo.dict["key_" + _local_2]["en"];
      }
      
      public static function fuseMaster(_arg_1:uint) : Boolean
      {
         var _local_2:XML = _dataMap.getValue(_arg_1);
         return Boolean(uint(_local_2.@FuseMaster));
      }
      
      public static function fuseSub(_arg_1:uint) : Boolean
      {
         var _local_2:XML = _dataMap.getValue(_arg_1);
         return Boolean(uint(_local_2.@FuseSub));
      }
      
      public static function getPetClass(_arg_1:uint) : uint
      {
         var _local_2:XML = _dataMap.getValue(_arg_1);
         return _local_2.@PetClass;
      }
      
      public static function isLarge(_arg_1:uint) : Boolean
      {
         var _local_2:XML = _dataMap.getValue(_arg_1);
         if(!_local_2.hasOwnProperty("@IsLarge"))
         {
            return false;
         }
         return Boolean(_local_2.@IsLarge);
      }
   }
}

