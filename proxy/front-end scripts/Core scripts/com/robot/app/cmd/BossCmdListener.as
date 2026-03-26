package com.robot.app.cmd
{
   import com.robot.app.automaticFight.*;
   import com.robot.core.*;
   import com.robot.core.config.xml.*;
   import com.robot.core.event.*;
   import com.robot.core.info.task.*;
   import com.robot.core.manager.*;
   import com.robot.core.manager.bean.BaseBeanController;
   import com.robot.core.net.*;
   import com.robot.core.ui.alert.*;
   import com.robot.core.utils.TextFormatUtil;
   import org.taomee.events.SocketEvent;
   
   public class BossCmdListener extends BaseBeanController
   {
      
      public function BossCmdListener()
      {
         super();
      }
      
      override public function start() : void
      {
         SocketConnection.addCmdListener(CommandID.GET_BOSS_MONSTER,this.onGetBossMonster);
         finish();
      }
      
      private function showAwards(_arg_1:BossMonsterInfo) : void
      {
         var _local_2:Object = null;
         var _local_3:uint = 0;
         var _local_4:uint = 0;
         var _local_5:String = null;
         var _local_6:String = null;
         for each(_local_2 in _arg_1.monBallList)
         {
            _local_3 = uint(_local_2["itemCnt"]);
            _local_4 = uint(_local_2["itemID"]);
            if(_local_4 == 100096 || _local_4 == 100097 || _local_4 == 100098 || _local_4 == 100099)
            {
               LevelManager.tipLevel.addChild(Alarm.show("<font color=\'#FF0000\'>闪光勇士</font>套装已经放入了你的储存箱！"));
               break;
            }
            if(_local_4 == 100333)
            {
               LevelManager.tipLevel.addChild(Alarm.show(" 你的实力得到了肯定，这<font color=\'#FF0000\'>试炼勋章</font>送给你，作为你实力的证明。"));
               break;
            }
            _local_5 = ItemXMLInfo.getName(_local_4);
            if(_local_4 == 1)
            {
               MainManager.actorInfo.coins += _local_3;
            }
            if(_local_4 < 10)
            {
               if(_arg_1.bonusID == 5065 || _arg_1.bonusID == 5066)
               {
                  if(_local_3 == 100)
                  {
                     _local_6 = "看来这样的难度还难不倒你，后面的精灵会更加厉害，这<font color=\'#FF0000\'>" + _local_3 + "</font>个" + _local_5 + "是你的奖励。";
                  }
                  else if(_local_3 == 200)
                  {
                     _local_6 = "你确实具备了很强大的实力，给你<font color=\'#FF0000\'>" + _local_3 + "</font>个" + _local_5 + "做为奖励。";
                  }
                  else
                  {
                     _local_6 = "你成功挑战了30关，奖励你<font color=\'#FF0000\'>" + _local_3 + "</font>个" + _local_5 + "。";
                  }
               }
               else
               {
                  _local_6 = "恭喜你得到了<font color=\'#FF0000\'>" + _local_3 + "</font>个" + _local_5;
               }
               ItemInBagAlert.show(_local_4,_local_6);
            }
            else
            {
               _local_6 = _local_3 + "个<font color=\'#FF0000\'>" + _local_5 + "</font>已经放入了你的储存箱！";
               ItemInBagAlert.show(_local_4,_local_6);
            }
         }
      }
      
      private function onGetBossMonster(e:SocketEvent) : void
      {
         var tipMsg:String;
         var info:BossMonsterInfo = null;
         info = null;
         if(AutomaticFightManager.isStart)
         {
            return;
         }
         info = e.data as BossMonsterInfo;
         if(info.bonusID != 0)
         {
            TasksManager.setTaskStatus(info.bonusID,TasksManager.COMPLETE);
         }
         tipMsg = "";
         if(info.exp != 0)
         {
            tipMsg = "祝贺你得到了 " + TextFormatUtil.getRedTxt(info.exp.toString()) + " 点积累经验!";
         }
         if(info.ev != 0)
         {
            tipMsg += (tipMsg != "" ? "\n" : "") + "祝贺你得到了 " + TextFormatUtil.getRedTxt(info.ev.toString()) + " 点积累学习力!";
            MainManager.actorInfo.evpool += info.ev;
         }
         if(tipMsg != "")
         {
            SimpleAlarm.show(tipMsg);
         }
         this.showAwards(info);
         if(info.petID == 0)
         {
            return;
         }
         if(PetManager.length >= 6)
         {
            PetManager.addStorage(info.petID,info.captureTm);
            PetInStorageAlert.show(info.petID,"恭喜你获得了<font color=\'#00CC00\'>" + PetXMLInfo.getName(info.petID) + "</font>，你可以在基地仓库里找到",LevelManager.iconLevel);
            return;
         }
         PetManager.addEventListener(PetEvent.ADDED,function(_arg_1:PetEvent):void
         {
            PetManager.removeEventListener(PetEvent.ADDED,arguments.callee);
            PetInBagAlert.show(info.petID,"恭喜你获得了<font color=\'#00CC00\'>" + PetXMLInfo.getName(info.petID) + "</font>，你可以点击右下方的精灵按钮来查看",LevelManager.iconLevel);
         });
         PetManager.setIn(info.captureTm,1);
      }
   }
}

