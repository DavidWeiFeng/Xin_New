package org.taomee.component
{
   import org.taomee.component.bgFill.IBgFillStyle;
   import org.taomee.component.event.MComponentEvent;
   import org.taomee.component.manager.IToolTipManager;
   import org.taomee.component.tips.ToolTip;
   
   [Event(name="onUpdate",type="org.taomee.component.event.MComponentEvent")]
   public class UIComponent extends MSprite implements IToolTipManager
   {
      
      private var _bgFillStyle:IBgFillStyle;
      
      public function UIComponent()
      {
         super();
      }
      
      override public function destroy() : void
      {
         if(Boolean(this._bgFillStyle))
         {
            this._bgFillStyle.clear();
         }
         this._bgFillStyle = null;
         super.destroy();
      }
      
      public function set enabled(_arg_1:Boolean) : void
      {
         this.mouseChildren = _arg_1;
         this.mouseEnabled = _arg_1;
         if(_arg_1)
         {
            this.alpha = 1;
         }
         else
         {
            this.alpha = 0.5;
         }
      }
      
      override protected function revalidate() : void
      {
         super.revalidate();
         if(Boolean(this._bgFillStyle))
         {
            this._bgFillStyle.reDraw();
         }
         dispatchEvent(new MComponentEvent(MComponentEvent.UPDATE));
      }
      
      public function setSizeWH(_arg_1:int, _arg_2:int) : void
      {
         if(_arg_1 == width && _arg_2 == height)
         {
            return;
         }
         width = _arg_1;
         height = _arg_2;
      }
      
      public function set toolTip(_arg_1:String) : void
      {
         ToolTip.add(this,_arg_1);
      }
      
      public function clearTip() : void
      {
         ToolTip.remove(this);
      }
      
      public function set bgFillStyle(_arg_1:IBgFillStyle) : void
      {
         if(_arg_1 == null)
         {
            if(Boolean(this._bgFillStyle))
            {
               this._bgFillStyle.clear();
            }
            this._bgFillStyle = null;
         }
         else
         {
            if(Boolean(this._bgFillStyle))
            {
               this._bgFillStyle.clear();
            }
            this._bgFillStyle = _arg_1;
            this._bgFillStyle.draw(bgMC);
         }
      }
   }
}

