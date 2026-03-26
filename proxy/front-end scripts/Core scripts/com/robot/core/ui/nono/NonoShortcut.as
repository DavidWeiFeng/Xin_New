package com.robot.core.ui.nono
{
   import com.robot.core.*;
   import com.robot.core.config.*;
   import com.robot.core.config.xml.*;
   import com.robot.core.event.*;
   import com.robot.core.info.NonoInfo;
   import com.robot.core.manager.*;
   import com.robot.core.mode.*;
   import com.robot.core.net.*;
   import com.robot.core.ui.alert.*;
   import flash.display.*;
   import flash.events.*;
   import flash.geom.Point;
   import org.taomee.effect.*;
   import org.taomee.manager.*;
   import org.taomee.utils.*;
   
   public class NonoShortcut
   {
      
      private static var _mainUI:Sprite;
      
      private static var _bgmc:Sprite;
      
      private static var _cureBtn:SimpleButton;
      
      private static var _fhBtn:SimpleButton;
      
      private static var _jnBtn:SimpleButton;
      
      private static var _powerBtn:SimpleButton;
      
      private static var _petStorageBtn:SimpleButton;
      
      private static var _petDiscoverBtn:SimpleButton;
      
      private static var _appModel:AppModel;
      
      private static var _nonoPanel:AppModel;
      
      private static var _nonoInfoPanel:AppModel;
      
      private static var _info:NonoInfo;
      
      private static var _flag:Boolean;
      
      private static var _canShowA:Array;
      
      private static var _tipA:Array;
      
      private static var _handlerFunA:Array;
      
      private static var _itemA:Array;
      
      private static var _petStorage:AppModel;
      
      private static const _length:uint = 8;
      
      private static var _newShowA:Array = ["700011","700015","700017"];
      
      private static var _newTipA:Array = ["精灵仓库","精灵追踪","飞行模式"];
      
      public function NonoShortcut()
      {
         super();
      }
      
      private static function makeAry() : void
      {
         var _local_1:int = 0;
         if(MainManager.actorInfo.actionType == 0)
         {
            _newTipA[2] = "飞行模式";
         }
         else
         {
            _newTipA[2] = "取消飞行模式";
         }
         if(TaomeeManager.nonoSpriteTrack == 1)
         {
            _newTipA[1] = "关闭精灵追踪";
         }
         else
         {
            _newTipA[1] = "开启精灵追踪";
         }
         _canShowA = ["1","2","3","4"];
         _tipA = ["精灵治疗","跟随主人","经验分配","给NoNo充电"];
         _handlerFunA = [onCure,onFollow,onjn,onPower,hide,hide];
         if(_flag == false)
         {
            _canShowA[1] = "2";
            _tipA[1] = "跟随主人";
            if(!MainManager.actorInfo.superNono)
            {
               _canShowA[3] = "4";
               _tipA[3] = "给NoNo充电";
            }
            else
            {
               _canShowA[3] = null;
               _tipA[3] = null;
            }
         }
         else
         {
            _canShowA[1] = "2_1";
            _tipA[1] = "回家休息";
            _canShowA[3] = null;
            _tipA[3] = null;
         }
         while(_local_1 < _newShowA.length)
         {
            if(Boolean(_info.func[uint(_newShowA[_local_1]) - 700001]))
            {
               if(ItemXMLInfo.getVipOnly(uint(_newShowA[_local_1])))
               {
                  if(MainManager.actorInfo.superNono)
                  {
                     _canShowA.push(_newShowA[_local_1]);
                     _tipA.push(_newTipA[_local_1]);
                  }
               }
               else if(MainManager.actorInfo.superNono)
               {
                  _canShowA.push(_newShowA[_local_1]);
                  _tipA.push(_newTipA[_local_1]);
               }
               else if(NonoManager.info.ai >= ItemXMLInfo.getAiLevel(uint(_newShowA[_local_1])))
               {
                  _canShowA.push(_newShowA[_local_1]);
                  _tipA.push(_newTipA[_local_1]);
               }
            }
            _local_1++;
         }
      }
      
      private static function addKeyBg() : void
      {
         var _local_1:NonoShortcutKeyItem = null;
         if(!_itemA)
         {
            _itemA = new Array();
         }
         var _local_2:int = 1;
         while(_local_2 <= _length)
         {
            _local_1 = new NonoShortcutKeyItem();
            _mainUI["key" + _local_2].addChild(_local_1);
            _itemA.push(_local_1);
            _local_2++;
         }
      }
      
      private static function clearKeyBg() : void
      {
         var _local_1:int = 1;
         while(_local_1 <= _length)
         {
            (_itemA[_local_1 - 1] as NonoShortcutKeyItem).destroy();
            _local_1++;
         }
      }
      
      private static function setData() : void
      {
         var _local_1:NonoShortcutKeyItem = null;
         var _local_2:int = 1;
         while(_local_2 <= _length)
         {
            _local_1 = _itemA[_local_2 - 1] as NonoShortcutKeyItem;
            if(_canShowA[_local_2 - 1] != null)
            {
               if(_canShowA[_local_2 - 1] != undefined)
               {
                  if(_handlerFunA[_local_2 - 1] != undefined)
                  {
                     _local_1.setInfo(_canShowA[_local_2 - 1],_tipA[_local_2 - 1],_handlerFunA[_local_2 - 1]);
                  }
                  else
                  {
                     _local_1.setInfo(_canShowA[_local_2 - 1],_tipA[_local_2 - 1]);
                  }
               }
            }
            _local_2++;
         }
      }
      
      public static function show(_arg_1:Point, _arg_2:NonoInfo, _arg_3:Boolean) : void
      {
         _info = _arg_2;
         _flag = _arg_3;
         makeAry();
         if(_mainUI == null)
         {
            _mainUI = TaskIconManager.getIcon("UI_NonoShortcut") as Sprite;
            addKeyBg();
         }
         clearKeyBg();
         _bgmc = _mainUI["bgmc"];
         _bgmc.buttonMode = true;
         _mainUI.x = _arg_1.x;
         _mainUI.y = _arg_1.y;
         LevelManager.appLevel.addChild(_mainUI);
         setData();
         if(MapXMLInfo.getIsLocal(MapManager.currentMap.id) == false)
         {
            _mainUI["key2"].filters = [];
            _mainUI["key2"].mouseEnabled = true;
            _mainUI["key2"].mouseChildren = true;
         }
         else
         {
            _mainUI["key2"].filters = [ColorFilter.setGrayscale()];
            _mainUI["key2"].mouseEnabled = false;
            _mainUI["key2"].mouseChildren = false;
         }
      }
      
      public static function hide() : void
      {
         if(Boolean(_mainUI))
         {
            clearKeyBg();
            _mainUI.removeEventListener(MouseEvent.ROLL_OUT,onOut);
            DisplayUtil.removeForParent(_mainUI);
            EventManager.dispatchEvent(new RobotEvent(RobotEvent.NONO_SHORTCUT_HIDE));
         }
      }
      
      private static function onOut(_arg_1:MouseEvent) : void
      {
         hide();
      }
      
      private static function onCure() : void
      {
         if(_info.superNono)
         {
            PetManager.cureAll();
         }
         else
         {
            Alert.show("恢复体力需要花费50个骄阳豆，你确定要为你的精灵们恢复体力吗？",function():void
            {
               PetManager.cureAll();
            });
         }
         hide();
      }
      
      private static function onFollow() : void
      {
         if(_flag)
         {
            SocketConnection.send(CommandID.NONO_FOLLOW_OR_HOOM,0);
         }
         else
         {
            SocketConnection.send(CommandID.NONO_FOLLOW_OR_HOOM,1);
         }
         hide();
      }
      
      private static function onPower() : void
      {
         if(_info.chargeTime == 0)
         {
            SocketConnection.send(CommandID.NONO_CHARGE,1);
         }
         else
         {
            SocketConnection.send(CommandID.NONO_CHARGE,0);
         }
         hide();
      }
      
      private static function onjn() : void
      {
         if(_appModel == null)
         {
            _appModel = ModuleManager.getModule(ClientConfig.getAppModule("ExpAdmPanel"),"正在打开经验分配器面板...");
            _appModel.setup();
            _appModel.sharedEvents.addEventListener(Event.CLOSE,onAppCloseHandler);
         }
         _appModel.show();
         hide();
      }
      
      private static function onAppCloseHandler(_arg_1:Event) : void
      {
         _appModel.sharedEvents.removeEventListener(Event.CLOSE,onAppCloseHandler);
         _appModel.destroy();
         _appModel = null;
      }
      
      private static function onPetStorage() : void
      {
         if(_petStorage == null)
         {
            _petStorage = ModuleManager.getModule(ClientConfig.getAppModule("PetStorage"),"正在打开精灵仓库");
            _petStorage.setup();
         }
         _petStorage.show();
      }
      
      private static function onClick(_arg_1:MouseEvent) : void
      {
         if(_flag)
         {
            if(_nonoInfoPanel == null)
            {
               _nonoInfoPanel = new AppModel(ClientConfig.getAppModule("NewNonoInfoPanel"),"正在打开NoNo信息面板...");
               _nonoInfoPanel.setup();
               _nonoInfoPanel.sharedEvents.addEventListener(Event.CLOSE,onNonoInfoPanelClose);
            }
            _nonoInfoPanel.init({
               "info":_info,
               "point":null
            });
            _nonoInfoPanel.show();
         }
         else
         {
            showNoNOPanel();
         }
      }
      
      private static function showNoNOPanel() : void
      {
      }
      
      public static function onNonoPanelClose(_arg_1:Event) : void
      {
         if(Boolean(_nonoPanel))
         {
            _nonoPanel.sharedEvents.removeEventListener(Event.CLOSE,onNonoPanelClose);
            _nonoPanel.destroy();
         }
         _nonoPanel = null;
      }
      
      private static function onNonoInfoPanelClose(_arg_1:Event) : void
      {
         _nonoInfoPanel.sharedEvents.removeEventListener(Event.CLOSE,onNonoInfoPanelClose);
         _nonoInfoPanel.destroy();
         _nonoInfoPanel = null;
      }
   }
}

