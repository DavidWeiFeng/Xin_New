package gs.plugins
{
   import flash.display.*;
   import gs.*;
   
   public class FastTransformPlugin extends TweenPlugin
   {
      
      public static const VERSION:Number = 1.02;
      
      public static const API:Number = 1;
      
      protected var widthStart:Number;
      
      protected var rotationStart:Number;
      
      protected var xChange:Number = 0;
      
      protected var yChange:Number = 0;
      
      protected var xStart:Number;
      
      protected var rotationChange:Number = 0;
      
      protected var scaleYStart:Number;
      
      protected var widthChange:Number = 0;
      
      protected var scaleXChange:Number = 0;
      
      protected var scaleYChange:Number = 0;
      
      protected var yStart:Number;
      
      protected var _target:DisplayObject;
      
      protected var scaleXStart:Number;
      
      protected var heightChange:Number = 0;
      
      protected var heightStart:Number;
      
      public function FastTransformPlugin()
      {
         super();
         this.propName = "fastTransform";
         this.overwriteProps = [];
      }
      
      override public function set changeFactor(_arg_1:Number) : void
      {
         if(this.xChange != 0)
         {
            this._target.x = this.xStart + _arg_1 * this.xChange;
         }
         if(this.yChange != 0)
         {
            this._target.y = this.yStart + _arg_1 * this.yChange;
         }
         if(this.widthChange != 0)
         {
            this._target.width = this.widthStart + _arg_1 * this.widthChange;
         }
         if(this.heightChange != 0)
         {
            this._target.height = this.heightStart + _arg_1 * this.heightChange;
         }
         if(this.scaleXChange != 0)
         {
            this._target.scaleX = this.scaleXStart + _arg_1 * this.scaleXChange;
         }
         if(this.scaleYChange != 0)
         {
            this._target.scaleY = this.scaleYStart + _arg_1 * this.scaleYChange;
         }
         if(this.rotationChange != 0)
         {
            this._target.rotation = this.rotationStart + _arg_1 * this.rotationChange;
         }
      }
      
      override public function onInitTween(_arg_1:Object, _arg_2:*, _arg_3:TweenLite) : Boolean
      {
         this._target = _arg_1 as DisplayObject;
         if("x" in _arg_2)
         {
            this.xStart = this._target.x;
            this.xChange = typeof _arg_2.x == "number" ? _arg_2.x - this._target.x : Number(_arg_2.x);
            this.overwriteProps[this.overwriteProps.length] = "x";
         }
         if("y" in _arg_2)
         {
            this.yStart = this._target.y;
            this.yChange = typeof _arg_2.y == "number" ? _arg_2.y - this._target.y : Number(_arg_2.y);
            this.overwriteProps[this.overwriteProps.length] = "y";
         }
         if("width" in _arg_2)
         {
            this.widthStart = this._target.width;
            this.widthChange = typeof _arg_2.width == "number" ? _arg_2.width - this._target.width : Number(_arg_2.width);
            this.overwriteProps[this.overwriteProps.length] = "width";
         }
         if("height" in _arg_2)
         {
            this.heightStart = this._target.height;
            this.heightChange = typeof _arg_2.height == "number" ? _arg_2.height - this._target.height : Number(_arg_2.height);
            this.overwriteProps[this.overwriteProps.length] = "height";
         }
         if("scaleX" in _arg_2)
         {
            this.scaleXStart = this._target.scaleX;
            this.scaleXChange = typeof _arg_2.scaleX == "number" ? _arg_2.scaleX - this._target.scaleX : Number(_arg_2.scaleX);
            this.overwriteProps[this.overwriteProps.length] = "scaleX";
         }
         if("scaleY" in _arg_2)
         {
            this.scaleYStart = this._target.scaleY;
            this.scaleYChange = typeof _arg_2.scaleY == "number" ? _arg_2.scaleY - this._target.scaleY : Number(_arg_2.scaleY);
            this.overwriteProps[this.overwriteProps.length] = "scaleY";
         }
         if("rotation" in _arg_2)
         {
            this.rotationStart = this._target.rotation;
            this.rotationChange = typeof _arg_2.rotation == "number" ? _arg_2.rotation - this._target.rotation : Number(_arg_2.rotation);
            this.overwriteProps[this.overwriteProps.length] = "rotation";
         }
         return true;
      }
      
      override public function killProps(_arg_1:Object) : void
      {
         var _local_2:String = null;
         for(_local_2 in _arg_1)
         {
            if(_local_2 + "Change" in this && !isNaN(this[_local_2 + "Change"]))
            {
               this[_local_2 + "Change"] = 0;
            }
         }
         super.killProps(_arg_1);
      }
   }
}

