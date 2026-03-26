package com.robot.app.cmd
{
   import com.robot.app.mapProcess.*;
   import com.robot.app.task.taskUtils.taskDialog.*;
   import com.robot.app.vipSession.*;
   import com.robot.core.*;
   import com.robot.core.config.*;
   import com.robot.core.info.SystemMsgInfo;
   import com.robot.core.manager.*;
   import com.robot.core.net.*;
   import flash.display.*;
   import flash.events.*;
   import org.taomee.manager.*;
   import org.taomee.utils.*;
   
   public class VipNotManager
   {
      
      private var npcMC:Sprite;
      
      private var npcLink:Array = [""];
      
      private var npcName:Array = ["","船长罗杰","机械师茜茜","博士派特","导航员爱丽丝","站长贾斯汀","诺诺","发明家肖恩"];
      
      private var panel:MovieClip;
      
      private var callBtn:SimpleButton;
      
      private var continueBtn:SimpleButton;
      
      private var goNowBtn:SimpleButton;
      
      public function VipNotManager()
      {
         super();
         this.npcLink.push(NpcTipDialog.SHIPER);
         this.npcLink.push(NpcTipDialog.CICI);
         this.npcLink.push(NpcTipDialog.DOCTOR);
         this.npcLink.push(NpcTipDialog.IRIS);
         this.npcLink.push(NpcTipDialog.JUSTIN);
         this.npcLink.push(NpcTipDialog.NONO);
         this.npcLink.push(NpcTipDialog.SHAWN);
      }
      
      public function goNow(_arg_1:SystemMsgInfo) : void
      {
         this.goNowBtn = CoreAssetsManager.getButton("lib_goNowBtn");
         this.goNowBtn.addEventListener(MouseEvent.CLICK,this.goNowHandler);
         this.show(this.goNowBtn,_arg_1,false);
         LevelManager.closeMouseEvent();
      }
      
      public function openAgain(_arg_1:SystemMsgInfo) : void
      {
         this.callBtn = CoreAssetsManager.getButton("lib_callBtn");
         this.callBtn.addEventListener(MouseEvent.CLICK,this.callHandler);
         this.show(this.callBtn,_arg_1);
      }
      
      public function cancelHandler(_arg_1:SystemMsgInfo) : void
      {
         this.continueBtn = CoreAssetsManager.getButton("lib_continueBtn");
         this.continueBtn.addEventListener(MouseEvent.CLICK,this.continueHandler);
         this.show(this.continueBtn,_arg_1);
      }
      
      private function goNowHandler(_arg_1:MouseEvent) : void
      {
         LevelManager.openMouseEvent();
         DisplayUtil.removeForParent(this.goNowBtn);
         DisplayUtil.removeForParent(this.panel,false);
         MapProcess_107.isOpenSuperNoNo = true;
         MapManager.changeMap(107);
      }
      
      private function callHandler(_arg_1:MouseEvent) : void
      {
         DisplayUtil.removeForParent(this.callBtn);
         DisplayUtil.removeForParent(this.panel,false);
         NonoManager.isBeckon = true;
         SocketConnection.send(CommandID.NONO_FOLLOW_OR_HOOM,1);
      }
      
      public function continueHandler(event:MouseEvent) : void
      {
         var r:VipSession = null;
         DisplayUtil.removeForParent(this.continueBtn);
         DisplayUtil.removeForParent(this.panel,false);
         r = new VipSession();
         r.addEventListener(VipSession.GET_SESSION,function(_arg_1:Event):void
         {
         });
         r.getSession();
      }
      
      private function show(dis:DisplayObject, data:SystemMsgInfo, isShowClose:Boolean = true) : void
      {
         var date:Date = null;
         var str:String = null;
         this.panel = this.getPanel(isShowClose);
         this.panel["titleTxt"].text = "亲爱的" + MainManager.actorInfo.nick;
         this.panel["msgTxt"].htmlText = data.msg;
         date = new Date(data.msgTime * 1000);
         str = this.npcName[data.npc] + "\r";
         this.panel["timeTxt"].text = str + date.getFullYear() + "年" + (date.getMonth() + 1) + "月" + date.getDate() + "日";
         ResourceManager.getResource(ClientConfig.getNpcSwfPath(this.npcLink[data.npc]),function(_arg_1:DisplayObject):void
         {
            npcMC.addChild(_arg_1);
         },"npc");
         LevelManager.topLevel.addChild(this.panel);
         this.panel.addChild(dis);
         DisplayUtil.align(dis,this.panel.getRect(this.panel),AlignType.BOTTOM_CENTER);
         dis.y -= 30;
      }
      
      private function getPanel(_arg_1:Boolean = true) : MovieClip
      {
         var _local_2:MovieClip = UIManager.getMovieClip("ui_SysMsg_Panel");
         var _local_3:SimpleButton = _local_2["closeBtn"];
         _local_3.addEventListener(MouseEvent.CLICK,this.closeHandler);
         if(!_arg_1)
         {
            DisplayUtil.removeForParent(_local_3);
         }
         this.npcMC = new Sprite();
         this.npcMC.scaleY = 0.65;
         this.npcMC.scaleX = 0.65;
         this.npcMC.x = 50;
         this.npcMC.y = 86;
         _local_2.addChild(this.npcMC);
         DisplayUtil.align(_local_2,null,AlignType.MIDDLE_CENTER);
         return _local_2;
      }
      
      private function closeHandler(_arg_1:MouseEvent) : void
      {
         DisplayUtil.removeForParent(this.panel,false);
         DisplayUtil.removeAllChild(this.npcMC);
      }
   }
}

