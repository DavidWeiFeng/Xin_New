package org.taomee.component.layout
{
   import flash.display.Sprite;
   import flash.events.EventDispatcher;
   import org.taomee.component.Container;
   import org.taomee.component.UIComponent;
   import org.taomee.component.event.LayoutEvent;
   
   [Event(name="layoutSetChanged",type="org.taomee.component.event.LayoutEvent")]
   public class EmptyLayout extends EventDispatcher implements ILayoutManager
   {
      
      private static const TYPE:String = "emptyLayout";
      
      protected var container:Container;
      
      protected var compSprite:Sprite;
      
      public function EmptyLayout()
      {
         super();
      }
      
      protected function broadcast() : void
      {
         dispatchEvent(new LayoutEvent(LayoutEvent.LAYOUT_SET_CHANGED));
      }
      
      public function destroy() : void
      {
         this.container = null;
         this.compSprite = null;
      }
      
      public function set layoutObj(_arg_1:Container) : void
      {
         this.container = _arg_1;
         this.compSprite = _arg_1.getContainSprite();
      }
      
      public function removeLayoutComponent(_arg_1:UIComponent) : void
      {
         if(!this.compSprite.contains(_arg_1))
         {
            throw new Error(_arg_1 + "不是" + this.container + "的子级，不能被移除");
         }
         this.compSprite.removeChild(_arg_1);
      }
      
      public function getType() : String
      {
         return TYPE;
      }
      
      public function doLayout() : void
      {
      }
      
      public function addLayoutComponent(_arg_1:UIComponent) : void
      {
         this.compSprite.addChild(_arg_1);
      }
   }
}

