package com.robot.core.config
{
   import com.robot.core.info.fightInfo.PetStatusEffectInfo;
   import com.robot.core.info.fightInfo.PetStatusEffectType;
   
   public class PetStatusEffectConfig
   {
      
      private static var xmlClass:Class = PetStatusEffectConfig_xmlClass;
      
      private static var xml:XML = XML(new xmlClass());
      
      private static const ABNORMAL_WEAK:Array = ["25%","50%","100%","250%","500%"];
      
      public function PetStatusEffectConfig()
      {
         super();
      }
      
      public static function getName(param1:uint, param2:uint) : String
      {
         var tl:XMLList = null;
         var il:XMLList = null;
         var type:uint = param1;
         var id:uint = param2;
         tl = xml.BattleEffect.(@Type == type.toString());
         if(Boolean(tl))
         {
            il = tl[0].SubEffect.(@ID == id.toString());
            if(Boolean(il) && Boolean(il[0].hasOwnProperty("@Name")))
            {
               return String(il[0].@Name);
            }
            return "";
         }
         return "";
      }
      
      public static function getEffType(param1:uint) : int
      {
         var tl:XMLList = null;
         var il:XMLList = null;
         var id:uint = param1;
         tl = xml.BattleEffect.(@Type == 0);
         if(Boolean(tl))
         {
            il = tl[0].SubEffect.(@ID == id.toString());
            if(Boolean(il) && Boolean(il[0].hasOwnProperty("@Efftype")))
            {
               return int(il[0].@Efftype);
            }
            return -1;
         }
         return -1;
      }
      
      public static function getDescription(param1:uint, param2:uint) : String
      {
         var tl:XMLList = null;
         var il:XMLList = null;
         var type:uint = param1;
         var id:uint = param2;
         tl = xml.BattleEffect.(@Type == type.toString());
         if(Boolean(tl))
         {
            il = tl[0].SubEffect.(@ID == id.toString());
            if(Boolean(il) && Boolean(il[0].hasOwnProperty("@des")))
            {
               return String(il[0].@des);
            }
            return "";
         }
         return "";
      }
      
      public static function getXml(param1:uint, param2:uint) : XML
      {
         var tl:XMLList = null;
         var il:XMLList = null;
         var type:uint = param1;
         var id:uint = param2;
         tl = xml.BattleEffect.(@Type == type.toString());
         if(Boolean(tl))
         {
            il = tl[0].SubEffect.(@ID == id.toString());
            if(Boolean(il))
            {
               return il[0];
            }
            return null;
         }
         return null;
      }
      
      public static function isShow(param1:uint, param2:uint) : Boolean
      {
         var tl:XMLList = null;
         var il:XMLList = null;
         var type:uint = param1;
         var id:uint = param2;
         tl = xml.BattleEffect.(@Type == type.toString());
         if(Boolean(tl))
         {
            il = tl[0].SubEffect.(@ID == id.toString());
            if(Boolean(il) && Boolean(il[0].hasOwnProperty("@isShow")))
            {
               return uint(il[0].@isShow) == 1;
            }
            return false;
         }
         return false;
      }
      
      public static function tip(param1:PetStatusEffectInfo) : String
      {
         var _loc2_:* = null;
         switch(param1.type)
         {
            case PetStatusEffectType.ABNORMAL:
               if(param1.id == 15)
               {
                  _loc2_ = param1.name + " 持续" + param1.parm + "回合不能行动，冰封结束后陷入冻伤状态同时速度-1";
               }
               else if(param1.id == 11)
               {
                  _loc2_ = param1.name + ":" + ABNORMAL_WEAK[param1.parm - 1];
               }
               else if(param1.id == 17)
               {
                  _loc2_ = "免疫能力下降；免疫异常状态；PP无限；所有技能必中";
               }
               else if(param1.id == 18)
               {
                  _loc2_ = "免疫异常状态；PP无限";
               }
               else if(param1.id == 20)
               {
                  _loc2_ = "对手的攻击技能有50%概率丢失（必中也丢失）";
               }
               else
               {
                  _loc2_ = param1.name + " 持续" + param1.parm + "回合";
               }
               break;
            case PetStatusEffectType.TRAIT:
               if(param1.parm > 6)
               {
                  _loc2_ = param1.name + "等级 +" + (param1.parm - 6);
               }
               else
               {
                  _loc2_ = param1.name + "等级 -" + (6 - param1.parm);
               }
               break;
            default:
               _loc2_ = param1.name + " 持续" + param1.parm + "回合";
         }
         return _loc2_;
      }
   }
}

