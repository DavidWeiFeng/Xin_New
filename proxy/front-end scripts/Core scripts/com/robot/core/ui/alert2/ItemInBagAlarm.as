package com.robot.core.ui.alert2
{
   import com.robot.core.manager.alert.AlertInfo;
   
   public class ItemInBagAlarm extends BaseAlert
   {
      
      public function ItemInBagAlarm(_arg_1:AlertInfo)
      {
         super(_arg_1,"TaskItemAlarmMC");
         _iconOfftX = -110;
         _iconOfftY = 5;
      }
   }
}

