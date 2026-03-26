package com.robot.app.mapProcess.active
{
   import com.robot.core.*;
   import com.robot.core.config.xml.*;
   import com.robot.core.manager.*;
   import com.robot.core.manager.map.*;
   import com.robot.core.mode.BasePeoleModel;
   import com.robot.core.net.*;
   import com.robot.core.ui.alert.*;
   import com.robot.core.utils.*;
   import flash.display.MovieClip;
   import flash.utils.*;
   import gs.*;
   import org.taomee.ds.*;
   import org.taomee.events.SocketEvent;
   import org.taomee.utils.*;
   
   public class PKMapActive
   {
      
      private const NONE:uint = 0;
      
      private const ATTACK:uint = 1;
      
      private const STONE:uint = 2;
      
      private var estradeMC:MovieClip;
      
      private var flag:uint;
      
      private var attackMC:MovieClip;
      
      private var stoneMC:MovieClip;
      
      private var timerMap:HashMap;
      
      public function PKMapActive()
      {
         super();
         SocketConnection.addCmdListener(CommandID.TEAM_PK_ACTIVE,this.onPKActive);
         SocketConnection.addCmdListener(CommandID.TEAM_PK_ACTIVE_NOTE_GET_ITEM,this.onNoteGetItem);
         this.estradeMC = MapManager.currentMap.depthLevel["estradeMC"];
         this.estradeMC.mouseEnabled = this.estradeMC.mouseChildren = false;
         this.attackMC = MapLibManager.getMovieClip("attack_mc");
         this.stoneMC = MapLibManager.getMovieClip("stone_mc");
         this.stoneMC.y = -40;
         this.attackMC.y = -40;
         this.stoneMC.mouseChildren = this.stoneMC.mouseEnabled = false;
         this.attackMC.mouseChildren = this.attackMC.mouseEnabled = false;
         MapManager.currentMap.controlLevel["clickMC"].mouseEnabled = false;
         this.timerMap = new HashMap();
      }
      
      public function clickHandler() : void
      {
         if(this.flag == this.ATTACK)
         {
            SocketConnection.send(CommandID.TEAM_PK_ACTIVE_GET_ATTACK);
         }
         else
         {
            SocketConnection.send(CommandID.TEAM_PK_ACTIVE_GET_STONE);
         }
      }
      
      private function onPKActive(_arg_1:SocketEvent) : void
      {
         var _local_2:ByteArray = _arg_1.data as ByteArray;
         this.flag = _local_2.readUnsignedInt();
         this.update();
      }
      
      private function update() : void
      {
         if(this.flag != this.NONE)
         {
            this.estradeMC["lightMC"].gotoAndPlay(2);
            MapManager.currentMap.controlLevel["clickMC"].mouseEnabled = true;
         }
         else
         {
            MapManager.currentMap.controlLevel["clickMC"].mouseEnabled = false;
         }
         DisplayUtil.removeForParent(this.attackMC,false);
         DisplayUtil.removeForParent(this.stoneMC,false);
         if(this.flag == this.ATTACK)
         {
            this.estradeMC.addChild(this.attackMC);
            this.attackMC.gotoAndPlay(2);
         }
         else if(this.flag == this.STONE)
         {
            this.estradeMC.addChild(this.stoneMC);
            this.stoneMC.gotoAndPlay(2);
         }
      }
      
      private function onNoteGetItem(_arg_1:SocketEvent) : void
      {
         var _local_2:BasePeoleModel = null;
         var _local_3:TimerExt = null;
         var _local_4:String = null;
         var _local_5:ByteArray = _arg_1.data as ByteArray;
         var _local_6:uint = _local_5.readUnsignedInt();
         var _local_7:uint = _local_5.readUnsignedInt();
         var _local_8:uint = _local_5.readUnsignedInt();
         if(_local_7 != this.NONE)
         {
            MapManager.currentMap.controlLevel["clickMC"].mouseEnabled = false;
         }
         DisplayUtil.removeForParent(this.attackMC,false);
         DisplayUtil.removeForParent(this.stoneMC,false);
         if(_local_7 == this.ATTACK)
         {
            _local_2 = UserManager.getUserModel(_local_6);
            if(Boolean(_local_2))
            {
               TweenLite.to(_local_2.skeleton.getSkeletonMC(),2,{
                  "scaleX":1.5,
                  "scaleY":1.5
               });
               if(!this.timerMap.containsKey(_local_2))
               {
                  _local_3 = new TimerExt(_local_2);
                  this.timerMap.add(_local_2,_local_3);
               }
               else
               {
                  _local_3 = this.timerMap.getValue(_local_2);
               }
               _local_3.start(_local_8);
            }
         }
         else if(_local_7 == this.STONE && _local_6 == MainManager.actorID)
         {
            _local_4 = ItemXMLInfo.getName(400035);
            ItemInBagAlert.show(400035,TextFormatUtil.getRedTxt(_local_4) + "已经放入了你的储存箱");
         }
      }
      
      public function destroy() : void
      {
         var _local_1:TimerExt = null;
         for each(_local_1 in this.timerMap.getValues())
         {
            _local_1.destroy();
         }
         this.timerMap.clear();
         this.timerMap = null;
         SocketConnection.removeCmdListener(CommandID.TEAM_PK_ACTIVE,this.onPKActive);
         SocketConnection.removeCmdListener(CommandID.TEAM_PK_ACTIVE_NOTE_GET_ITEM,this.onNoteGetItem);
      }
   }
}

import com.robot.core.manager.CoreAssetsManager;
import com.robot.core.mode.BasePeoleModel;
import flash.display.MovieClip;
import flash.events.TimerEvent;
import flash.utils.Timer;
import gs.TweenLite;
import org.taomee.utils.DisplayUtil;

class TimerExt
{
   
   private var p:BasePeoleModel;
   
   private var timer:Timer;
   
   private var flashMC:MovieClip;
   
   public function TimerExt(_arg_1:BasePeoleModel)
   {
      super();
      this.p = _arg_1;
      this.flashMC = CoreAssetsManager.getMovieClip("pk_flash_mc");
   }
   
   public function start(_arg_1:uint) : void
   {
      if(Boolean(this.p))
      {
         this.p.addChild(this.flashMC);
      }
      if(Boolean(this.timer))
      {
         this.timer.removeEventListener(TimerEvent.TIMER,this.onTimer);
      }
      this.timer = new Timer(_arg_1 * 1000,1);
      this.timer.addEventListener(TimerEvent.TIMER,this.onTimer);
      this.timer.start();
   }
   
   public function destroy() : void
   {
      if(Boolean(this.p))
      {
         try
         {
            TweenLite.to(this.p.skeleton.getSkeletonMC(),2,{
               "scaleX":1,
               "scaleY":1
            });
         }
         catch(e:Error)
         {
         }
      }
      if(Boolean(this.timer))
      {
         this.timer.stop();
         this.timer.removeEventListener(TimerEvent.TIMER,this.onTimer);
         this.timer = null;
      }
      DisplayUtil.removeForParent(this.flashMC,false);
   }
   
   private function onTimer(_arg_1:TimerEvent) : void
   {
      if(Boolean(this.p))
      {
         try
         {
            TweenLite.to(this.p.skeleton.getSkeletonMC(),2,{
               "scaleX":1,
               "scaleY":1
            });
         }
         catch(e:Error)
         {
         }
         DisplayUtil.removeForParent(this.flashMC,false);
      }
   }
}
