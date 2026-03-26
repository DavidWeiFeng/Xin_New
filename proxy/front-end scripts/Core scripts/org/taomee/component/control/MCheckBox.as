package org.taomee.component.control
{
   import com.robot.core.manager.CoreAssetsManager;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.text.TextFormatAlign;
   import org.taomee.utils.DisplayUtil;
   
   public class MCheckBox extends MButton
   {
      
      private var isInitUI:Boolean = false;
      
      protected var selectedBox:Sprite;
      
      private var labelEmptyCls:Class = CoreAssetsManager.getClass("MCheckBox_labelEmptyCls");
      
      protected var _selected:Boolean = false;
      
      private var labelSelectedCls:Class = CoreAssetsManager.getClass("MCheckBox_labelSelectedCls");
      
      protected var gap:uint = 4;
      
      protected var emptyBox:Sprite;
      
      public function MCheckBox(_arg_1:String = "CheckBox")
      {
         super(_arg_1);
         offSetY = 0;
      }
      
      override protected function initUI() : void
      {
         bg = new MovieClip();
         _label.blod = false;
         _label.align = TextFormatAlign.LEFT;
         _label.textField.filters = [];
         _label.textColor = 0;
         containSprite.mouseChildren = false;
         containSprite.mouseEnabled = false;
         this.emptyBox = new this.labelEmptyCls() as Sprite;
         this.selectedBox = new this.labelSelectedCls() as Sprite;
         containSprite.addChild(this.emptyBox);
         label.x = this.emptyBox.width + this.gap;
         containSprite.addChild(label);
         this.emptyBox.y = this.selectedBox.y = (containSprite.height - this.emptyBox.height) / 2;
         label.y = (containSprite.height - label.textField.textHeight) / 2;
         this.isInitUI = true;
         setSizeWH(containSprite.width,containSprite.height);
      }
      
      public function set selected(_arg_1:Boolean) : void
      {
         this._selected = _arg_1;
         if(this._selected)
         {
            containSprite.addChild(this.selectedBox);
            DisplayUtil.removeForParent(this.emptyBox);
         }
         else
         {
            containSprite.addChild(this.emptyBox);
            DisplayUtil.removeForParent(this.selectedBox);
         }
      }
      
      override protected function release() : void
      {
         this.selected = !this.selected;
         super.release();
      }
      
      override protected function revalidate() : void
      {
         if(!this.isInitUI)
         {
            return;
         }
         super.revalidate();
         this.emptyBox.y = this.selectedBox.y = (containSprite.height - this.emptyBox.height) / 2;
         label.y = (containSprite.height - label.textField.textHeight) / 2;
      }
      
      public function get selected() : Boolean
      {
         return this._selected;
      }
      
      override public function set width(_arg_1:Number) : void
      {
         super.width = _arg_1;
         label.width = _arg_1 - this.emptyBox.width - this.gap;
      }
   }
}

