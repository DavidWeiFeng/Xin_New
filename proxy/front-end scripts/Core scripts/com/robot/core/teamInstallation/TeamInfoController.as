package com.robot.core.teamInstallation
{
   import com.robot.core.*;
   import com.robot.core.config.*;
   import com.robot.core.config.xml.*;
   import com.robot.core.energyExchange.*;
   import com.robot.core.info.team.*;
   import com.robot.core.manager.*;
   import com.robot.core.mode.*;
   import com.robot.core.net.*;
   import com.robot.core.ui.alert.*;
   import flash.events.*;
   import flash.utils.*;
   import org.taomee.ds.*;
   import org.taomee.events.SocketEvent;
   
   public class TeamInfoController
   {
      
      private static var _info:ArmInfo;
      
      private static var _teamId:uint;
      
      private static var _nexF:uint;
      
      private static var _workTime:int;
      
      private static var _donateTime:int;
      
      private static var _maxA:Array;
      
      private static var _needIdA:Array;
      
      private static var _curNumA:Array;
      
      private static var _workPanel:AppModel;
      
      private static var _teamLeaderApp:AppModel;
      
      private static var _memberApp:AppModel;
      
      private static var _matterListApp:AppModel;
      
      private static var _donateApp:AppModel;
      
      private static var _superPanel:AppModel;
      
      private static var _curSuperInfo:ExchangeItemInfo;
      
      public static var _isUpdata:uint = 0;
      
      public function TeamInfoController()
      {
         super();
      }
      
      public static function setRemainWorkTime() : void
      {
         --_workTime;
         ++MainManager.actorInfo.dailyResArr[10];
         if(_workTime < 0)
         {
            _workTime = 0;
         }
      }
      
      public static function get remainWorkTime() : uint
      {
         return _workTime;
      }
      
      public static function setRemainDonate(_arg_1:uint) : void
      {
         _donateTime -= _arg_1;
         MainManager.actorInfo.dailyResArr[11] += _arg_1;
         if(_donateTime < 0)
         {
            _donateTime = 0;
         }
      }
      
      public static function get remainDonate() : uint
      {
         return _donateTime;
      }
      
      public static function get teamId() : uint
      {
         return _teamId;
      }
      
      public static function get nexForm() : uint
      {
         return _nexF;
      }
      
      public static function get info() : ArmInfo
      {
         return _info;
      }
      
      public static function start(_arg_1:ArmInfo) : void
      {
         _info = _arg_1;
         _workTime = 5 - MainManager.actorInfo.dailyResArr[10];
         _donateTime = 100 - MainManager.actorInfo.dailyResArr[11];
         if(_workTime < 0)
         {
            _workTime = 0;
         }
         if(_donateTime < 0)
         {
            _donateTime = 0;
         }
         SocketConnection.addCmdListener(CommandID.ARM_UP_GET_ONE_INFO,onComHandler);
         SocketConnection.send(CommandID.ARM_UP_GET_ONE_INFO,MainManager.actorInfo.teamInfo.id,_info.buyTime);
      }
      
      private static function onComHandler(_arg_1:SocketEvent) : void
      {
         var _local_2:int = 0;
         var _local_5:int = 0;
         SocketConnection.removeCmdListener(CommandID.ARM_UP_GET_ONE_INFO,onComHandler);
         var _local_3:ByteArray = _arg_1.data as ByteArray;
         _teamId = _local_3.readUnsignedInt();
         ArmInfo.setFor2967_2965(_info,_local_3);
         _nexF = FortressItemXMLInfo.getNextForm(_info.id,_info.form);
         var _local_4:Array = FortressItemXMLInfo.getResIDs(_info.id,_info.form);
         _maxA = FortressItemXMLInfo.getResMaxs(_info.id,_info.form);
         _needIdA = [];
         _curNumA = [];
         while(_local_5 < _local_4.length)
         {
            _local_2 = 0;
            while(_local_2 < _info.res.length)
            {
               if(_local_4[_local_5] != 0 && _local_4[_local_5] == _info.res.getKeys()[_local_2])
               {
                  _needIdA.push(_local_4[_local_5]);
                  _curNumA.push(_info.res.getValues()[_local_2]);
               }
               _local_2++;
            }
            _local_5++;
         }
         if(_info.form > 1)
         {
            if(_info.form < uint(FortressItemXMLInfo.getMaxLevel(_info.id)))
            {
               showMatterApp();
            }
            else
            {
               showMemberPanel();
            }
         }
         else
         {
            if(_info.res.getValues()[1] == 5000)
            {
               SocketConnection.addCmdListener(CommandID.ARM_UP_UPDATE,onUpHandler);
               SocketConnection.send(CommandID.ARM_UP_UPDATE,_info.buyTime,_nexF);
               return;
            }
            showWorkPanel();
         }
      }
      
      public static function canLevelUp(fun:Function) : void
      {
         SocketConnection.addCmdListener(CommandID.TEAM_GET_INFO,function(_arg_1:SocketEvent):void
         {
            SocketConnection.removeCmdListener(CommandID.TEAM_GET_INFO,arguments.callee);
            var _local_3:SimpleTeamInfo = _arg_1.data as SimpleTeamInfo;
            if(_local_3.exp < _local_3.countExp(_local_3.level + 1))
            {
               fun(false);
            }
            else
            {
               fun(true);
            }
         });
         SocketConnection.send(CommandID.TEAM_GET_INFO,MainManager.actorInfo.teamInfo.id);
      }
      
      private static function onUpHandler(_arg_1:SocketEvent) : void
      {
         SocketConnection.removeCmdListener(CommandID.ARM_UP_UPDATE,onUpHandler);
         SocketConnection.addCmdListener(CommandID.ARM_UP_GET_ONE_INFO,onComHandler);
         SocketConnection.send(CommandID.ARM_UP_GET_ONE_INFO,MainManager.actorInfo.teamInfo.id,_info.buyTime);
      }
      
      public static function destroy() : void
      {
         SocketConnection.removeCmdListener(CommandID.ARM_UP_GET_ONE_INFO,onComHandler);
         SocketConnection.removeCmdListener(CommandID.ARM_UP_UPDATE,onUpHandler);
         _info = null;
         if(Boolean(_workPanel))
         {
            _workPanel.destroy();
            _workPanel = null;
         }
         if(Boolean(_teamLeaderApp))
         {
            _teamLeaderApp.sharedEvents.removeEventListener(Event.CLOSE,onTeamLeaderHandler);
            _teamLeaderApp.destroy();
            _teamLeaderApp = null;
         }
         if(Boolean(_memberApp))
         {
            _memberApp.destroy();
            _memberApp = null;
         }
         if(Boolean(_matterListApp))
         {
            _matterListApp.destroy();
            _matterListApp = null;
         }
         if(Boolean(_donateApp))
         {
            _donateApp.destroy();
            _donateApp = null;
         }
         if(Boolean(_superPanel))
         {
            onCloseSuperHandler(null);
         }
      }
      
      public static function showWorkPanel() : void
      {
         if(!_workPanel)
         {
            _workPanel = new AppModel(ClientConfig.getAppModule("ConstructionProgressPanel"),"正在进入");
            _workPanel.setup();
         }
         _workPanel.init(_info);
         _workPanel.show();
      }
      
      private static function showTeamLeaderPanel() : void
      {
         if(!_teamLeaderApp)
         {
            _teamLeaderApp = new AppModel(ClientConfig.getAppModule("TeamLeaderCanSeePanel"),"正在进入");
            _teamLeaderApp.setup();
            _teamLeaderApp.sharedEvents.addEventListener(Event.CLOSE,onTeamLeaderHandler);
         }
         _teamLeaderApp.init(_info);
         _teamLeaderApp.show();
      }
      
      private static function onTeamLeaderHandler(_arg_1:Event) : void
      {
         showMatterApp();
      }
      
      private static function showMemberPanel() : void
      {
         if(!_memberApp)
         {
            _memberApp = new AppModel(ClientConfig.getAppModule("MemberCanSeePanel"),"正在进入");
            _memberApp.setup();
         }
         _memberApp.init(_info);
         _memberApp.show();
      }
      
      private static function showMatterApp() : void
      {
         if(!_matterListApp)
         {
            _matterListApp = new AppModel(ClientConfig.getAppModule("NeedMatterListPanel"),"正在进入");
            _matterListApp.setup();
            _matterListApp.sharedEvents.addEventListener(Event.CLOSE,onCloseHandler);
         }
         _matterListApp.init(_info);
         _matterListApp.show();
      }
      
      private static function onCloseHandler(_arg_1:Event) : void
      {
         canDonate();
      }
      
      private static function canDonate() : void
      {
         ExchangeOreModel.getData(onDataComHandler,"你目前没有可以捐献的物质。");
      }
      
      private static function onDataComHandler(_arg_1:Object) : void
      {
         var _local_2:HashMap = null;
         var _local_3:Array = null;
         var _local_4:Array = null;
         var _local_5:int = 0;
         var _local_6:int = 0;
         if(Boolean(_arg_1))
         {
            _local_2 = _arg_1 as HashMap;
            _local_3 = _local_2.getValues();
            _local_4 = new Array();
            _local_5 = 0;
            while(_local_5 < _needIdA.length)
            {
               _local_6 = 0;
               while(_local_6 < _local_3.length)
               {
                  if(_needIdA[_local_5] == (_local_3[_local_6] as ExchangeItemInfo).itemId)
                  {
                     if(_curNumA[_local_5] < _maxA[_local_5])
                     {
                        _local_4.push(_local_3[_local_6]);
                     }
                  }
                  if(_local_5 == _needIdA.length - 1)
                  {
                     if((_local_3[_local_6] as ExchangeItemInfo).isSuper)
                     {
                        _local_4.push(_local_3[_local_6]);
                     }
                  }
                  _local_6++;
               }
               _local_5++;
            }
            if(_local_4.length > 0)
            {
               showCanList(_local_4);
            }
            else
            {
               Alarm.show("你没有该设施升级所需的物资可以捐献！");
            }
         }
      }
      
      private static function showCanList(_arg_1:Array) : void
      {
         if(!_donateApp)
         {
            _donateApp = new AppModel(ClientConfig.getAppModule("DonateMatterListPanel"),"正在打开");
            _donateApp.setup();
            _donateApp.sharedEvents.addEventListener(Event.CLOSE,onCloseMatterListHandler);
            _donateApp.sharedEvents.addEventListener(Event.OPEN,onOpenMatterListHandler);
         }
         _donateApp.init(_arg_1);
         _donateApp.show();
      }
      
      private static function onCloseMatterListHandler(_arg_1:Event) : void
      {
         _donateApp.sharedEvents.removeEventListener(Event.CLOSE,onCloseMatterListHandler);
         _donateApp.sharedEvents.removeEventListener(Event.OPEN,onOpenMatterListHandler);
         _donateApp.destroy();
         _donateApp = null;
      }
      
      private static function onOpenMatterListHandler(_arg_1:Event) : void
      {
         onCloseMatterListHandler(null);
         showSuperPanel();
      }
      
      private static function showSuperPanel() : void
      {
         if(!_superPanel)
         {
            _superPanel = new AppModel(ClientConfig.getAppModule("SuperDonateMatterPanel"),"正在打开");
            _superPanel.setup();
            _superPanel.sharedEvents.addEventListener(Event.CLOSE,onCloseSuperHandler);
         }
         _superPanel.init(_curSuperInfo);
         _superPanel.show();
      }
      
      private static function onCloseSuperHandler(_arg_1:Event) : void
      {
         _superPanel.sharedEvents.removeEventListener(Event.CLOSE,onCloseSuperHandler);
         _superPanel.destroy();
         _superPanel = null;
      }
      
      public static function removeNum(_arg_1:Array) : Array
      {
         var _local_2:int = 0;
         while(_local_2 < _arg_1.length)
         {
            if(_arg_1[_local_2] == 0)
            {
               _arg_1.splice(_local_2,1);
               _local_2--;
            }
            _local_2++;
         }
         return _arg_1;
      }
      
      public static function get curSuperInfo() : ExchangeItemInfo
      {
         return _curSuperInfo;
      }
      
      public static function set curSuperInfo(_arg_1:ExchangeItemInfo) : void
      {
         _curSuperInfo = _arg_1;
      }
      
      public static function get needIdA() : Array
      {
         return _needIdA;
      }
      
      public static function get curNumA() : Array
      {
         return _curNumA;
      }
      
      public static function get maxA() : Array
      {
         return _maxA;
      }
   }
}

