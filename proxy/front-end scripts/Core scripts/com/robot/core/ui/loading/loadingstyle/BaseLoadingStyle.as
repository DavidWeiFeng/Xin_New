package com.robot.core.ui.loading.loadingstyle
{
   import com.robot.core.event.*;
   import com.robot.core.manager.*;
   import flash.display.*;
   import flash.events.*;
   import org.taomee.utils.*;
   
   [Event(name="closeLoading",type="com.event.LoadingEvent")]
   public class BaseLoadingStyle extends EventDispatcher implements ILoadingStyle
   {
      
      private static const KEY:String = "baseLoading";
      
      protected var loadingMC:MovieClip;
      
      protected var parentMC:DisplayObjectContainer;
      
      protected var percent:Number;
      
      protected var isShowCloseBtn:Boolean;
      
      private var closeBtn:InteractiveObject;
      
      public function BaseLoadingStyle(_arg_1:DisplayObjectContainer = null, _arg_2:Boolean = false)
      {
         super();
         this.isShowCloseBtn = _arg_2;
         this.parentMC = _arg_1;
         this.loadingMC = LoadingManager.getMovieClip(this.getKey());
         this.closeBtn = this.loadingMC["closeBtn"];
         this.initPosition();
         this.checkIsShowCloseBtn();
      }
      
      protected function initPosition() : void
      {
         var _local_1:Number = NaN;
         var _local_2:Number = NaN;
         if(this.parentMC == null)
         {
            this.parentMC = MainManager.getStage();
            _local_1 = MainManager.getStageWidth();
            _local_2 = MainManager.getStageHeight();
         }
         else
         {
            _local_1 = MainManager.getStageWidth();
            _local_2 = MainManager.getStageHeight();
         }
         this.loadingMC.x = (_local_1 - this.loadingMC.width) / 2;
         this.loadingMC.y = (_local_2 - this.loadingMC.height) / 2;
         if(Boolean(this.parentMC))
         {
            this.parentMC.addChild(this.loadingMC);
         }
      }
      
      protected function checkIsShowCloseBtn() : void
      {
         if(this.closeBtn != null)
         {
            if(this.closeBtn is Sprite)
            {
               Sprite(this.closeBtn).buttonMode = true;
            }
            this.closeBtn.visible = this.isShowCloseBtn;
            this.closeBtn.addEventListener(MouseEvent.CLICK,this.closeHandler);
         }
      }
      
      public function changePercent(_arg_1:Number, _arg_2:Number) : void
      {
         this.percent = Math.floor(_arg_2 / _arg_1 * 100);
      }
      
      private function closeHandler(_arg_1:MouseEvent) : void
      {
         dispatchEvent(new RobotEvent(RobotEvent.CLOSE_LOADING));
      }
      
      public function show() : void
      {
         if(Boolean(this.parentMC))
         {
            this.parentMC.addChild(this.loadingMC);
         }
      }
      
      public function close() : void
      {
         DisplayUtil.removeForParent(this.loadingMC);
      }
      
      public function destroy() : void
      {
         if(this.closeBtn != null)
         {
            this.closeBtn.removeEventListener(MouseEvent.CLICK,this.closeHandler);
            this.closeBtn = null;
         }
         DisplayUtil.removeForParent(this.loadingMC);
         this.loadingMC = null;
         this.parentMC = null;
      }
      
      public function getLoadingMC() : DisplayObject
      {
         return this.loadingMC;
      }
      
      public function getParentMC() : DisplayObjectContainer
      {
         return this.parentMC;
      }
      
      public function setIsShowCloseBtn(_arg_1:Boolean) : void
      {
         this.isShowCloseBtn = _arg_1;
         this.checkIsShowCloseBtn();
      }
      
      public function setTitle(_arg_1:String) : void
      {
      }
      
      protected function getKey() : String
      {
         return KEY;
      }
   }
}

