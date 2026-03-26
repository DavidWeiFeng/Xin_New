package org.taomee.component.tips
{
   import flash.display.InteractiveObject;
   import flash.events.MouseEvent;
   import flash.filters.DropShadowFilter;
   import flash.text.TextFormatAlign;
   import org.taomee.component.bgFill.SoildFillStyle;
   import org.taomee.component.containers.HBox;
   import org.taomee.component.control.MLabel;
   import org.taomee.component.layout.FlowLayout;
   import org.taomee.component.manager.MComponentManager;
   import org.taomee.component.manager.PopUpManager;
   import org.taomee.ds.HashMap;
   import org.taomee.utils.DisplayUtil;
   
   public class ToolTip
   {
      
      private static var box:HBox;
      
      private static var label:MLabel;
      
      private static var _cy:Number;
      
      private static var _cx:Number;
      
      private static var _listMap:HashMap;
      
      public function ToolTip()
      {
         super();
      }
      
      public static function add(_arg_1:InteractiveObject, _arg_2:String) : void
      {
         _arg_1.addEventListener(MouseEvent.ROLL_OVER,onOver);
         _arg_1.addEventListener(MouseEvent.ROLL_OUT,onOut);
         _listMap.add(_arg_1,_arg_2);
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
      
      private static function onOut(_arg_1:MouseEvent) : void
      {
         onFinishTween();
      }
      
      private static function onMove(_arg_1:MouseEvent) : void
      {
         box.x = _cx + _arg_1.stageX;
         box.y = _cy + _arg_1.stageY;
      }
      
      private static function onOver(_arg_1:MouseEvent) : void
      {
         var _local_2:InteractiveObject = _arg_1.currentTarget as InteractiveObject;
         label.htmlText = " " + _listMap.getValue(_local_2);
         box.setSizeWH(label.width + 10,label.height + 4);
         box.append(label);
         box.cacheAsBitmap = true;
         MComponentManager.stage.addChild(box);
         PopUpManager.showForMouse(box,PopUpManager.BOTTOM_RIGHT,-12,20);
         _cx = box.x - _arg_1.stageX;
         _cy = box.y - _arg_1.stageY;
         MComponentManager.stage.addEventListener(MouseEvent.MOUSE_MOVE,onMove);
      }
      
      private static function onFinishTween() : void
      {
         DisplayUtil.removeForParent(box);
         MComponentManager.stage.removeEventListener(MouseEvent.MOUSE_MOVE,onMove);
      }
      
      public static function setup() : void
      {
         _listMap = new HashMap();
         box = new HBox();
         box.filters = [new DropShadowFilter(3,45,0,0.6)];
         box.mouseChildren = false;
         box.mouseEnabled = false;
         box.valign = FlowLayout.MIDLLE;
         box.bgFillStyle = new SoildFillStyle(16116636,1,7,7);
         label = new MLabel();
         label.fontSize = 12;
         label.align = TextFormatAlign.CENTER;
         label.autoFitWidth = true;
      }
   }
}

