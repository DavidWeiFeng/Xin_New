package com.robot.app.cmd
{
   import com.adobe.images.PNGEncoder;
   import com.robot.app.task.taskUtils.taskDialog.*;
   import com.robot.app.vipSession.*;
   import com.robot.core.*;
   import com.robot.core.cmd.*;
   import com.robot.core.config.*;
   import com.robot.core.config.xml.AchieveXMLInfo;
   import com.robot.core.event.*;
   import com.robot.core.info.*;
   import com.robot.core.manager.*;
   import com.robot.core.mode.*;
   import com.robot.core.net.*;
   import com.robot.core.ui.alert.Alarm;
   import flash.display.*;
   import flash.events.*;
   import flash.external.ExternalInterface;
   import flash.geom.Matrix;
   import flash.geom.Rectangle;
   import flash.net.SharedObject;
   import flash.utils.*;
   import org.taomee.events.SocketEvent;
   import org.taomee.manager.*;
   import org.taomee.utils.*;
   
   public class SysMsgCmdListener
   {
      
      private static var owner:SysMsgCmdListener;
      
      public static var npcLink:Array = [""];
      
      public static var npcName:Array = ["","船长罗杰","机械师茜茜","博士派特","导航员爱丽丝","站长贾斯汀","诺诺","发明家肖恩"];
      
      private static const FIRST_OPEN:uint = 1;
      
      private static const OPEN_AGAIN:uint = 2;
      
      private static const CANCEL:uint = 3;
      
      private static const NONO_UPDATE:uint = 4;
      
      private var panel:MovieClip;
      
      private var npcMC:Sprite;
      
      private var icon:SimpleButton;
      
      private var isBeanOver:Boolean = false;
      
      private var msgArray:Array = [];
      
      private var newYearPanel:MovieClip;
      
      private var morePanel:AppModel;
      
      private var npcArary:Array = ["","主播纽斯","船长罗杰","博士派特","精灵学者迪恩","唔理哇啦","百事通罗开","工程是苏克","叽哩呱啦","机械师茜茜","总教官雷蒙","发明家肖恩","站长贾斯汀"];
      
      private var mapArary:Array = ["","传送舱","船长室","实验室","资料室","去瞭望舱","瞭望露台","动力室","瞭望露台","机械室","教官办公室","发明室","精灵太空站"];
      
      public function SysMsgCmdListener()
      {
         super();
      }
      
      public static function getInstance() : SysMsgCmdListener
      {
         if(!owner)
         {
            owner = new SysMsgCmdListener();
         }
         return owner;
      }
      
      public function addInfo(_arg_1:SystemMsgInfo) : void
      {
         this.msgArray.push(_arg_1);
         this.checkLength();
      }
      
      public function start() : void
      {
         npcLink.push(NpcTipDialog.SHIPER);
         npcLink.push(NpcTipDialog.CICI);
         npcLink.push(NpcTipDialog.DOCTOR);
         npcLink.push(NpcTipDialog.IRIS);
         npcLink.push(NpcTipDialog.JUSTIN);
         npcLink.push(NpcTipDialog.NONO);
         npcLink.push(NpcTipDialog.SHAWN);
         npcLink.push(NpcTipDialog.ROCKY);
         SocketConnection.addCmdListener(CommandID.SYSTEM_MESSAGE,this.onSystemMsg);
         EventManager.addEventListener(RobotEvent.BEAN_COMPLETE,this.onBeanOver);
         EventManager.addEventListener(VipCmdListener.BE_VIP,this.onBeVip);
         EventManager.addEventListener(VipCmdListener.FIRST_VIP,this.onBeVip);
         SocketConnection.addCmdListener(CommandID.VIP_LEVEL_UP,this.onVipLevelUp);
         SocketConnection.addCmdListener(50001,this.onev);
         SocketConnection.addCmdListener(50003,this.onAlert);
         SocketConnection.addCmdListener(50004,this.changew);
         SocketConnection.addCmdListener(50005,this.givetitle);
         SocketConnection.addCmdListener(CommandID.GOLD_CHECK_REMAIN,this.goldbuy);
      }
      
      public function givetitle(_arg_1:SocketEvent) : void
      {
         var _local_2:ByteArray = _arg_1.data as ByteArray;
         var id:Number = _local_2.readUnsignedInt();
         if(id == 0)
         {
            return;
         }
         this.processTitleImage(id);
      }
      
      public function processTitleImage(titleId:Number) : void
      {
         var _url:String = ClientConfig.getResPath("achieve/title/" + titleId + ".swf");
         ResourceManager.getResource(_url,function(swfContent:DisplayObject):void
         {
            var bounds:Rectangle = null;
            var bmData:BitmapData = null;
            var matrix:Matrix = null;
            var imgBytes:ByteArray = null;
            var byteArray:Array = null;
            var i:int = 0;
            try
            {
               if(swfContent is MovieClip)
               {
                  MovieClip(swfContent).stop();
               }
               bounds = swfContent.getBounds(null);
               bmData = new BitmapData(bounds.width * 1,bounds.height * 1,true,16777215);
               matrix = new Matrix();
               bmData.draw(swfContent,matrix);
               imgBytes = PNGEncoder.encode(bmData);
               byteArray = [];
               imgBytes.position = 0;
               for(i = 0; i < imgBytes.length; i++)
               {
                  byteArray.push(imgBytes.readUnsignedByte());
               }
               ExternalInterface.call("givetitle",byteArray,AchieveXMLInfo.getTitle(titleId),AchieveXMLInfo.getDesc(titleId));
            }
            catch(err:Error)
            {
               ExternalInterface.call("console.log",err.message);
            }
         },"title");
      }
      
      public function goldbuy(_arg_1:SocketEvent) : void
      {
         var _local_2:ByteArray = _arg_1.data as ByteArray;
         var _local_3:Number = _local_2.readUnsignedInt() / 100;
         var coins:Number = _local_2.readUnsignedInt();
         ExternalInterface.call("upStore",coins,_local_3);
      }
      
      private function onev(_arg_1:SocketEvent) : void
      {
         var _local_2:ByteArray = _arg_1.data as ByteArray;
         var _local_3:uint = _local_2.readUnsignedInt();
         PetManager.upDate();
         MainManager.actorInfo.evpool -= _local_3;
      }
      
      private function onAlert(obj:Object) : void
      {
         var data:AlertInfo = obj.data as AlertInfo;
         Alarm.show(data.msg);
      }
      
      private function changew(_arg_1:SocketEvent) : void
      {
         var _local_2:ByteArray = _arg_1.data as ByteArray;
         var _local_3:uint = _local_2.readUnsignedInt();
         if(!ExternalInterface.available)
         {
            return;
         }
         switch(_local_3)
         {
            case 0:
               ExternalInterface.call("WeathChange","none");
               break;
            case 1:
               ExternalInterface.call("WeathChange","rain");
               break;
            case 2:
               ExternalInterface.call("WeathChange","snow");
         }
      }
      
      private function onVipLevelUp(_arg_1:SocketEvent) : void
      {
         var _local_2:ByteArray = _arg_1.data as ByteArray;
         var _local_3:uint = _local_2.readUnsignedInt();
         if(_local_3 > 4)
         {
            _local_3 = 4;
         }
      }
      
      private function onBeVip(_arg_1:Event) : void
      {
         this.onOpen(null);
      }
      
      private function onOpen(_arg_1:SocketEvent) : void
      {
         var _local_2:NonoInfo = null;
         if(Boolean(MainManager.actorModel.nono))
         {
            _local_2 = MainManager.actorModel.nono.info;
            _local_2.superNono = true;
            MainManager.actorModel.hideNono();
            MainManager.actorModel.showNono(_local_2,MainManager.actorInfo.actionType);
         }
         if(Boolean(NonoManager.info))
         {
            NonoManager.info.superNono = true;
            NonoManager.info.power = 100;
            NonoManager.info.mate = 100;
         }
      }
      
      private function onBeanOver(_arg_1:Event) : void
      {
         this.isBeanOver = true;
         this.checkLength();
         SocketConnection.addCmdListener(CommandID.SYSTEM_TIME,this.onSysTime);
         SocketConnection.send(CommandID.SYSTEM_TIME);
      }
      
      private function onSysTime(_arg_1:SocketEvent) : void
      {
         var _local_2:SharedObject = null;
         var _local_3:SystemMsgInfo = null;
         SocketConnection.removeCmdListener(CommandID.SYSTEM_TIME,this.onSysTime);
         var _local_4:Date = (_arg_1.data as SystemTimeInfo).date;
         if(_local_4.getDay() == 5 && ClientConfig.uiVersion != SOManager.getUser_Info().data["nonoExp"] && Boolean(MainManager.actorInfo.hasNono))
         {
            _local_2 = SOManager.getUser_Info();
            _local_2.data["nonoExp"] = ClientConfig.uiVersion;
            SOManager.flush(_local_2);
            _local_3 = new SystemMsgInfo();
            _local_3.npc = 7;
            _local_3.msgTime = _local_4.getTime() / 1000;
            _local_3.msg = "    你的" + MainManager.actorInfo.nonoNick + "周全照顾使精灵们积累了额外的经验奖励，快去发明室的经验接收器那里领取本周的奖励吧！";
            this.msgArray.push(_local_3);
            this.checkLength();
         }
      }
      
      private function onSystemMsg(_arg_1:SocketEvent) : void
      {
         var _local_2:SystemMsgInfo = _arg_1.data as SystemMsgInfo;
         this.msgArray.push(_local_2);
         if(this.isBeanOver)
         {
            this.checkLength();
         }
      }
      
      private function checkLength() : void
      {
         var _local_1:VipNotManager = null;
         if(!this.isBeanOver)
         {
            return;
         }
         if(this.msgArray.length == 0)
         {
            this.hideIcon();
            return;
         }
         var _local_2:SystemMsgInfo = this.msgArray[0];
         if(_local_2.type == FIRST_OPEN || _local_2.type == OPEN_AGAIN || _local_2.type == CANCEL || _local_2.type == NONO_UPDATE)
         {
            _local_2 = this.msgArray.shift() as SystemMsgInfo;
            _local_1 = new VipNotManager();
            if(_local_2.type == FIRST_OPEN)
            {
               _local_1.goNow(_local_2);
            }
            else if(_local_2.type == OPEN_AGAIN || _local_2.type == NONO_UPDATE)
            {
               _local_1.openAgain(_local_2);
            }
            else if(_local_2.type == CANCEL)
            {
               _local_1.cancelHandler(_local_2);
            }
            this.checkLength();
            return;
         }
         if(this.msgArray.length > 0)
         {
            this.showIcon();
         }
         else if(this.msgArray.length == 0)
         {
            this.hideIcon();
         }
      }
      
      private function showIcon() : void
      {
         if(!this.icon)
         {
            this.icon = UIManager.getButton("System_Msg_Icon");
            this.icon.x = 118 + 70;
            this.icon.y = 20;
            this.icon.addEventListener(MouseEvent.CLICK,this.showSysMsg);
         }
         LevelManager.iconLevel.addChild(this.icon);
      }
      
      private function hideIcon() : void
      {
         DisplayUtil.removeForParent(this.icon);
      }
      
      private function showSysMsg(event:MouseEvent) : void
      {
         var data:SystemMsgInfo = null;
         var date:Date = null;
         var str:String = null;
         if(!this.panel)
         {
            this.panel = this.getPanel();
            this.newYearPanel = this.getNewYearPanel();
         }
         data = this.msgArray.shift() as SystemMsgInfo;
         if(!data.isNewYear)
         {
            this.panel["titleTxt"].text = "亲爱的" + MainManager.actorInfo.nick;
            this.panel["msgTxt"].htmlText = data.msg;
            date = new Date(data.msgTime * 1000);
            str = npcName[data.npc] + "\r";
            this.panel["timeTxt"].text = str + date.getFullYear() + "年" + (date.getMonth() + 1) + "月" + date.getDate() + "日";
            ResourceManager.getResource(ClientConfig.getNpcSwfPath(npcLink[data.npc]),function(_arg_1:DisplayObject):void
            {
               npcMC.addChild(_arg_1);
            },"npc");
            LevelManager.appLevel.addChild(this.panel);
         }
         else
         {
            this.showNewYearInfo(data);
         }
         this.checkLength();
      }
      
      private function getPanel() : MovieClip
      {
         var _local_1:MovieClip = UIManager.getMovieClip("ui_SysMsg_Panel");
         var _local_2:SimpleButton = _local_1["closeBtn"];
         _local_2.addEventListener(MouseEvent.CLICK,this.closeHandler);
         this.npcMC = new Sprite();
         this.npcMC.scaleY = 0.65;
         this.npcMC.scaleX = 0.65;
         this.npcMC.x = 50;
         this.npcMC.y = 86;
         _local_1.addChild(this.npcMC);
         DisplayUtil.align(_local_1,null,AlignType.MIDDLE_CENTER);
         return _local_1;
      }
      
      private function getNewYearPanel() : MovieClip
      {
         var _local_1:MovieClip = CoreAssetsManager.getMovieClip("lib_year_note");
         var _local_2:SimpleButton = _local_1["closeBtn"];
         _local_2.addEventListener(MouseEvent.CLICK,this.closeNewYearHandler);
         var _local_3:MovieClip = _local_1["moreBtn"];
         var _local_4:MovieClip = _local_1["openBtn"];
         _local_4.buttonMode = true;
         _local_3.buttonMode = true;
         _local_3.addEventListener(MouseEvent.CLICK,this.onMoreHandler);
         _local_4.addEventListener(MouseEvent.CLICK,this.onOpenHandler);
         DisplayUtil.align(_local_1,null,AlignType.MIDDLE_CENTER);
         return _local_1;
      }
      
      private function onMoreHandler(_arg_1:MouseEvent) : void
      {
         DisplayUtil.removeForParent(this.newYearPanel,false);
         if(!this.morePanel)
         {
            this.morePanel = new AppModel(ClientConfig.getAppModule("CongratulatePanel"),"正在打开...");
            this.morePanel.setup();
         }
         this.morePanel.show();
      }
      
      private function onOpenHandler(event:MouseEvent) : void
      {
         var r:VipSession = new VipSession();
         r.addEventListener(VipSession.GET_SESSION,function(_arg_1:Event):void
         {
         });
         r.getSession();
      }
      
      private function closeHandler(_arg_1:MouseEvent) : void
      {
         DisplayUtil.removeForParent(this.panel,false);
         DisplayUtil.removeAllChild(this.npcMC);
      }
      
      private function closeNewYearHandler(_arg_1:MouseEvent) : void
      {
         DisplayUtil.removeForParent(this.newYearPanel,false);
      }
      
      private function showNewYearInfo(_arg_1:SystemMsgInfo) : void
      {
         SOManager.getUser_Info().data["isReadMsg"] = ClientConfig.newsVersion;
         this.newYearPanel["txt"].htmlText = _arg_1.msg;
         LevelManager.appLevel.addChild(this.newYearPanel);
      }
   }
}

