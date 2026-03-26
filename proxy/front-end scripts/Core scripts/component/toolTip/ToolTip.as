package component.toolTip
{
   import flash.accessibility.AccessibilityProperties;
   import flash.display.DisplayObject;
   import flash.display.DisplayObjectContainer;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   import flash.geom.Point;
   import flash.text.TextField;
   import flash.text.TextFieldAutoSize;
   import flash.text.TextFormat;
   
   public class ToolTip extends Sprite
   {
      
      private static var instance:ToolTip = null;
      
      private var label:TextField;
      
      private var area:DisplayObject;
      
      public function ToolTip()
      {
         super();
         this.label = new TextField();
         this.label.autoSize = TextFieldAutoSize.LEFT;
         this.label.selectable = false;
         this.label.multiline = false;
         this.label.wordWrap = false;
         this.label.defaultTextFormat = new TextFormat("simsun",12,6710886);
         this.label.text = "提示信息";
         this.label.x = 5;
         this.label.y = 2;
         addChild(this.label);
         this.redraw();
         visible = false;
         mouseChildren = false;
         mouseEnabled = false;
      }
      
      public static function init(_arg_1:DisplayObjectContainer) : void
      {
         if(instance == null)
         {
            instance = new ToolTip();
            _arg_1.addChild(instance);
         }
      }
      
      public static function register(_arg_1:DisplayObject, _arg_2:String) : void
      {
         var _local_3:AccessibilityProperties = null;
         if(instance != null)
         {
            _local_3 = new AccessibilityProperties();
            _local_3.description = _arg_2;
            _arg_1.accessibilityProperties = _local_3;
            _arg_1.addEventListener(MouseEvent.MOUSE_OVER,instance.handler);
         }
      }
      
      public static function unregister(_arg_1:DisplayObject) : void
      {
         if(instance != null)
         {
            _arg_1.removeEventListener(MouseEvent.MOUSE_OVER,instance.handler);
         }
      }
      
      public function move(_arg_1:Point) : void
      {
         var _local_2:Point = this.parent.globalToLocal(_arg_1);
         this.x = _local_2.x - 6;
         this.y = _local_2.y - this.label.height - 12;
         if(!visible)
         {
            visible = true;
         }
      }
      
      public function hide() : void
      {
         this.area.removeEventListener(MouseEvent.MOUSE_OUT,this.handler);
         this.area.removeEventListener(MouseEvent.MOUSE_MOVE,this.handler);
         this.area = null;
         visible = false;
      }
      
      private function redraw() : void
      {
         var _local_1:Number = 10 + this.label.width;
         var _local_2:Number = 4 + this.label.height;
         this.graphics.clear();
         this.graphics.beginFill(0,0.4);
         this.graphics.drawRoundRect(3,3,_local_1,_local_2,5,5);
         this.graphics.moveTo(6,3 + _local_2);
         this.graphics.lineTo(12,3 + _local_2);
         this.graphics.lineTo(9,8 + _local_2);
         this.graphics.lineTo(6,3 + _local_2);
         this.graphics.endFill();
         this.graphics.beginFill(16777215);
         this.graphics.drawRoundRect(0,0,_local_1,_local_2,5,5);
         this.graphics.moveTo(3,_local_2);
         this.graphics.lineTo(9,_local_2);
         this.graphics.lineTo(6,5 + _local_2);
         this.graphics.lineTo(3,_local_2);
         this.graphics.endFill();
      }
      
      private function handler(_arg_1:MouseEvent) : void
      {
         switch(_arg_1.type)
         {
            case MouseEvent.MOUSE_OUT:
               this.hide();
               return;
            case MouseEvent.MOUSE_MOVE:
               this.move(new Point(_arg_1.stageX,_arg_1.stageY));
               return;
            case MouseEvent.MOUSE_OVER:
               this.show(_arg_1.target as DisplayObject);
               this.move(new Point(_arg_1.stageX,_arg_1.stageY));
         }
      }
      
      public function show(_arg_1:DisplayObject) : void
      {
         this.area = _arg_1;
         this.area.addEventListener(MouseEvent.MOUSE_OUT,this.handler);
         this.area.addEventListener(MouseEvent.MOUSE_MOVE,this.handler);
         this.label.text = _arg_1.accessibilityProperties.description;
         this.redraw();
      }
   }
}

