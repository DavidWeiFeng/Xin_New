package org.taomee.component.containers
{
   import com.robot.core.manager.CoreAssetsManager;
   import flash.display.DisplayObjectContainer;
   import flash.display.SimpleButton;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   import org.taomee.component.Container;
   import org.taomee.component.UIComponent;
   import org.taomee.component.bgFill.IBgFillStyle;
   import org.taomee.component.event.MEvent;
   import org.taomee.component.layout.FlowWarpLayout;
   import org.taomee.component.layout.ILayoutManager;
   import org.taomee.component.manager.MComponentManager;
   
   [Event(name="panelClosed",type="org.taomee.component.event.MEvent")]
   public class MPanel extends Container
   {
      
      private static var TOP_MARGIN:int = 50;
      
      private static var LEFT_MARGIN:int = 32;
      
      private static var BOTTOM_MARGIN:int = 22;
      
      private static var RIGHT_MARGIN:int = 32;
      
      private var dragBarClass:Class = CoreAssetsManager.getClass("MPanel_dragBarClass");
      
      private var closeBtn:SimpleButton;
      
      private var box:Container;
      
      private var closeBtnClass:Class = CoreAssetsManager.getClass("MPanel_closeBtnClass");
      
      private var owner:DisplayObjectContainer;
      
      private var titleBar:Sprite;
      
      private var titleBarClass:Class = CoreAssetsManager.getClass("MPanel_titleBarClass");
      
      private var isShowClose:Boolean;
      
      private var frameBG:Sprite;
      
      private var bgClass:Class = CoreAssetsManager.getClass("MPanel_bgClass");
      
      private var dragBar:SimpleButton;
      
      public function MPanel(_arg_1:Boolean = true, _arg_2:DisplayObjectContainer = null)
      {
         super();
         this.owner = _arg_2;
         this.isShowClose = _arg_1;
         this.box = new Container();
         this.box.x = LEFT_MARGIN;
         this.box.y = TOP_MARGIN;
         this.box.mouseEnabled = false;
         this.frameBG = new this.bgClass() as Sprite;
         this.frameBG.width = this.width;
         this.frameBG.height = this.height;
         this.frameBG.cacheAsBitmap = true;
         this.closeBtn = new this.closeBtnClass() as SimpleButton;
         this.closeBtn.tabEnabled = false;
         this.closeBtn.cacheAsBitmap = true;
         this.titleBar = new this.titleBarClass() as Sprite;
         this.titleBar.mouseEnabled = false;
         this.titleBar.y = 15;
         this.titleBar.cacheAsBitmap = true;
         this.dragBar = new this.dragBarClass() as SimpleButton;
         this.dragBar.alpha = 0;
         this.dragBar.cacheAsBitmap = true;
         addChild(this.frameBG);
         addChild(this.titleBar);
         addChild(this.box);
         addChild(this.dragBar);
         if(this.isShowClose)
         {
            addChild(this.closeBtn);
         }
         this.setCloseBtnPosition();
         this.dragBar.addEventListener(MouseEvent.MOUSE_DOWN,this.mouseDownHandler);
         this.dragBar.addEventListener(MouseEvent.MOUSE_UP,this.mouseUpHandler);
         this.closeBtn.addEventListener(MouseEvent.CLICK,this.closeHandler);
         this.layout = new FlowWarpLayout();
      }
      
      public function hide() : void
      {
         if(Boolean(this.parent))
         {
            this.parent.removeChild(this);
         }
      }
      
      override public function destroy() : void
      {
         this.titleBar = null;
         this.dragBar.removeEventListener(MouseEvent.MOUSE_DOWN,this.mouseDownHandler);
         this.dragBar.removeEventListener(MouseEvent.MOUSE_UP,this.mouseUpHandler);
         this.dragBar = null;
         removeChild(this.frameBG);
         this.frameBG.removeEventListener(MouseEvent.MOUSE_DOWN,this.mouseDownHandler);
         this.frameBG.removeEventListener(MouseEvent.MOUSE_UP,this.mouseUpHandler);
         this.frameBG = null;
         removeChild(this.box);
         this.box.destroy();
         this.box = null;
         this.owner = null;
         if(Boolean(this.parent))
         {
            this.parent.removeChild(this);
         }
         if(this.isShowClose)
         {
            removeChild(this.closeBtn);
         }
         this.closeBtn.removeEventListener(MouseEvent.CLICK,this.closeHandler);
         this.closeBtn = null;
         super.destroy();
      }
      
      private function mouseUpHandler(_arg_1:MouseEvent) : void
      {
         this.stopDrag();
      }
      
      private function setCloseBtnPosition() : void
      {
         this.titleBar.x = (this.width - this.titleBar.width) / 2;
         this.closeBtn.x = this.width - this.closeBtn.width - 16;
         this.closeBtn.y = 5;
      }
      
      public function getContentPanel() : Container
      {
         return this.box;
      }
      
      override public function set bgFillStyle(_arg_1:IBgFillStyle) : void
      {
         this.box.bgFillStyle = _arg_1;
      }
      
      override protected function revalidate() : void
      {
         this.dragBar.width = this.width;
         this.frameBG.width = this.width;
         this.frameBG.height = this.height;
         this.box.width = this.width - LEFT_MARGIN - RIGHT_MARGIN - 3;
         this.box.height = this.height - TOP_MARGIN - BOTTOM_MARGIN - 4;
         this.setCloseBtnPosition();
         super.revalidate();
      }
      
      override public function append(_arg_1:UIComponent) : void
      {
         this.box.append(_arg_1);
      }
      
      private function closeHandler(_arg_1:MouseEvent) : void
      {
         this.hide();
         dispatchEvent(new MEvent(MEvent.PANEL_CLOSED));
      }
      
      override public function set layout(_arg_1:ILayoutManager) : void
      {
         this.box.layout = _arg_1;
      }
      
      override public function appendAll(... _args) : void
      {
         var _local_2:UIComponent = null;
         for each(_local_2 in _args)
         {
            this.box.append(_local_2);
         }
      }
      
      override public function get layout() : ILayoutManager
      {
         return this.box.layout;
      }
      
      override public function appendAt(_arg_1:UIComponent, _arg_2:int) : void
      {
         this.box.appendAt(_arg_1,_arg_2);
      }
      
      private function mouseDownHandler(_arg_1:MouseEvent) : void
      {
         this.startDrag();
      }
      
      public function show() : void
      {
         if(Boolean(this.owner))
         {
            this.owner.addChild(this);
         }
         else
         {
            MComponentManager.root.addChild(this);
         }
      }
   }
}

