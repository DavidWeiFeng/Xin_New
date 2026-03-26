package org.taomee.component.control
{
   import flash.display.DisplayObject;
   import org.taomee.component.UIComponent;
   
   public class UIMovieClip extends UIComponent
   {
      
      public function UIMovieClip(_arg_1:DisplayObject = null)
      {
         super();
         bgMC.mouseChildren = true;
         if(Boolean(_arg_1))
         {
            this.append(_arg_1);
         }
      }
      
      override public function get numChildren() : int
      {
         return bgMC.numChildren;
      }
      
      override public function get width() : Number
      {
         return bgMC.width;
      }
      
      override public function get height() : Number
      {
         return bgMC.height;
      }
      
      override public function getChildByName(_arg_1:String) : DisplayObject
      {
         return bgMC.getChildByName(_arg_1);
      }
      
      override public function getChildAt(_arg_1:int) : DisplayObject
      {
         return bgMC.getChildAt(_arg_1);
      }
      
      public function append(_arg_1:DisplayObject) : DisplayObject
      {
         bgMC.addChild(_arg_1);
         return _arg_1;
      }
      
      override public function getChildIndex(_arg_1:DisplayObject) : int
      {
         return bgMC.getChildIndex(_arg_1);
      }
      
      override public function set width(_arg_1:Number) : void
      {
         bgMC.width = _arg_1;
      }
      
      public function appendAt(_arg_1:DisplayObject, _arg_2:int) : DisplayObject
      {
         bgMC.addChildAt(_arg_1,_arg_2);
         return _arg_1;
      }
      
      override public function set height(_arg_1:Number) : void
      {
         bgMC.height = _arg_1;
      }
      
      override public function setChildIndex(_arg_1:DisplayObject, _arg_2:int) : void
      {
         return bgMC.setChildIndex(_arg_1,_arg_2);
      }
   }
}

