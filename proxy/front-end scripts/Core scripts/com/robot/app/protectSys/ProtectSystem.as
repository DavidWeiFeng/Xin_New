package com.robot.app.protectSys
{
   import com.robot.app.task.taskUtils.taskDialog.*;
   import com.robot.core.*;
   import com.robot.core.info.*;
   import com.robot.core.manager.*;
   import com.robot.core.net.*;
   import com.robot.core.ui.alert.*;
   import flash.display.MovieClip;
   import flash.events.*;
   import flash.utils.*;
   import org.taomee.events.SocketEvent;
   import org.taomee.manager.*;
   
   public class ProtectSystem
   {
      
      private static var mc:MovieClip;
      
      private static var timer:Timer;
      
      private static var timer2:Timer;
      
      private static var leftTime:int;
      
      private static var total:uint;
      
      private static var timer_45:Timer;
      
      private static var bgMC:MovieClip;
      
      private static var isHoliday:Boolean = false;
      
      public static var canShow:Boolean = true;
      
      private static var remainingTime:uint = 3600;
      
      public function ProtectSystem()
      {
         super();
      }
      
      private static function setup() : void
      {
         SocketConnection.addCmdListener(CommandID.SYNC_TIME,onSyncTime);
         total = MainManager.actorInfo.timeLimit;
         leftTime = total - MainManager.actorInfo.timeToday;
         checkTime();
         SocketConnection.addCmdListener(CommandID.SYSTEM_TIME,onSysTime);
         SocketConnection.send(CommandID.SYSTEM_TIME);
         SocketConnection.addCmdListener(CommandID.XIN_GET_QUADRUPLE_EXE_TIME,function(e:SocketEvent):void
         {
            var _result:uint;
            SocketConnection.removeCmdListener(CommandID.XIN_GET_QUADRUPLE_EXE_TIME,arguments.callee);
            _result = uint((e.data as IDataInput).readUnsignedInt());
            if(_result == 0)
            {
               NpcTipDialog.show("\r<p align=\'center\'>检测到本日还未开启4倍经验与2倍学习力\r可随时点击右下角电池主动开启</p>",null,NpcTipDialog.NONO);
               ToolTipManager.add(mc,"当日还未开启4倍经验与2倍学习力可点击开启");
               mc.buttonMode = mc.mouseEnabled = true;
               mc.addEventListener(MouseEvent.CLICK,function(e:MouseEvent):void
               {
                  Alert.show("本日还未开启4倍经验与2倍学习力,\r开启之后中途不可取消。\r确认要开启4倍经验与2倍学习力时间吗？",function():void
                  {
                     mc.removeEventListener(MouseEvent.CLICK,arguments.callee);
                     mc.buttonMode = mc.mouseEnabled = false;
                     SocketConnection.send(CommandID.XIN_SET_QUADRUPLE_EXE_TIME,1,1);
                     startXinExeQuadrupleTime();
                  });
               });
            }
            else if(_result > 0 && _result < 3600)
            {
               remainingTime -= _result;
               ToolTipManager.add(mc,"当日4倍经验与2倍学习力剩余时间：" + int(remainingTime / 60) + "分钟");
               startXinExeQuadrupleTime();
            }
            else
            {
               ToolTipManager.add(mc,"当日4倍经验与2倍学习力时间已耗尽");
            }
         });
         if(SocketConnection.mainSocket.userID != 0)
         {
         }
      }
      
      private static function startXinExeQuadrupleTime() : void
      {
         var count:uint = 0;
         ToolTipManager.remove(mc);
         ToolTipManager.add(mc,"当日4倍经验与2倍学习力剩余时间：" + int(remainingTime / 60) + "分钟");
         count = setInterval(function():void
         {
            if(remainingTime != 0)
            {
               remainingTime -= 1;
            }
            if(remainingTime % 60 == 0 && remainingTime != 0)
            {
               ToolTipManager.remove(mc);
               ToolTipManager.add(mc,"当日4倍经验与2倍学习力剩余时间：" + int(remainingTime / 60) + "分钟");
            }
            else if(remainingTime == 0)
            {
               ToolTipManager.remove(mc);
               ToolTipManager.add(mc,"当日4倍经验与2倍学习力已耗尽");
               Alarm.show("当日4倍经验与2倍学习力时间已结束。");
               clearInterval(count);
            }
         },1000);
      }
      
      private static function onSyncTime(_arg_1:SocketEvent) : void
      {
         var _local_2:ByteArray = _arg_1.data as ByteArray;
         var _local_3:uint = _local_2.readUnsignedInt();
         leftTime = total - _local_3;
         checkTime();
      }
      
      public static function start(_arg_1:MovieClip) : void
      {
         mc = _arg_1;
         mc["bgMC"].gotoAndStop(1);
         setup();
      }
      
      private static function checkTime() : void
      {
         if(leftTime < 0)
         {
            leftTime = 0;
         }
         if(total - leftTime < 2 * 60 * 60)
         {
            mc["bgMC"].gotoAndStop(1);
         }
         else
         {
            mc["bgMC"].gotoAndStop(2);
         }
         if(!timer)
         {
            timer = new Timer(60 * 1000);
            timer.addEventListener(TimerEvent.TIMER,timerHandler);
         }
         if(leftTime > 60)
         {
            timer.start();
         }
         else
         {
            timer.stop();
            showSecond();
         }
         var _local_1:String = getHours();
         var _local_2:String = getMin();
         mc["timeTxt"].text = _local_1 + ":" + _local_2;
         resetBar();
         if(!timer_45)
         {
            timer_45 = new Timer(45 * 60 * 1000);
            timer_45.addEventListener(TimerEvent.TIMER,timerHandler45);
         }
         if(leftTime > 0)
         {
            timer_45.start();
         }
      }
      
      private static function timerHandler(_arg_1:TimerEvent) : void
      {
         leftTime -= 60;
         if(leftTime <= 60)
         {
            showSecond();
            timer.stop();
            timer.removeEventListener(TimerEvent.TIMER,timerHandler);
            return;
         }
         resetBar();
         var _local_2:String = getHours();
         var _local_3:String = getMin();
         mc["timeTxt"].text = _local_2 + ":" + _local_3;
      }
      
      private static function resetBar() : void
      {
         var _local_2:uint = 0;
         var _local_1:uint = uint(Math.ceil(4 * (leftTime / total)));
         while(_local_2 < 4)
         {
            mc["bar_" + _local_2].visible = false;
            _local_2++;
         }
         _local_2 = 0;
         while(_local_2 < _local_1)
         {
            mc["bar_" + _local_2].visible = true;
            _local_2++;
         }
      }
      
      private static function showSecond() : void
      {
         if(!timer2)
         {
            timer2 = new Timer(1000);
            timer2.addEventListener(TimerEvent.TIMER,secondTimerHandler);
            timer2.start();
         }
      }
      
      private static function secondTimerHandler(_arg_1:TimerEvent) : void
      {
         --leftTime;
         var _local_2:String = leftTime.toString();
         if(_local_2.length < 2)
         {
            _local_2 = "0" + _local_2;
         }
         if(leftTime < 0)
         {
            mc["timeTxt"].text = "00:00";
         }
         else
         {
            mc["timeTxt"].text = "00:" + _local_2;
         }
         if(leftTime <= 0)
         {
            mc["bgMC"].gotoAndStop(2);
            mc["timeTxt"].text = "00:00";
            Alarm.show("精灵包电量耗尽，所有精灵进入休眠状态。明天电量就可以恢复，你就可以重新训练精灵了");
            timer2.stop();
            timer2.removeEventListener(TimerEvent.TIMER,secondTimerHandler);
            SocketConnection.removeCmdListener(CommandID.SYNC_TIME,onSyncTime);
         }
      }
      
      private static function getHours() : String
      {
         var _local_1:String = Math.floor(leftTime / 60 / 60).toString();
         if(_local_1.length < 2)
         {
            _local_1 = "0" + _local_1;
         }
         return _local_1;
      }
      
      private static function getMin() : String
      {
         var _local_1:uint = uint(getHours()) * 60 * 60;
         var _local_2:uint = uint(leftTime - _local_1);
         var _local_3:uint = uint(Math.ceil(_local_2 / 60));
         if(_local_3 == 60)
         {
            _local_3 = 59;
         }
         var _local_4:String = _local_3.toString();
         if(_local_4.length < 2)
         {
            _local_4 = "0" + _local_4;
         }
         return _local_4;
      }
      
      private static function onSysTime(_arg_1:SocketEvent) : void
      {
         var _local_2:Date = (_arg_1.data as SystemTimeInfo).date;
         isHoliday = _local_2.getDay() > 4 || _local_2.getDay() == 0;
         if(!isHoliday)
         {
            mc["bgMC"].gotoAndStop(2);
         }
         else if(total - leftTime < 2 * 60 * 60)
         {
            mc["bgMC"].gotoAndStop(1);
         }
         else
         {
            mc["bgMC"].gotoAndStop(2);
         }
      }
      
      private static function timerHandler45(_arg_1:TimerEvent) : void
      {
         if(canShow)
         {
            MaskScreen.show();
         }
      }
   }
}

import com.robot.core.manager.*;
import flash.display.MovieClip;
import flash.events.*;
import flash.utils.*;
import org.taomee.utils.*;

class MaskScreen
{
   
   private static var mc:MovieClip;
   
   private static var timer:Timer;
   
   public function MaskScreen()
   {
      super();
   }
   
   public static function show() : void
   {
      if(!mc)
      {
         mc = CoreAssetsManager.getMovieClip("lib_fullScreen_mc");
         timer = new Timer(1000,3);
         timer.addEventListener(TimerEvent.TIMER,onTimer);
         timer.addEventListener(TimerEvent.TIMER_COMPLETE,onTimerComp);
      }
      mc["txt"].text = "3";
      LevelManager.topLevel.addChild(mc);
      timer.reset();
      timer.start();
   }
   
   private static function onTimer(_arg_1:TimerEvent) : void
   {
      mc["txt"].text = (3 - timer.currentCount).toString();
   }
   
   private static function onTimerComp(_arg_1:TimerEvent) : void
   {
      DisplayUtil.removeForParent(mc);
   }
}
