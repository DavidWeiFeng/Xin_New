package com.robot.app.leiyiTrain
{
   import com.robot.core.info.pet.PetInfo;
   import com.robot.core.manager.PetManager;
   import com.robot.core.npc.NPC;
   import com.robot.core.npc.NpcDialog;
   import com.robot.core.ui.alert.Alarm;
   
   public class LeiyiTrainPanelController
   {
      
      private static var _panel:LeiyiTrainPanel;
      
      public function LeiyiTrainPanelController()
      {
         super();
      }
      
      public static function show() : void
      {
         check(showPanel);
      }
      
      public static function showPanel() : void
      {
         if(_panel != null)
         {
            _panel.destroy();
            _panel = null;
         }
         _panel = new LeiyiTrainPanel();
         _panel.show();
      }
      
      public static function check(_arg_1:Function) : void
      {
         if(PetManager.length == 0)
         {
            Alarm.show("你的背包中没有精灵哦！");
            return;
         }
         var _local_2:PetInfo = PetManager.getPetInfo(PetManager.defaultTime);
         if(Boolean(_local_2))
         {
            if(_local_2.id == 70 || _local_2.id == 2394)
            {
               _arg_1();
            }
            else
            {
               NpcDialog.show(NPC.SEER,["哎呀！快把雷伊设为对战的首选精灵，再来进行雷伊极限修行哦！"],["我现在就把雷伊设为首选精灵！"]);
            }
         }
      }
   }
}

