package com.robot.app.task.control
{
   import com.robot.app.task.taskUtils.taskDialog.*;
   import com.robot.core.animate.*;
   import com.robot.core.config.*;
   import com.robot.core.event.*;
   import com.robot.core.info.fightInfo.attack.FightOverInfo;
   import com.robot.core.manager.*;
   import com.robot.core.mode.*;
   import flash.display.MovieClip;
   import flash.display.SimpleButton;
   import org.taomee.manager.*;
   
   public class TaskController_81
   {
      
      private static var dh_mc:MovieClip;
      
      private static var hua_btn:SimpleButton;
      
      public static var pet_btn:SimpleButton;
      
      public static var panel1:AppModel;
      
      public static var panel:AppModel;
      
      public static const TASK_ID:uint = 81;
      
      private static var addB:Boolean = false;
      
      public function TaskController_81()
      {
         super();
      }
      
      public static function start() : void
      {
         showPanel();
      }
      
      public static function initMc(_arg_1:MovieClip, _arg_2:SimpleButton, _arg_3:SimpleButton) : void
      {
         dh_mc = _arg_1;
         hua_btn = _arg_2;
         pet_btn = _arg_3;
      }
      
      public static function addLisPetF() : void
      {
         if(!addB)
         {
            EventManager.addEventListener(PetFightEvent.FIGHT_CLOSE,onCloseFight);
            addB = true;
         }
      }
      
      private static function onCloseFight(_arg_1:PetFightEvent) : void
      {
         var _local_2:FightOverInfo = _arg_1.dataObj["data"];
         if(_local_2.winnerID == MainManager.actorInfo.userID)
         {
            speek2();
            EventManager.removeEventListener(PetFightEvent.FIGHT_CLOSE,onCloseFight);
         }
      }
      
      public static function playCartoon0() : void
      {
         AnimateManager.playFullScreenAnimate("resource/bounsMovie/task81donghua.swf",function():void
         {
            NpcTipDialog.show("是谁？是谁？刚才是谁蒙住了我的眼睛？(⊙o⊙)？",function():void
            {
               dh_mc.gotoAndPlay(2);
               dh_mc.addFrameScript(40,endDh0);
            },NpcTipDialog.SEER,0,null,null,false);
         });
      }
      
      private static function endDh0() : void
      {
         dh_mc.addFrameScript(40,null);
         dh_mc.gotoAndStop(40);
         TasksManager.complete(TASK_ID,0,function(_arg_1:Boolean):void
         {
            if(_arg_1)
            {
               showPanel();
               hua_btn.visible = true;
            }
         });
      }
      
      public static function speek0() : void
      {
         NpcTipDialog.show("……&*（&#……#@——￥####@￥@%",function():void
         {
            NpcTipDialog.show("它这说的是什么？它想表达什么呢……我的天！这可把我给难住了……",function():void
            {
               AnimateManager.playFullScreenAnimate("resource/bounsMovie/task81donghua1.swf",speek1,null,"sound");
            },NpcTipDialog.SEER,0,null,null,false);
         },NpcTipDialog.NEWPET,0,null,null,false);
      }
      
      private static function speek1() : void
      {
         NpcTipDialog.show("你这说的是别的精灵在追赶你？他们还欺负你？可恶啊！！我不能袖手旁观！(╰_╯)#",function():void
         {
            TasksManager.complete(TASK_ID,1,function(_arg_1:Boolean):void
            {
               if(_arg_1)
               {
                  showPanel();
                  addLisPetF();
               }
            });
         },NpcTipDialog.SEER,0,null,null,false);
      }
      
      public static function speek2() : void
      {
         NpcTipDialog.show("哼！叫你以后敢以大欺小！好了，小家伙，你不用怕啦，那个家伙以后应该不敢再欺负你了！",function():void
         {
            TasksManager.complete(TASK_ID,2,function(_arg_1:Boolean):void
            {
               if(_arg_1)
               {
                  showPanel();
                  pet_btn.visible = true;
                  dh_mc.gotoAndStop(81);
               }
            });
         },NpcTipDialog.SEER,0,null,null,false);
      }
      
      public static function speek3() : void
      {
         NpcTipDialog.show("…！*##%#…@@@…*…#@@###o(≧v≦)",function():void
         {
            NpcTipDialog.show("它这说的又是什么呀……这可怎么办是好？吖！对了！前面博士不是说有一个什么什么故事？难道和这个事情有关？快用通讯器询问一下博士吧！",function():void
            {
               showPanel1();
            },NpcTipDialog.SEER,0,null,null,false);
         },NpcTipDialog.NEWPET,0,null,null,false);
      }
      
      public static function speek4() : void
      {
         NpcTipDialog.show("怪不得这个家伙让我去打败其他精灵了！原来还有这么一个说法……咦？遇到你，打败了比你厉害的精灵！难道我就是那个宿命的追随者？米隆决定就是你了！我们一定会成为朋友的！",function():void
         {
            TasksManager.complete(TASK_ID,3,function(_arg_1:Boolean):void
            {
               if(_arg_1)
               {
                  dh_mc.gotoAndStop(1);
                  pet_btn.visible = false;
               }
            });
         },NpcTipDialog.SEER,0,null,null,false);
      }
      
      public static function showPanel1() : void
      {
         if(Boolean(panel1))
         {
            panel1.destroy();
            panel1 = null;
         }
         if(panel1 == null)
         {
            panel1 = new AppModel(ClientConfig.getTaskModule("TaskPanel0_81"),"正在打开任务信息");
            panel1.setup();
            panel1.show();
         }
         else
         {
            panel1.show();
         }
      }
      
      public static function showPanel() : void
      {
         if(panel == null)
         {
            panel = new AppModel(ClientConfig.getTaskModule("TaskPanel_81"),"正在打开任务信息");
            panel.setup();
            panel.show();
         }
         else
         {
            panel.show();
         }
      }
   }
}

