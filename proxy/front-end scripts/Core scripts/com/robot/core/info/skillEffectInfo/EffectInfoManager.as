package com.robot.core.info.skillEffectInfo
{
   import flash.utils.getDefinitionByName;
   import org.taomee.ds.HashMap;
   
   public class EffectInfoManager
   {
      
      private static var hashMap:HashMap = new HashMap();
      
      public function EffectInfoManager()
      {
         super();
      }
      
      public static function getEffectParamType(param1:int) : Array
      {
         return [0,0];
      }
      
      public static function getArgsNum(_arg_1:uint) : uint
      {
         return getEffect(_arg_1).argsNum;
      }
      
      public static function getInfo(_arg_1:uint, _arg_2:Array) : String
      {
         return getEffect(_arg_1).getInfo(_arg_2);
      }
      
      private static function getEffect(id:uint) : AbstractEffectInfo
      {
         var info:AbstractEffectInfo = null;
         var cls:* = undefined;
         if(hashMap.getValue(id))
         {
            info = hashMap.getValue(id);
         }
         else
         {
            try
            {
               cls = getDefinitionByName("com.robot.core.info.skillEffectInfo.Effect_" + id);
               info = new cls() as AbstractEffectInfo;
            }
            catch(e:Error)
            {
            }
            hashMap.add(id,info);
         }
         return info;
      }
   }
}

