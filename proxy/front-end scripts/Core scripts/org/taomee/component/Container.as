package org.taomee.component
{
   import flash.display.Sprite;
   import org.taomee.component.event.ContainerEvent;
   import org.taomee.component.event.LayoutEvent;
   import org.taomee.component.geom.IntDimension;
   import org.taomee.component.layout.EmptyLayout;
   import org.taomee.component.layout.ILayoutManager;
   
   [Event(name="compAdded",type="org.taomee.component.event.ContainerEvent")]
   [Event(name="compRemoved",type="org.taomee.component.event.ContainerEvent")]
   public class Container extends UIComponent
   {
      
      protected var layoutManager:ILayoutManager;
      
      private var isUpdating:Boolean = false;
      
      public function Container()
      {
         super();
         this.layoutManager = new EmptyLayout();
         this.layoutManager.addEventListener(LayoutEvent.LAYOUT_SET_CHANGED,this.layoutChanged);
         this.initLayout();
      }
      
      public function append(_arg_1:UIComponent) : void
      {
         this.layoutManager.addLayoutComponent(_arg_1);
         containSprite.addChild(_arg_1);
         this.layoutManager.doLayout();
         dispatchEvent(new ContainerEvent(ContainerEvent.COMP_ADDED,_arg_1));
      }
      
      public function remove(_arg_1:UIComponent) : void
      {
         this.layoutManager.removeLayoutComponent(_arg_1);
         _arg_1.destroy();
         this.layoutManager.doLayout();
         dispatchEvent(new ContainerEvent(ContainerEvent.COMP_REMOVED,_arg_1));
      }
      
      public function appendAll(... _args) : void
      {
         var _local_2:UIComponent = null;
         for each(_local_2 in _args)
         {
            this.layoutManager.addLayoutComponent(_local_2);
            containSprite.addChild(_local_2);
            dispatchEvent(new ContainerEvent(ContainerEvent.COMP_ADDED,_local_2));
         }
         this.layoutManager.doLayout();
      }
      
      override protected function revalidate() : void
      {
         if(this.isUpdating)
         {
            return;
         }
         super.revalidate();
         this.isUpdating = true;
         this.initLayout();
      }
      
      private function layoutChanged(_arg_1:LayoutEvent) : void
      {
         this.initLayout();
      }
      
      public function set layout(_arg_1:ILayoutManager) : void
      {
         if(Boolean(this.layoutManager))
         {
            this.layoutManager.removeEventListener(LayoutEvent.LAYOUT_SET_CHANGED,this.layoutChanged);
            this.layoutManager.destroy();
         }
         if(!_arg_1)
         {
            _arg_1 = new EmptyLayout();
         }
         this.layoutManager = _arg_1;
         this.layoutManager.addEventListener(LayoutEvent.LAYOUT_SET_CHANGED,this.layoutChanged);
         this.initLayout();
      }
      
      public function appendAt(_arg_1:UIComponent, _arg_2:int) : void
      {
         containSprite.addChildAt(_arg_1,_arg_2);
         this.layoutManager.doLayout();
         dispatchEvent(new ContainerEvent(ContainerEvent.COMP_ADDED,_arg_1));
      }
      
      public function get layout() : ILayoutManager
      {
         return this.layoutManager;
      }
      
      protected function initLayout() : void
      {
         this.layoutManager.layoutObj = this;
         this.layoutManager.doLayout();
         this.isUpdating = false;
      }
      
      public function get compList() : Array
      {
         var _local_2:uint = 0;
         var _local_1:Array = [];
         while(_local_2 < containSprite.numChildren)
         {
            _local_1.push(containSprite.getChildAt(_local_2));
            _local_2++;
         }
         return _local_1;
      }
      
      override public function destroy() : void
      {
         this.layoutManager.removeEventListener(LayoutEvent.LAYOUT_SET_CHANGED,this.layoutChanged);
         this.layoutManager.destroy();
         this.layoutManager = null;
         super.destroy();
      }
      
      public function getContainSprite() : Sprite
      {
         return containSprite;
      }
      
      public function get contentSize() : IntDimension
      {
         return new IntDimension(containSprite.width,containSprite.height);
      }
      
      public function removeAll() : void
      {
         var _local_1:UIComponent = null;
         while(containSprite.numChildren > 0)
         {
            _local_1 = containSprite.getChildAt(0) as UIComponent;
            this.layoutManager.removeLayoutComponent(_local_1);
            _local_1.destroy();
            dispatchEvent(new ContainerEvent(ContainerEvent.COMP_REMOVED,_local_1));
         }
      }
   }
}

