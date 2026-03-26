package com.robot.core.info.skillEffectInfo
{
   import com.robot.core.config.xml.*;
   
   public class Effect_65 extends AbstractEffectInfo
   {
      
      public function Effect_65()
      {
         super();
         _argsNum = 3;
      }
      
      override public function getInfo(_arg_1:Array = null) : String
      {
         if(Boolean(_arg_1[2] % 1))
         {
            return _arg_1[0] + "回合内，自身" + SkillXMLInfo.getTypeCNBytTypeID(uint(_arg_1[1])) + "系技能的[威力]增加" + (_arg_1[2] - 1) * 100 + "%";
         }
         return _arg_1[0] + "回合内，自身" + SkillXMLInfo.getTypeCNBytTypeID(uint(_arg_1[1])) + "系技能的[威力]增加" + (_arg_1[2] - 1) + "00%";
      }
   }
}

