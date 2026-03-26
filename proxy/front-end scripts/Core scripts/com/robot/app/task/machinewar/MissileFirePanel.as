package com.robot.app.task.machinewar
{
   import com.robot.core.config.*;
   import com.robot.core.event.*;
   import com.robot.core.info.userItem.SingleItemInfo;
   import com.robot.core.manager.*;
   import com.robot.core.newloader.*;
   import com.robot.core.ui.alert.*;
   import flash.display.*;
   import flash.events.*;
   import org.taomee.effect.*;
   import org.taomee.utils.*;
   
   public class MissileFirePanel extends Sprite
   {
      
      private const PATH:String = "task/missilefire.swf";
      
      private var mainMC:MovieClip;
      
      private var closeBtn:SimpleButton;
      
      private var sendBtn:SimpleButton;
      
      private var canSend:Boolean;
      
      public function MissileFirePanel()
      {
         super();
      }
      
      public function show() : void
      {
         if(Boolean(this.mainMC))
         {
            this.init();
         }
         else
         {
            this.loadUI();
         }
      }
      
      private function loadUI() : void
      {
         var _local_1:String = ClientConfig.getResPath(this.PATH);
         var _local_2:MCLoader = new MCLoader(_local_1,LevelManager.appLevel,1,"正在打开发射系统程序");
         _local_2.addEventListener(MCLoadEvent.SUCCESS,this.onLoadSuccess);
         _local_2.doLoad();
      }
      
      private function onLoadSuccess(event:MCLoadEvent) : void
      {
         var cls:Class = null;
         var mcloader:MCLoader = event.currentTarget as MCLoader;
         mcloader.removeEventListener(MCLoadEvent.SUCCESS,this.onLoadSuccess);
         cls = event.getApplicationDomain().getDefinition("Main_Panel") as Class;
         this.mainMC = new cls() as MovieClip;
         this.closeBtn = this.mainMC["close_btn"];
         this.closeBtn.addEventListener(MouseEvent.CLICK,this.close);
         this.sendBtn = this.mainMC["send_bomrb"];
         this.sendBtn.addEventListener(MouseEvent.CLICK,this.sendHandler);
         mcloader.clear();
         ItemManager.addEventListener(ItemEvent.COLLECTION_LIST,function(_arg_1:ItemEvent):void
         {
            var _local_3:uint = 0;
            var _local_4:uint = 0;
            ItemManager.removeEventListener(ItemEvent.COLLECTION_LIST,arguments.callee);
            var _local_5:SingleItemInfo = ItemManager.getInfo(400008);
            if(Boolean(_local_5))
            {
               _local_4 = uint(_local_5.itemNum);
               if(_local_4 >= 5)
               {
                  canSend = true;
               }
               else
               {
                  _local_3 = uint(_local_4 + 1);
                  while(_local_3 < 6)
                  {
                     mainMC["energy" + _local_3].filters = [ColorFilter.setGrayscale()];
                     _local_3++;
                  }
               }
            }
            else
            {
               canSend = false;
               _local_3 = 1;
               while(_local_3 < 6)
               {
                  mainMC["energy" + _local_3].filters = [ColorFilter.setGrayscale()];
                  _local_3++;
               }
            }
         });
         ItemManager.getCollection();
         this.init();
      }
      
      private function init() : void
      {
         this.addChild(this.mainMC);
         DisplayUtil.align(this,null,AlignType.MIDDLE_CENTER);
         LevelManager.appLevel.addChild(this);
      }
      
      private function close(_arg_1:MouseEvent) : void
      {
         DisplayUtil.removeForParent(this);
      }
      
      private function sendHandler(event:MouseEvent) : void
      {
         if(this.canSend)
         {
            this.mainMC.gotoAndStop(2);
            LevelManager.closeMouseEvent();
            this.mainMC.addEventListener(Event.ENTER_FRAME,function(_arg_1:Event):void
            {
               var _local_3:MovieClip = mainMC["loading"];
               if(Boolean(_local_3))
               {
                  mainMC.removeEventListener(Event.ENTER_FRAME,arguments.callee);
                  _local_3.addEventListener(Event.ENTER_FRAME,onLoadingFrameHandler);
               }
            });
         }
         else
         {
            Alarm.show("很抱歉您目前还没有<font color=\'#ff0000\'>5颗电容球</font>，不能启动导弹发射装置。");
         }
      }
      
      private function onLoadingFrameHandler(_arg_1:Event) : void
      {
         if(this.mainMC["loading"].totalFrames == this.mainMC["loading"].currentFrame)
         {
            this.mainMC["loading"].removeEventListener(Event.ENTER_FRAME,this.onLoadingFrameHandler);
            LevelManager.openMouseEvent();
            this.dispatchEvent(new Event("canSend"));
            this.close(null);
         }
      }
      
      private function loadItem(_arg_1:Array) : void
      {
      }
   }
}

