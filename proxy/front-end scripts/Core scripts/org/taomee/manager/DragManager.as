package org.taomee.manager
{
   import flash.display.InteractiveObject;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   import org.taomee.ds.HashMap;
   
   public class DragManager
   {
      
      private static var _collectionMap:HashMap = new HashMap();
      
      public function DragManager()
      {
         super();
      }
      
      public static function add(_arg_1:InteractiveObject, _arg_2:Sprite) : void
      {
         if(_arg_1 is Sprite)
         {
            (_arg_1 as Sprite).buttonMode = true;
         }
         _arg_1.addEventListener(MouseEvent.MOUSE_DOWN,onMouseDownHandler);
         _arg_1.addEventListener(MouseEvent.MOUSE_UP,onMouseUpHandler);
         _collectionMap.add(_arg_1,_arg_2);
      }
      
      public static function remove(_arg_1:InteractiveObject) : void
      {
         _arg_1.removeEventListener(MouseEvent.MOUSE_DOWN,onMouseDownHandler);
         _arg_1.removeEventListener(MouseEvent.MOUSE_UP,onMouseUpHandler);
         var _local_2:Sprite = _collectionMap.getValue(_arg_1) as Sprite;
         if(Boolean(_local_2))
         {
            _collectionMap.remove(_arg_1);
            _local_2 = null;
         }
      }
      
      private static function onMouseUpHandler(_arg_1:MouseEvent) : void
      {
         var _local_2:Sprite = _collectionMap.getValue(_arg_1.currentTarget as InteractiveObject) as Sprite;
         if(Boolean(_local_2))
         {
            _local_2.stopDrag();
         }
      }
      
      private static function onMouseDownHandler(_arg_1:MouseEvent) : void
      {
         var _local_2:Sprite = _collectionMap.getValue(_arg_1.currentTarget as InteractiveObject) as Sprite;
         if(Boolean(_local_2))
         {
            DepthManager.bringToTop(_local_2);
            _local_2.startDrag();
         }
      }
   }
}

