package com.robot.app.emotion
{
   import com.robot.core.manager.MainManager;
   import com.robot.core.manager.UIManager;
   import flash.display.DisplayObject;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   import flash.geom.Point;
   import org.taomee.manager.PopUpManager;
   import org.taomee.utils.DisplayUtil;
   
   public class EmotionPanel extends Sprite
   {
      
      private var _panel:Sprite;
      
      public function EmotionPanel()
      {
         var _local_1:int = 0;
         var _local_2:EmotionListItem = null;
         super();
         this._panel = UIManager.getSprite("Panel_Background_4");
         this._panel.mouseChildren = false;
         this._panel.mouseEnabled = false;
         this._panel.cacheAsBitmap = true;
         this._panel.width = 152;
         this._panel.height = 224;
         this._panel.alpha = 0.6;
         addChild(this._panel);
         _local_1 = 0;
         while(_local_1 < 23)
         {
            _local_2 = new EmotionListItem(_local_1);
            _local_2.x = 6 + (_local_2.width + 2) * int(_local_1 % 4);
            _local_2.y = 4 + (_local_2.height + 2) * int(_local_1 / 4);
            addChild(_local_2);
            _local_2.addEventListener(MouseEvent.CLICK,this.onItemClick);
            _local_1++;
         }
      }
      
      public function show(_arg_1:DisplayObject) : void
      {
         PopUpManager.showForDisplayObject(this,_arg_1,PopUpManager.TOP_LEFT,true,new Point((width + _arg_1.width) / 2,0));
      }
      
      public function hide() : void
      {
         DisplayUtil.removeForParent(this);
      }
      
      private function onItemClick(_arg_1:MouseEvent) : void
      {
         var _local_2:EmotionListItem = _arg_1.currentTarget as EmotionListItem;
         MainManager.actorModel.chatAction("$" + _local_2.id);
         this.hide();
      }
   }
}

