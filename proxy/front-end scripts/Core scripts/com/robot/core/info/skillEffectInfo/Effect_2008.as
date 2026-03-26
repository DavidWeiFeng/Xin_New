package com.robot.core.info.skillEffectInfo
{
   public class Effect_2008 extends AbstractEffectInfo
   {
      
      public function Effect_2008()
      {
         super();
         _argsNum = 3;
      }
      
      override public function getInfo(array:Array = null) : String
      {
         var statusNames:Object = null;
         var getStatusName:* = function(_arg_1:int, _arg_2:Boolean = false):String
         {
            var _local_3:String = statusNames[_arg_1] || "";
            return _arg_2 ? "重新附加" + _local_3 : "附加" + _local_3;
         };
         var baseText:String = "对方处于中毒状态的场合，立刻结算剩余的回合伤害，并";
         var hasTurns:Boolean = array.length > 2 && array[2] != null;
         var effectId:int = int(array[0]);
         var targetStatusId:int = int(array[1]);
         var isReapply:Boolean = effectId == targetStatusId;
         var result:String = baseText + getStatusName(targetStatusId,isReapply);
         statusNames = {
            "0":"麻痹",
            "1":"中毒",
            "2":"烧伤",
            "4":"寄生",
            "5":"冻伤",
            "6":"害怕",
            "7":"疲惫",
            "8":"睡眠",
            "9":"石化",
            "10":"混乱",
            "15":"冰封",
            "16":"流血"
         };
         if(hasTurns)
         {
            result += "状态" + array[2] + "回合";
         }
         else
         {
            result += "状态";
         }
         return result;
      }
   }
}

