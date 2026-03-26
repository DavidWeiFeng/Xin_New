package com.robot.app.im.talk
{
   import com.robot.app.emotion.EmotionListItem;
   import com.robot.core.manager.MainManager;
   import com.robot.core.manager.UIManager;
   import flash.display.DisplayObject;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   import flash.geom.Point;
   import org.taomee.manager.PopUpManager;
   import org.taomee.utils.DisplayUtil;
   
   public class TEmotionPanel extends Sprite
   {
      
      private var _panel:Sprite;
      
      private var _userID:uint;
      
      public function TEmotionPanel(_arg_1:uint)
      {
         var _local_2:EmotionListItem = null;
         var _local_3:int = 0;
         super();
         this._userID = _arg_1;
         this._panel = UIManager.getSprite("Panel_Background_4");
         this._panel.mouseChildren = false;
         this._panel.mouseEnabled = false;
         this._panel.cacheAsBitmap = true;
         this._panel.width = 299;
         this._panel.height = 118;
         this._panel.alpha = 0.6;
         addChild(this._panel);
         while(_local_3 < 23)
         {
            _local_2 = new EmotionListItem(_local_3);
            _local_2.x = 6 + (_local_2.width + 2) * int(_local_3 / 3);
            _local_2.y = 6 + (_local_2.height + 2) * int(_local_3 % 3);
            addChild(_local_2);
            _local_2.addEventListener(MouseEvent.CLICK,this.onItemClick);
            _local_3++;
         }
      }
      
      public function show(_arg_1:DisplayObject) : void
      {
         PopUpManager.showForDisplayObject(this,_arg_1,PopUpManager.TOP_RIGHT,true,new Point(-30,0));
      }
      
      public function hide() : void
      {
         DisplayUtil.removeForParent(this);
      }
      
      private function onItemClick(_arg_1:MouseEvent) : void
      {
         var _local_2:EmotionListItem = _arg_1.currentTarget as EmotionListItem;
         MainManager.actorModel.chatAction("#" + _local_2.id,this._userID);
         this.hide();
      }
   }
}

