package com.robot.core.info.skillEffectInfo
{
   import com.robot.core.config.xml.SkillXMLInfo;
   
   public class Effect_613 extends AbstractEffectInfo
   {
      
      public function Effect_613()
      {
         super();
         _argsNum = 2;
      }
      
      override public function getInfo(param1:Array = null) : String
      {
         return param1[0] + "回合内自身令对手使用的" + SkillXMLInfo.petTypeNameCN(param1[1]) + "系攻击技能无效";
      }
   }
}

