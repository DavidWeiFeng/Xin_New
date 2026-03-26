package com.robot.app.RegisterCode
{
   import com.robot.app.task.taskUtils.taskDialog.*;
   import com.robot.core.*;
   import com.robot.core.event.*;
   import com.robot.core.manager.*;
   import com.robot.core.net.*;
   import com.robot.core.newloader.*;
   import flash.display.*;
   import flash.events.*;
   import flash.system.*;
   import flash.text.TextField;
   import flash.utils.*;
   import org.taomee.events.SocketEvent;
   import org.taomee.utils.*;
   
   public class CopyRegisterCodePanel
   {
      
      private static var mc:MovieClip;
      
      private static var app:ApplicationDomain;
      
      private static var closeBtn:SimpleButton;
      
      private static var copyBtn:SimpleButton;
      
      private static var exchangeBtn:SimpleButton;
      
      private static var PATH:String = "resource/module/RequestCode/registerCode.swf";
      
      public function CopyRegisterCodePanel()
      {
         super();
      }
      
      public static function loadPanel() : void
      {
         var _local_1:MCLoader = null;
         if(!mc)
         {
            _local_1 = new MCLoader(PATH,LevelManager.topLevel,1,"正在打开邀请码面板");
            _local_1.addEventListener(MCLoadEvent.SUCCESS,onLoad);
            _local_1.doLoad();
         }
         else
         {
            mc.gotoAndStop(1);
            show();
         }
      }
      
      private static function onLoad(_arg_1:MCLoadEvent) : void
      {
         app = _arg_1.getApplicationDomain();
         mc = new (app.getDefinition("codePanel") as Class)() as MovieClip;
         show();
      }
      
      private static function show() : void
      {
         var dragMc:SimpleButton = null;
         var codeTxt:TextField = null;
         DisplayUtil.align(mc,null,AlignType.MIDDLE_CENTER);
         LevelManager.closeMouseEvent();
         LevelManager.appLevel.addChild(mc);
         closeBtn = mc["exitBtn"];
         copyBtn = mc["copyBtn"];
         exchangeBtn = mc["exchangeBtn"];
         dragMc = mc["dragMC"];
         dragMc.addEventListener(MouseEvent.MOUSE_DOWN,function():void
         {
            mc.startDrag();
         });
         dragMc.addEventListener(MouseEvent.MOUSE_UP,function():void
         {
            mc.stopDrag();
         });
         codeTxt = mc["codeTxt"];
         codeTxt.text = GetRegisterCode.getRegCode.toString();
         exchangeBtn.addEventListener(MouseEvent.CLICK,getRequstAward);
         closeBtn.addEventListener(MouseEvent.CLICK,closeHandler);
         copyBtn.addEventListener(MouseEvent.CLICK,copyContent);
         SocketConnection.addCmdListener(CommandID.REQUEST_COUNT,onCount);
         SocketConnection.send(CommandID.REQUEST_COUNT,MainManager.actorID);
      }
      
      private static function closeHandler(_arg_1:MouseEvent) : void
      {
         DisplayUtil.removeForParent(mc);
         LevelManager.openMouseEvent();
         closeBtn.removeEventListener(MouseEvent.CLICK,closeHandler);
      }
      
      private static function copyContent(_arg_1:MouseEvent) : void
      {
         var _local_2:String = "我正在骄阳计划上进行太空探险，带着我的精灵在各个星球上战斗，他们还会进化呢。快和我一起来吧，www.51seer.com 注册的邀请码是" + GetRegisterCode.getRegCode.toString() + "。我们骄阳计划上见！";
         System.setClipboard(_local_2);
      }
      
      private static function getRequstAward(_arg_1:MouseEvent) : void
      {
         SocketConnection.addCmdListener(CommandID.GET_REQUEST_AWARD,onGetAward);
         SocketConnection.send(CommandID.GET_REQUEST_AWARD);
      }
      
      private static function onGetAward(_arg_1:SocketEvent) : void
      {
         SocketConnection.removeCmdListener(CommandID.GET_REQUEST_AWARD,onGetAward);
         NpcTipDialog.show("恭喜你成为合格的星际联络官，联络官套装已经放入了你的储存箱");
      }
      
      private static function onCount(_arg_1:SocketEvent) : void
      {
         SocketConnection.removeCmdListener(CommandID.REQUEST_COUNT,onCount);
         var _local_2:ByteArray = _arg_1.data as ByteArray;
         var _local_3:uint = _local_2.readUnsignedInt();
         var _local_4:uint = _local_2.readUnsignedInt();
         mc["countTxt"].text = _local_4.toString();
      }
   }
}

