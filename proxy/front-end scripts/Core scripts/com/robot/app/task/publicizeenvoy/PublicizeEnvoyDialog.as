package com.robot.app.task.publicizeenvoy
{
   import com.robot.core.*;
   import com.robot.core.config.*;
   import com.robot.core.config.xml.*;
   import com.robot.core.event.*;
   import com.robot.core.info.pet.*;
   import com.robot.core.manager.*;
   import com.robot.core.net.*;
   import com.robot.core.newloader.*;
   import com.robot.core.ui.alert.*;
   import flash.display.*;
   import flash.events.*;
   import flash.utils.*;
   import org.taomee.events.SocketEvent;
   import org.taomee.utils.*;
   
   public class PublicizeEnvoyDialog extends Sprite
   {
      
      private static var _instance:PublicizeEnvoyDialog;
      
      private const PATH:String = "module/publicizeenvoy/PublicizeEnvoyDialog.swf";
      
      private var dialogMC:MovieClip;
      
      private var closeBtn:SimpleButton;
      
      private var acceptBtn:SimpleButton;
      
      public function PublicizeEnvoyDialog()
      {
         super();
      }
      
      public static function getInstance() : PublicizeEnvoyDialog
      {
         if(!_instance)
         {
            _instance = new PublicizeEnvoyDialog();
         }
         return _instance;
      }
      
      public function show() : void
      {
         if(MainManager.actorInfo.dsFlag == 1)
         {
            SocketConnection.addCmdListener(CommandID.PRICE_OF_DS,this.onAcceptRewordHandler);
            SocketConnection.send(CommandID.PRICE_OF_DS);
         }
         else if(Boolean(this.dialogMC))
         {
            this.init();
         }
         else
         {
            this.loadUI();
         }
      }
      
      private function onAcceptRewordHandler(e:SocketEvent) : void
      {
         var by:ByteArray = null;
         var bonusID:uint = 0;
         var monID:uint = 0;
         var capTm:uint = 0;
         var awardCount:uint = 0;
         var i:int = 0;
         var isBagFull:Boolean = false;
         var id:uint = 0;
         var count:uint = 0;
         var name:String = null;
         var alertStr:String = null;
         SocketConnection.removeCmdListener(CommandID.PRICE_OF_DS,this.onAcceptRewordHandler);
         this.close(null);
         by = e.data as ByteArray;
         bonusID = by.readUnsignedInt();
         monID = by.readUnsignedInt();
         capTm = by.readUnsignedInt();
         awardCount = by.readUnsignedInt();
         if(capTm > 0)
         {
            if(PetManager.length < 6)
            {
               SocketConnection.send(CommandID.PET_RELEASE,capTm,1);
               SocketConnection.send(CommandID.GET_PET_INFO,capTm);
               isBagFull = false;
            }
            else
            {
               isBagFull = true;
            }
            if(!isBagFull)
            {
               SocketConnection.addCmdListener(CommandID.GET_PET_INFO,function(_arg_1:SocketEvent):void
               {
                  var _local_2:PetInfo = _arg_1.data as PetInfo;
                  PetManager.add(_local_2);
               });
               SocketConnection.send(CommandID.GET_PET_INFO,capTm);
               PetInBagAlert.show(monID,"恭喜你获得了<font color=\'#00CC00\'>" + PetXMLInfo.getName(monID) + "</font>，你可以点击右下方的精灵按钮来查看");
            }
            else
            {
               PetManager.addStorage(monID,capTm);
               PetInStorageAlert.show(monID,"恭喜你获得了<font color=\'#00CC00\'>" + PetXMLInfo.getName(monID) + "</font>，你可以在基地仓库里找到",LevelManager.iconLevel);
            }
         }
         i = 0;
         while(i < awardCount)
         {
            id = by.readUnsignedInt();
            count = by.readUnsignedInt();
            name = ItemXMLInfo.getName(id);
            alertStr = count + "个<font color=\'#ff0000\'>" + name + "</font>已放入了你的储存箱。";
            ItemInBagAlert.show(id,alertStr);
            i += 1;
         }
      }
      
      private function loadUI() : void
      {
         var _local_1:String = ClientConfig.getResPath(this.PATH);
         var _local_2:MCLoader = new MCLoader(_local_1,LevelManager.appLevel,1,"正在打开召集令任务程序");
         _local_2.addEventListener(MCLoadEvent.SUCCESS,this.onLoadSuccess);
         _local_2.doLoad();
      }
      
      private function onLoadSuccess(_arg_1:MCLoadEvent) : void
      {
         var _local_2:MCLoader = _arg_1.currentTarget as MCLoader;
         _local_2.removeEventListener(MCLoadEvent.SUCCESS,this.onLoadSuccess);
         var _local_3:Class = _arg_1.getApplicationDomain().getDefinition("PublicizeEnvoyDialog") as Class;
         this.dialogMC = new _local_3() as MovieClip;
         this.acceptBtn = this.dialogMC["acceptbtn"];
         this.closeBtn = this.dialogMC["closebtn"];
         this.acceptBtn.addEventListener(MouseEvent.CLICK,this.acceptTaskHandler);
         this.closeBtn.addEventListener(MouseEvent.CLICK,this.close);
         _local_2.clear();
         this.init();
      }
      
      private function init() : void
      {
         this.addChild(this.dialogMC);
         DisplayUtil.align(this,null,AlignType.MIDDLE_CENTER);
         LevelManager.appLevel.addChild(this);
      }
      
      private function acceptTaskHandler(_arg_1:MouseEvent) : void
      {
         SocketConnection.addCmdListener(CommandID.SET_DS_STATUS,this.backHandler);
         SocketConnection.send(CommandID.SET_DS_STATUS,1);
      }
      
      private function backHandler(_arg_1:SocketEvent) : void
      {
         MainManager.actorInfo.dsFlag = 1;
         PublicizeEnvoyIconControl.addIcon();
         this.close(null);
      }
      
      private function close(_arg_1:MouseEvent) : void
      {
         DisplayUtil.removeForParent(this);
      }
   }
}

