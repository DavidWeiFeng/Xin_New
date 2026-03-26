package com.robot.app.sceneInteraction
{
   import com.robot.core.*;
   import com.robot.core.config.xml.*;
   import com.robot.core.event.*;
   import com.robot.core.info.team.*;
   import com.robot.core.manager.*;
   import com.robot.core.mode.*;
   import com.robot.core.net.*;
   import com.robot.core.utils.*;
   import flash.display.*;
   import flash.events.*;
   import flash.geom.*;
   import flash.utils.*;
   import org.taomee.events.SocketEvent;
   import org.taomee.manager.*;
   import org.taomee.utils.*;
   
   public class ArmShow
   {
      
      private var _currArm:ArmModel;
      
      private var _useList:Array = [];
      
      private var _upUseList:Array = [];
      
      public function ArmShow()
      {
         super();
         this.onUseArm();
         this.onUpUseArm();
         SocketConnection.addCmdListener(CommandID.ARM_UP_SET_INFO,this.onSetUpInfo);
         SocketConnection.addCmdListener(CommandID.ARM_UP_UPDATE,this.onUpUpdate);
         SocketConnection.addCmdListener(CommandID.ARM_UP_WORK,this.onUpWork);
         SocketConnection.addCmdListener(CommandID.ARM_UP_DONATE,this.onUpDonate);
      }
      
      public function destroy() : void
      {
         SocketConnection.removeCmdListener(CommandID.ARM_UP_SET_INFO,this.onSetUpInfo);
         SocketConnection.removeCmdListener(CommandID.ARM_UP_UPDATE,this.onUpUpdate);
         SocketConnection.removeCmdListener(CommandID.ARM_UP_WORK,this.onUpWork);
         SocketConnection.removeCmdListener(CommandID.ARM_UP_DONATE,this.onUpDonate);
         ArmManager.removeEventListener(ArmEvent.ADD_TO_MAP,this.onAddMap);
         ArmManager.removeEventListener(ArmEvent.REMOVE_TO_MAP,this.onRemoveMap);
         ArmManager.removeEventListener(ArmEvent.REMOVE_ALL_TO_MAP,this.onRemoveAllMap);
         ArmManager.removeEventListener(ArmEvent.UP_USED_LIST,this.onUpUseEvent);
         ArmManager.destroy();
         this._useList = this._useList.concat(this._upUseList);
         this._useList.forEach(function(_arg_1:ArmModel, _arg_2:int, _arg_3:Array):void
         {
            _arg_1.removeEventListener(MouseEvent.MOUSE_DOWN,onFMDown);
            _arg_1.destroy();
            _arg_1 = null;
         });
         this._useList = null;
         this._upUseList = null;
         if(Boolean(this._currArm))
         {
            this._currArm.removeEventListener(FocusEvent.FOCUS_OUT,this.onFocusOut);
            this._currArm = null;
         }
      }
      
      public function getAllInfoForServer() : void
      {
         ArmManager.addEventListener(ArmEvent.ADD_TO_MAP,this.onAddMap);
         ArmManager.addEventListener(ArmEvent.REMOVE_TO_MAP,this.onRemoveMap);
         ArmManager.addEventListener(ArmEvent.REMOVE_ALL_TO_MAP,this.onRemoveAllMap);
         ArmManager.getAllInfoForServer(MainManager.actorInfo.mapID);
         ArmManager.getAllInfoForServer_Up(MainManager.actorInfo.mapID);
      }
      
      public function openDrag() : void
      {
         var arr:Array = this._useList.concat(this._upUseList);
         arr.forEach(function(_arg_1:ArmModel, _arg_2:int, _arg_3:Array):void
         {
            _arg_1.addEventListener(MouseEvent.MOUSE_DOWN,onFMDown);
            _arg_1.mouseChildren = false;
            _arg_1.buttonMode = true;
            _arg_1.dragEnabled = true;
         });
      }
      
      public function closeDrag() : void
      {
         var arr:Array = this._useList.concat(this._upUseList);
         arr.forEach(function(_arg_1:ArmModel, _arg_2:int, _arg_3:Array):void
         {
            _arg_1.removeEventListener(MouseEvent.MOUSE_DOWN,onFMDown);
            _arg_1.mouseChildren = true;
            if(_arg_1.funID == 0 && _arg_1.info.form == 0)
            {
               _arg_1.buttonMode = false;
            }
            _arg_1.dragEnabled = false;
         });
      }
      
      public function addArm(_arg_1:ArmInfo) : void
      {
         var _local_2:ArmModel = null;
         _local_2 = new ArmModel();
         _local_2.mouseChildren = false;
         _local_2.buttonMode = true;
         _local_2.dragEnabled = true;
         if(_arg_1.buyTime == 0)
         {
            this._useList.push(_local_2);
         }
         else
         {
            this._upUseList.push(_local_2);
         }
         _local_2.addEventListener(MouseEvent.MOUSE_DOWN,this.onFMDown);
         _local_2.show(_arg_1,MapManager.currentMap.depthLevel);
         DepthManager.swapDepth(_local_2,_local_2.y);
      }
      
      public function removeArm(_arg_1:ArmInfo) : void
      {
         var _local_2:ArmModel = null;
         var _local_5:int = 0;
         var _local_3:DisplayObjectContainer = MapManager.currentMap.depthLevel;
         var _local_4:int = _local_3.numChildren;
         while(_local_5 < _local_4)
         {
            _local_2 = _local_3.getChildAt(_local_5) as ArmModel;
            if(Boolean(_local_2))
            {
               if(_arg_1.buyTime == 0)
               {
                  if(_local_2.info == _arg_1)
                  {
                     if(this._currArm == _local_2)
                     {
                        this._currArm.removeEventListener(FocusEvent.FOCUS_OUT,this.onFocusOut);
                        this._currArm = null;
                     }
                     ArrayUtil.removeValueFromArray(this._useList,_local_2);
                     _local_2.removeEventListener(MouseEvent.MOUSE_DOWN,this.onFMDown);
                     _local_2.destroy();
                     _local_2 = null;
                     return;
                  }
               }
               else if(_local_2.info.buyTime == _arg_1.buyTime)
               {
                  if(this._currArm == _local_2)
                  {
                     this._currArm.removeEventListener(FocusEvent.FOCUS_OUT,this.onFocusOut);
                     this._currArm = null;
                  }
                  ArrayUtil.removeValueFromArray(this._upUseList,_local_2);
                  _local_2.removeEventListener(MouseEvent.MOUSE_DOWN,this.onFMDown);
                  _local_2.destroy();
                  _local_2 = null;
                  return;
               }
            }
            _local_5++;
         }
      }
      
      private function onUseArm() : void
      {
         var _local_1:ArmInfo = null;
         var _local_2:ArmModel = null;
         this._useList = [];
         var _local_3:Array = ArmManager.getUsedList();
         for each(_local_1 in _local_3)
         {
            _local_2 = new ArmModel();
            _local_2.show(_local_1,MapManager.currentMap.depthLevel);
            this._useList.push(_local_2);
         }
      }
      
      private function onUpUseArm() : void
      {
         ArmManager.addEventListener(ArmEvent.UP_USED_LIST,this.onUpUseEvent);
         ArmManager.getUsedInfoForServer_Up(MainManager.actorInfo.mapID);
      }
      
      private function onUpUseEvent(_arg_1:ArmEvent) : void
      {
         var _local_2:ArmInfo = null;
         var _local_3:ArmModel = null;
         ArmManager.removeEventListener(ArmEvent.UP_USED_LIST,this.onUpUseEvent);
         this._upUseList = [];
         var _local_4:Array = ArmManager.getUsedList_Up();
         for each(_local_2 in _local_4)
         {
            if(_local_2.type == SolidType.HEAD)
            {
               _local_2.pos = MapXMLInfo.getHeadPos(MapManager.styleID);
            }
            _local_3 = new ArmModel();
            this._upUseList.push(_local_3);
            _local_3.show(_local_2,MapManager.currentMap.depthLevel);
         }
      }
      
      private function onAddMap(_arg_1:ArmEvent) : void
      {
         this.addArm(_arg_1.info);
      }
      
      private function onRemoveMap(_arg_1:ArmEvent) : void
      {
         this.removeArm(_arg_1.info);
      }
      
      private function onRemoveAllMap(e:ArmEvent) : void
      {
         var tempam:ArmModel = null;
         if(Boolean(this._currArm))
         {
            this._currArm.removeEventListener(FocusEvent.FOCUS_OUT,this.onFocusOut);
            this._currArm = null;
         }
         this._useList = this._useList.concat(this._upUseList);
         this._useList.forEach(function(_arg_1:ArmModel, _arg_2:int, _arg_3:Array):void
         {
            if(_arg_1.info.type != SolidType.HEAD)
            {
               _arg_1.removeEventListener(MouseEvent.MOUSE_DOWN,onFMDown);
               _arg_1.destroy();
               _arg_1 = null;
            }
            else
            {
               tempam = _arg_1;
            }
         });
         this._useList = [];
         this._upUseList = [tempam];
      }
      
      private function onFMDown(_arg_1:MouseEvent) : void
      {
         var _local_2:Point = null;
         var _local_3:ArmModel = _arg_1.currentTarget as ArmModel;
         var _local_4:Sprite = _local_3.content as Sprite;
         if(Boolean(_local_4))
         {
            if(_local_3.info.type != SolidType.HEAD)
            {
               _local_2 = new Point(_arg_1.stageX - _local_3.x,_arg_1.stageY - _local_3.y);
               ArmManager.doDrag(_local_4,_local_3.info,_local_3,DragTargetType.MAP,_local_2);
            }
         }
         this._currArm = _local_3;
         this._currArm.setSelect(true);
         this._currArm.addEventListener(FocusEvent.FOCUS_OUT,this.onFocusOut);
      }
      
      private function onFocusOut(_arg_1:FocusEvent) : void
      {
         var _local_2:ArmModel = _arg_1.currentTarget as ArmModel;
         _local_2.removeEventListener(FocusEvent.FOCUS_OUT,this.onFocusOut);
         _local_2.setSelect(false);
      }
      
      private function onSetUpInfo(_arg_1:SocketEvent) : void
      {
         var _local_2:Boolean = false;
         var _local_3:ArmModel = null;
         var _local_4:int = 0;
         var _local_11:int = 0;
         var _local_5:ByteArray = _arg_1.data as ByteArray;
         var _local_6:uint = _local_5.readUnsignedInt();
         if(_local_6 == MainManager.actorInfo.teamInfo.id)
         {
            if(MainManager.actorInfo.teamInfo.priv == 0)
            {
               return;
            }
         }
         var _local_7:uint = _local_5.readUnsignedInt();
         var _local_8:Array = this._upUseList.slice();
         var _local_9:int = int(_local_8.length);
         var _local_10:ArmInfo = new ArmInfo();
         while(_local_11 < _local_7)
         {
            _local_2 = false;
            ArmInfo.setFor2964(_local_10,_local_5);
            _local_4 = 0;
            while(_local_4 < _local_9)
            {
               _local_3 = _local_8[_local_4];
               if(_local_10.buyTime == _local_3.info.buyTime)
               {
                  _local_2 = true;
                  if(_local_10.id != 1)
                  {
                     _local_3.setBufForInfo(_local_10);
                  }
                  _local_8.splice(_local_4,1);
                  _local_9 = int(_local_8.length);
                  break;
               }
               _local_4++;
            }
            if(!_local_2)
            {
               this.addArm(_local_10);
            }
            _local_11++;
         }
         if(_local_8.length > 0)
         {
            for each(_local_3 in _local_8)
            {
               if(_local_3.info.buyTime == 0)
               {
                  ArrayUtil.removeValueFromArray(this._useList,_local_3);
               }
               else
               {
                  ArrayUtil.removeValueFromArray(this._upUseList,_local_3);
               }
               if(this._currArm == _local_3)
               {
                  this._currArm.removeEventListener(FocusEvent.FOCUS_OUT,this.onFocusOut);
                  this._currArm = null;
               }
               _local_3.removeEventListener(MouseEvent.MOUSE_DOWN,this.onFMDown);
               _local_3.destroy();
               _local_3 = null;
            }
            _local_8 = null;
         }
      }
      
      private function onUpUpdate(_arg_1:SocketEvent) : void
      {
         var _local_2:ArmModel = null;
         var _local_3:ByteArray = _arg_1.data as ByteArray;
         var _local_4:uint = _local_3.readUnsignedInt();
         var _local_5:uint = _local_3.readUnsignedInt();
         var _local_6:uint = _local_3.readUnsignedInt();
         for each(_local_2 in this._upUseList)
         {
            if(_local_2.info.buyTime == _local_4)
            {
               _local_2.setFormUpDate(_local_6);
               _local_2.info.workCount = 0;
               _local_2.info.donateCount = 0;
               _local_2.info.res.clear();
               _local_2.info.resNum = 0;
               break;
            }
         }
      }
      
      private function onUpWork(_arg_1:SocketEvent) : void
      {
         var _local_2:ArmModel = null;
         var _local_3:WorkInfo = _arg_1.data as WorkInfo;
         if(_local_3.resID == 400050)
         {
            for each(_local_2 in this._upUseList)
            {
               if(_local_2.info.buyTime == _local_3.buyTime)
               {
                  _local_2.setWork(_local_3.workCount,_local_3.totalRes);
                  break;
               }
            }
         }
      }
      
      private function onUpDonate(_arg_1:SocketEvent) : void
      {
         var _local_2:ArmModel = null;
         var _local_3:DonateInfo = _arg_1.data as DonateInfo;
         for each(_local_2 in this._upUseList)
         {
            if(_local_2.info.buyTime == _local_3.buyTime)
            {
               _local_2.info.donateCount = _local_3.donateCount;
               _local_2.info.resNum = _local_3.totalRes;
               break;
            }
         }
      }
   }
}

