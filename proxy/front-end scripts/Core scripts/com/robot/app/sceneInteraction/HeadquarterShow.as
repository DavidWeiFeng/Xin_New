package com.robot.app.sceneInteraction
{
   import com.robot.core.config.xml.*;
   import com.robot.core.event.*;
   import com.robot.core.info.FitmentInfo;
   import com.robot.core.manager.*;
   import com.robot.core.mode.*;
   import com.robot.core.utils.*;
   import flash.display.*;
   import flash.events.*;
   import flash.geom.*;
   import org.taomee.manager.*;
   import org.taomee.utils.*;
   
   public class HeadquarterShow
   {
      
      private var _currFitment:HeadquarterModel;
      
      private var _useList:Array = [];
      
      public function HeadquarterShow()
      {
         super();
         this.onUseFitment();
      }
      
      public function destroy() : void
      {
         var _local_1:HeadquarterModel = null;
         var _local_3:int = 0;
         HeadquarterManager.removeEventListener(FitmentEvent.ADD_TO_MAP,this.onAddMap);
         HeadquarterManager.removeEventListener(FitmentEvent.REMOVE_TO_MAP,this.onRemoveMap);
         HeadquarterManager.removeEventListener(FitmentEvent.REMOVE_ALL_TO_MAP,this.onRemoveAllMap);
         HeadquarterManager.destroy();
         var _local_2:int = int(this._useList.length);
         while(_local_3 < _local_2)
         {
            _local_1 = this._useList[_local_3] as HeadquarterModel;
            if(Boolean(_local_1))
            {
               _local_1.removeEventListener(MouseEvent.MOUSE_DOWN,this.onFMDown);
               _local_1.destroy();
               _local_1 = null;
            }
            _local_3++;
         }
         this._useList = null;
         if(Boolean(this._currFitment))
         {
            this._currFitment.removeEventListener(FocusEvent.FOCUS_OUT,this.onFocusOut);
            this._currFitment = null;
         }
      }
      
      public function getStorageInfo() : void
      {
         HeadquarterManager.addEventListener(FitmentEvent.ADD_TO_MAP,this.onAddMap);
         HeadquarterManager.addEventListener(FitmentEvent.REMOVE_TO_MAP,this.onRemoveMap);
         HeadquarterManager.addEventListener(FitmentEvent.REMOVE_ALL_TO_MAP,this.onRemoveAllMap);
         HeadquarterManager.getStorageInfo(MainManager.actorInfo.mapID);
      }
      
      public function openDrag() : void
      {
         this._useList.forEach(function(_arg_1:HeadquarterModel, _arg_2:int, _arg_3:Array):void
         {
            _arg_1.addEventListener(MouseEvent.MOUSE_DOWN,onFMDown);
            _arg_1.mouseChildren = false;
            _arg_1.buttonMode = true;
            _arg_1.dragEnabled = true;
         });
      }
      
      public function closeDrag() : void
      {
         this._useList.forEach(function(_arg_1:HeadquarterModel, _arg_2:int, _arg_3:Array):void
         {
            _arg_1.removeEventListener(MouseEvent.MOUSE_DOWN,onFMDown);
            _arg_1.mouseChildren = true;
            if(_arg_1.funID == 0)
            {
               _arg_1.buttonMode = false;
            }
            _arg_1.dragEnabled = false;
         });
      }
      
      private function onUseFitment() : void
      {
         var _local_1:FitmentInfo = null;
         var _local_2:HeadquarterModel = null;
         var _local_3:Array = HeadquarterManager.getUsedList();
         for each(_local_1 in _local_3)
         {
            if(_local_1.type != SolidType.FRAME)
            {
               if(_local_1.isFixed)
               {
                  _local_1.pos = MapXMLInfo.getHeadPos(MapManager.styleID);
               }
               _local_2 = new HeadquarterModel();
               _local_2.show(_local_1,MapManager.currentMap.depthLevel);
               this._useList.push(_local_2);
            }
         }
      }
      
      private function onAddMap(_arg_1:FitmentEvent) : void
      {
         var _local_2:HeadquarterModel = new HeadquarterModel();
         _local_2.addEventListener(MouseEvent.MOUSE_DOWN,this.onFMDown);
         _local_2.mouseChildren = false;
         _local_2.buttonMode = true;
         _local_2.dragEnabled = true;
         _local_2.show(_arg_1.info,MapManager.currentMap.depthLevel);
         this._useList.push(_local_2);
         DepthManager.swapDepth(_local_2,_local_2.y);
      }
      
      private function onRemoveMap(_arg_1:FitmentEvent) : void
      {
         var _local_2:HeadquarterModel = null;
         var _local_4:int = 0;
         var _local_3:int = int(MapManager.currentMap.depthLevel.numChildren);
         while(_local_4 < _local_3)
         {
            _local_2 = MapManager.currentMap.depthLevel.getChildAt(_local_4) as HeadquarterModel;
            if(Boolean(_local_2))
            {
               if(_local_2.info == _arg_1.info)
               {
                  if(this._currFitment == _local_2)
                  {
                     this._currFitment.removeEventListener(FocusEvent.FOCUS_OUT,this.onFocusOut);
                     this._currFitment = null;
                  }
                  ArrayUtil.removeValueFromArray(this._useList,_local_2);
                  _local_2.removeEventListener(MouseEvent.MOUSE_DOWN,this.onFMDown);
                  _local_2.destroy();
                  _local_2 = null;
                  return;
               }
            }
            _local_4++;
         }
      }
      
      private function onRemoveAllMap(e:FitmentEvent) : void
      {
         if(Boolean(this._currFitment))
         {
            this._currFitment.removeEventListener(FocusEvent.FOCUS_OUT,this.onFocusOut);
            this._currFitment = null;
         }
         this._useList.forEach(function(_arg_1:HeadquarterModel, _arg_2:int, _arg_3:Array):void
         {
            _arg_1.removeEventListener(MouseEvent.MOUSE_DOWN,onFMDown);
            _arg_1.destroy();
            _arg_1 = null;
         });
         this._useList = [];
      }
      
      private function onFMDown(_arg_1:MouseEvent) : void
      {
         var _local_2:Point = null;
         var _local_3:HeadquarterModel = _arg_1.currentTarget as HeadquarterModel;
         var _local_4:Sprite = _local_3.content as Sprite;
         if(Boolean(_local_4))
         {
            _local_2 = new Point(_arg_1.stageX - _local_3.x,_arg_1.stageY - _local_3.y);
            HeadquarterManager.doDrag(_local_4,_local_3.info,_local_3,DragTargetType.MAP,_local_2);
         }
         this._currFitment = _local_3;
         this._currFitment.setSelect(true);
         this._currFitment.addEventListener(FocusEvent.FOCUS_OUT,this.onFocusOut);
      }
      
      private function onFocusOut(_arg_1:FocusEvent) : void
      {
         var _local_2:HeadquarterModel = _arg_1.currentTarget as HeadquarterModel;
         _local_2.removeEventListener(FocusEvent.FOCUS_OUT,this.onFocusOut);
         _local_2.setSelect(false);
      }
   }
}

