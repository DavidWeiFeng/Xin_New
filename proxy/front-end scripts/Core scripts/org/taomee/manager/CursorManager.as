package org.taomee.manager
{
   import flash.display.DisplayObject;
   import flash.display.DisplayObjectContainer;
   import flash.display.InteractiveObject;
   import flash.events.MouseEvent;
   import flash.geom.Point;
   import flash.ui.Mouse;
   import org.taomee.utils.DisplayUtil;
   
   public class CursorManager
   {
      
      private static var _offset:Point;
      
      private static var _cursor:DisplayObject;
      
      private static var _root:DisplayObjectContainer = TaomeeManager.stage;
      
      public function CursorManager()
      {
         super();
         throw new Error("not constructor");
      }
      
      public static function destroy() : void
      {
         if(Boolean(_cursor))
         {
            removeCursor();
         }
      }
      
      public static function init(_arg_1:DisplayObjectContainer) : void
      {
         _root = _arg_1;
      }
      
      private static function onMouseMove(_arg_1:MouseEvent) : void
      {
         _cursor.x = _root.mouseX + _offset.x;
         _cursor.y = _root.mouseY + _offset.y;
         _arg_1.updateAfterEvent();
      }
      
      public static function setCursor(_arg_1:DisplayObject, _arg_2:Point = null, _arg_3:Boolean = true) : void
      {
         if(!_root)
         {
            throw new Error("not root");
         }
         if(Boolean(_cursor))
         {
            removeCursor();
         }
         if(_arg_3)
         {
            Mouse.hide();
         }
         _cursor = _arg_1;
         if(_cursor is InteractiveObject)
         {
            InteractiveObject(_cursor).mouseEnabled = false;
            if(_cursor is DisplayObjectContainer)
            {
               DisplayObjectContainer(_cursor).mouseChildren = false;
            }
         }
         if(_arg_2 == null)
         {
            _arg_2 = new Point();
         }
         _offset = _arg_2;
         _cursor.x = _root.mouseX + _offset.x;
         _cursor.y = _root.mouseY + _offset.y;
         _root.addChild(_cursor);
         _root.addEventListener(MouseEvent.MOUSE_MOVE,onMouseMove);
      }
      
      public static function removeCursor() : void
      {
         if(!_cursor)
         {
            return;
         }
         _root.removeEventListener(MouseEvent.MOUSE_MOVE,onMouseMove);
         DisplayUtil.removeForParent(_cursor);
         _cursor = null;
         Mouse.show();
      }
      
      public static function bringToFront() : void
      {
         if(Boolean(_cursor))
         {
            _root.addChild(_cursor);
         }
      }
   }
}

