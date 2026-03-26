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
   import flash.utils.*;
   import org.taomee.manager.*;
   import org.taomee.utils.*;
   
   public class RoomFitment
   {
      
      private var _currFitment:FitmentModel;
      
      private var _useList:Array = [];
      
      public function RoomFitment()
      {
         super();
         this.onUseFitment();
      }
      
      public function destroy() : void
      {
         var _local_1:FitmentModel = null;
         var _local_3:int = 0;
         FitmentManager.removeEventListener(FitmentEvent.ADD_TO_MAP,this.onAddMap);
         FitmentManager.removeEventListener(FitmentEvent.REMOVE_TO_MAP,this.onRemoveMap);
         FitmentManager.removeEventListener(FitmentEvent.DRAG_IN_MAP,this.onDragInMap);
         FitmentManager.destroy();
         var _local_2:int = int(this._useList.length);
         while(_local_3 < _local_2)
         {
            _local_1 = this._useList[_local_3] as FitmentModel;
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
         FitmentManager.addEventListener(FitmentEvent.ADD_TO_MAP,this.onAddMap);
         FitmentManager.addEventListener(FitmentEvent.REMOVE_TO_MAP,this.onRemoveMap);
         FitmentManager.addEventListener(FitmentEvent.DRAG_IN_MAP,this.onDragInMap);
         FitmentManager.getStorageInfo();
      }
      
      private function onDragInMap(_arg_1:FitmentEvent) : void
      {
         var _local_2:FitmentModel = null;
         for each(_local_2 in this._useList)
         {
            if(ItemXMLInfo.getIsFloor(_local_2.info.id))
            {
               _local_2.parent.addChildAt(_local_2,0);
            }
         }
      }
      
      public function openDrag() : void
      {
         this._useList.forEach(function(_arg_1:FitmentModel, _arg_2:int, _arg_3:Array):void
         {
            _arg_1.addEventListener(MouseEvent.MOUSE_DOWN,onFMDown);
            _arg_1.mouseChildren = false;
            _arg_1.buttonMode = true;
            _arg_1.dragEnabled = true;
         });
      }
      
      public function closeDrag() : void
      {
         this._useList.forEach(function(_arg_1:FitmentModel, _arg_2:int, _arg_3:Array):void
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
         var info:FitmentInfo = null;
         var fm:FitmentModel = null;
         var arr:Array = FitmentManager.getUsedList();
         for each(info in arr)
         {
            if(info.type != SolidType.FRAME)
            {
               fm = new FitmentModel();
               fm.show(info,MapManager.currentMap.depthLevel);
               this._useList.push(fm);
            }
         }
         setTimeout(function():void
         {
            var _local_1:FitmentModel = null;
            for each(_local_1 in _useList)
            {
               if(ItemXMLInfo.getIsFloor(_local_1.info.id))
               {
                  _local_1.parent.addChildAt(_local_1,0);
               }
            }
         },500);
      }
      
      private function onAddMap(_arg_1:FitmentEvent) : void
      {
         var _local_2:FitmentModel = null;
         var _local_3:FitmentModel = new FitmentModel();
         _local_3.addEventListener(MouseEvent.MOUSE_DOWN,this.onFMDown);
         _local_3.mouseChildren = false;
         _local_3.buttonMode = true;
         _local_3.dragEnabled = true;
         _local_3.show(_arg_1.info,MapManager.currentMap.depthLevel);
         this._useList.push(_local_3);
         DepthManager.swapDepth(_local_3,_local_3.y);
         for each(_local_2 in this._useList)
         {
            if(ItemXMLInfo.getIsFloor(_local_2.info.id))
            {
               _local_2.parent.addChildAt(_local_2,0);
            }
         }
      }
      
      private function onRemoveMap(_arg_1:FitmentEvent) : void
      {
         var _local_2:FitmentModel = null;
         var _local_4:int = 0;
         var _local_3:int = int(MapManager.currentMap.depthLevel.numChildren);
         while(_local_4 < _local_3)
         {
            _local_2 = MapManager.currentMap.depthLevel.getChildAt(_local_4) as FitmentModel;
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
      
      private function onFMDown(_arg_1:MouseEvent) : void
      {
         var _local_2:Point = null;
         var _local_3:FitmentModel = _arg_1.currentTarget as FitmentModel;
         var _local_4:Sprite = _local_3.content as Sprite;
         if(Boolean(_local_4))
         {
            _local_2 = new Point(_arg_1.stageX - _local_3.x,_arg_1.stageY - _local_3.y);
            FitmentManager.doDrag(_local_4,_local_3.info,_local_3,DragTargetType.MAP,_local_2);
         }
         this._currFitment = _local_3;
         this._currFitment.setSelect(true);
         this._currFitment.addEventListener(FocusEvent.FOCUS_OUT,this.onFocusOut);
      }
      
      private function onFocusOut(_arg_1:FocusEvent) : void
      {
         var _local_2:FitmentModel = _arg_1.currentTarget as FitmentModel;
         _local_2.removeEventListener(FocusEvent.FOCUS_OUT,this.onFocusOut);
         _local_2.setSelect(false);
      }
   }
}

