package com.robot.app.task.publicizeenvoy
{
   import com.robot.core.config.*;
   import com.robot.core.event.*;
   import com.robot.core.manager.*;
   import com.robot.core.newloader.*;
   import com.robot.core.ui.alert.*;
   import flash.display.*;
   import flash.events.*;
   import flash.system.*;
   import flash.text.TextField;
   import org.taomee.utils.*;
   
   public class PublicizeEnvoyPanel extends Sprite
   {
      
      private const PATH:String = "module/publicizeenvoy/PublicizeEnvoyPanel.swf";
      
      private var mainMC:MovieClip;
      
      private var alertMC:MovieClip;
      
      private var inviteCode:TextField;
      
      private var count:TextField;
      
      private var alarmtxt:TextField;
      
      private var copy:SimpleButton;
      
      private var closeBtn:SimpleButton;
      
      private var _alarmStr:String = "感谢你为骄阳计划召集到这些勇士，快去<font color=\'#ff0000\' size=\'14\'>船长室</font>找<font color=\'#ff0000\'  size=\'14\'>船长</font>领取属于你的奖励吧！";
      
      private var _alarmB:Boolean = false;
      
      public function PublicizeEnvoyPanel()
      {
         super();
      }
      
      public function show(_arg_1:Boolean) : void
      {
         this._alarmB = _arg_1;
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
         var _local_2:MCLoader = new MCLoader(_local_1,LevelManager.appLevel,1,"正在打开赛尔召集令面板");
         _local_2.addEventListener(MCLoadEvent.SUCCESS,this.onLoadSuccess);
         _local_2.doLoad();
      }
      
      private function onLoadSuccess(_arg_1:MCLoadEvent) : void
      {
         var _local_2:MCLoader = _arg_1.currentTarget as MCLoader;
         _local_2.removeEventListener(MCLoadEvent.SUCCESS,this.onLoadSuccess);
         var _local_3:Class = _arg_1.getApplicationDomain().getDefinition("PublicizeEnloyPanel") as Class;
         this.mainMC = new _local_3() as MovieClip;
         this.alertMC = this.mainMC["alertmc"];
         this.inviteCode = this.mainMC["invitecode"];
         this.count = this.mainMC["count"];
         this.alarmtxt = this.alertMC["alarmtxt"];
         if(this._alarmB)
         {
            this.alertMC.visible = true;
            this.alarmtxt.htmlText = this._alarmStr;
         }
         else
         {
            this.alertMC.visible = false;
         }
         this.copy = this.mainMC["copybtn"];
         this.copy.addEventListener(MouseEvent.CLICK,this.copyHandler);
         this.closeBtn = this.mainMC["closebtn"];
         this.closeBtn.addEventListener(MouseEvent.CLICK,this.close);
         _local_2.clear();
         this.init();
      }
      
      private function init() : void
      {
         this.inviteCode.text = this.getRegCode().toString();
         this.count.text = MainManager.actorInfo.newInviteeCnt.toString();
         this.addChild(this.mainMC);
         DisplayUtil.align(this,null,AlignType.MIDDLE_CENTER);
         LevelManager.appLevel.addChild(this);
      }
      
      private function copyHandler(_arg_1:MouseEvent) : void
      {
         var _local_2:String = "我正在骄阳计划上进行太空探险，带着我的精灵在各个星球上战斗，他们还会进化呢。快和我一起来吧，seer.61.com 注册的邀请码是" + this.getRegCode().toString() + "。我们骄阳计划上见！";
         System.setClipboard(_local_2);
         Alarm.show("复制成功，现在可以使用右键粘贴到QQ或者MSN聊天窗口发送给朋友，记得让你的朋友在注册时输入邀请码哦！");
         this.close(null);
      }
      
      private function close(_arg_1:MouseEvent) : void
      {
         DisplayUtil.removeForParent(this);
      }
      
      public function getRegCode() : uint
      {
         return MainManager.actorInfo.userID + 1321047;
      }
   }
}

