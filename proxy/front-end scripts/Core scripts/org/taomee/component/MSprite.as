package org.taomee.component
{
   import flash.display.DisplayObject;
   import flash.display.Shape;
   import flash.display.Sprite;
   import flash.geom.Rectangle;
   import org.taomee.component.manager.MComponentManager;
   import org.taomee.utils.DisplayUtil;
   
   public class MSprite extends Sprite
   {
      
      private var _height:Number = 0;
      
      private var _width:Number = 0;
      
      protected var containSprite:Sprite;
      
      private var isRecordH:Boolean = false;
      
      private var _isMask:Boolean = true;
      
      private var OH:Number;
      
      protected var bgMC:Sprite;
      
      private var isRecordW:Boolean = false;
      
      private var fillColor:uint = 16777215;
      
      private var _stop:Boolean = false;
      
      private var OW:Number;
      
      protected var bgMaskMC:Shape;
      
      private var maskRect:Rectangle;
      
      public function MSprite()
      {
         super();
         this.bgMaskMC = new Shape();
         this.bgMC = new Sprite();
         addChild(this.bgMC);
         if(MComponentManager.bgAlpha > 0)
         {
            addChild(this.bgMaskMC);
         }
         this.bgMC.tabEnabled = false;
         this.bgMC.mouseEnabled = false;
         this.bgMC.mouseChildren = false;
         this.bgMC.cacheAsBitmap = true;
         this.containSprite = new Sprite();
         this.containSprite.mouseEnabled = false;
         this.containSprite.cacheAsBitmap = true;
         this.addChild(this.containSprite);
         this.cacheAsBitmap = true;
         this.maskRect = new Rectangle();
         this.containSprite.scrollRect = this.maskRect;
         this.bgMC.scrollRect = scrollRect;
      }
      
      protected function revalidate() : void
      {
      }
      
      override public function getChildByName(_arg_1:String) : DisplayObject
      {
         return this.containSprite.getChildByName(_arg_1);
      }
      
      override public function getChildAt(_arg_1:int) : DisplayObject
      {
         return this.containSprite.getChildAt(_arg_1);
      }
      
      override public function set width(_arg_1:Number) : void
      {
         this._width = _arg_1;
         this.initMask();
         if(!this.isRecordW)
         {
            this.isRecordW = true;
            this.OW = _arg_1;
         }
      }
      
      public function reSize() : void
      {
         if(this.isRecordW)
         {
            this.width = this.OW;
         }
         if(this.isRecordH)
         {
            this.height = this.OH;
         }
      }
      
      override public function setChildIndex(_arg_1:DisplayObject, _arg_2:int) : void
      {
         return this.containSprite.setChildIndex(_arg_1,_arg_2);
      }
      
      override public function get width() : Number
      {
         return this._width;
      }
      
      private function initMask() : void
      {
         if(MComponentManager.bgAlpha > 0)
         {
            this.bgMaskMC.graphics.clear();
            this.bgMaskMC.graphics.beginFill(this.fillColor,MComponentManager.bgAlpha);
            this.bgMaskMC.graphics.drawRect(0,0,this._width,this._height);
            this.bgMaskMC.graphics.endFill();
         }
         this.maskRect.width = this._width;
         this.maskRect.height = this._height;
         if(this._isMask)
         {
            this.containSprite.scrollRect = this.maskRect;
            this.bgMC.scrollRect = scrollRect;
         }
         else
         {
            this.containSprite.scrollRect = null;
            this.bgMC.scrollRect = null;
         }
         this.updateView();
      }
      
      override public function getChildIndex(_arg_1:DisplayObject) : int
      {
         return this.containSprite.getChildIndex(_arg_1);
      }
      
      override public function get numChildren() : int
      {
         return this.containSprite.numChildren;
      }
      
      public function updateView() : void
      {
         if(this._stop)
         {
            this._stop = false;
            return;
         }
         this.revalidate();
         if(this.parentComp is Container)
         {
            Container(this.parentComp).updateView();
         }
      }
      
      protected function stopUpdate() : void
      {
         this._stop = true;
      }
      
      public function set isMask(_arg_1:Boolean) : void
      {
         this._isMask = _arg_1;
         if(_arg_1)
         {
            this.containSprite.scrollRect = this.maskRect;
            this.bgMC.scrollRect = scrollRect;
         }
         else
         {
            this.containSprite.scrollRect = null;
            this.bgMC.scrollRect = null;
         }
      }
      
      public function get parentComp() : UIComponent
      {
         if(Boolean(this.parent))
         {
            return this.parent.parent as UIComponent;
         }
         return null;
      }
      
      public function destroy() : void
      {
         var _local_1:DisplayObject = null;
         DisplayUtil.removeForParent(this);
         DisplayUtil.removeAllChild(this.bgMC);
         while(this.containSprite.numChildren > 0)
         {
            _local_1 = this.containSprite.getChildAt(0);
            DisplayUtil.removeForParent(_local_1);
            if(_local_1 is MSprite)
            {
               (_local_1 as MSprite).destroy();
            }
         }
         this.bgMC = null;
         this.containSprite = null;
      }
      
      override public function set height(_arg_1:Number) : void
      {
         this._height = _arg_1;
         this.initMask();
         if(!this.isRecordH)
         {
            this.isRecordH = true;
            this.OH = _arg_1;
         }
      }
      
      override public function get height() : Number
      {
         return this._height;
      }
   }
}

