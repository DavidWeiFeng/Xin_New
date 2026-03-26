package org.taomee.manager
{
   import flash.display.Bitmap;
   import flash.display.BitmapData;
   import flash.display.DisplayObject;
   import flash.display.InteractiveObject;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   import flash.text.TextField;
   import flash.text.TextFieldAutoSize;
   import flash.text.TextFormat;
   import org.taomee.ds.HashMap;
   import org.taomee.utils.DisplayUtil;
   
   public class ToolTipManager
   {
      
      private static var _bitmap:Bitmap;
      
      private static var _cx:Number;
      
      private static var _cy:Number;
      
      private static var _listMap:HashMap;
      
      private static var _toolTip:Sprite;
      
      private static var _bg:DisplayObject;
      
      private static var _txt:TextField;
      
      private static var tf:TextFormat;
      
      private static var _bitmapdata:BitmapData;
      
      public function ToolTipManager()
      {
         super();
      }
      
      public static function remove(_arg_1:InteractiveObject) : void
      {
         if(_listMap.containsKey(_arg_1))
         {
            _arg_1.removeEventListener(MouseEvent.ROLL_OVER,onOver);
            _arg_1.removeEventListener(MouseEvent.ROLL_OUT,onOut);
            _listMap.remove(_arg_1);
         }
         onFinishTween();
      }
      
      private static function onMove(_arg_1:MouseEvent) : void
      {
         _toolTip.x = _cx + _arg_1.stageX;
         _toolTip.y = _cy + _arg_1.stageY;
      }
      
      private static function onOver(_arg_1:MouseEvent) : void
      {
         var _local_2:InteractiveObject = _arg_1.currentTarget as InteractiveObject;
         _txt.htmlText = _listMap.getValue(_local_2);
         _txt.setTextFormat(tf);
         _bg.width = _txt.textWidth + 8;
         _bg.height = _txt.textHeight + 8;
         _bg.x = TaomeeManager.stage.mouseX + 5 + _toolTip.width < TaomeeManager.stage.stageWidth ? 0 : _toolTip.width - _txt.textWidth;
         _txt.x = _bg.x + 2;
         PopUpManager.showForMouse(_toolTip,PopUpManager.TOP_RIGHT,5,-5);
         _cx = _toolTip.x - _arg_1.stageX;
         _cy = _toolTip.y - _arg_1.stageY;
         TaomeeManager.stage.addEventListener(MouseEvent.MOUSE_MOVE,onMove);
      }
      
      public static function add(_arg_1:InteractiveObject, _arg_2:String) : void
      {
         _arg_1.addEventListener(MouseEvent.ROLL_OVER,onOver);
         _arg_1.addEventListener(MouseEvent.ROLL_OUT,onOut);
         _listMap.add(_arg_1,_arg_2);
      }
      
      private static function onOut(_arg_1:MouseEvent) : void
      {
         onFinishTween();
      }
      
      private static function onFinishTween() : void
      {
         DisplayUtil.removeForParent(_toolTip);
         TaomeeManager.stage.removeEventListener(MouseEvent.MOUSE_MOVE,onMove);
      }
      
      public static function setup(_arg_1:DisplayObject) : void
      {
         _bg = _arg_1;
         _listMap = new HashMap();
         _toolTip = new Sprite();
         _toolTip.mouseChildren = false;
         _toolTip.mouseEnabled = false;
         _toolTip.addChild(_bg);
         _txt = new TextField();
         _txt.multiline = true;
         _txt.wordWrap = true;
         _txt.autoSize = TextFieldAutoSize.LEFT;
         _txt.x = 1;
         _txt.y = 1;
         _toolTip.addChild(_txt);
         tf = new TextFormat();
      }
   }
}

