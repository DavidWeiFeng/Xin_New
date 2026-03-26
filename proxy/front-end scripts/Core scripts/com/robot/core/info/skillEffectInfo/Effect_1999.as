package com.robot.core.info.skillEffectInfo
{
   import com.robot.core.config.xml.SkillXMLInfo;
   
   public class Effect_1999 extends AbstractEffectInfo
   {
      
      public function Effect_1999()
      {
         super();
         _argsNum = 2;
      }
      
      override public function getInfo(param1:Array = null) : String
      {
         return param1[0] + "回合内自身使用的攻击技能对" + SkillXMLInfo.petTypeNameCN(param1[1]) + "系精灵无效";
      }
   }
}

