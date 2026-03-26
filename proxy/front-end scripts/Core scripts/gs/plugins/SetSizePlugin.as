package gs.plugins
{
   import flash.display.*;
   import gs.*;
   
   public class SetSizePlugin extends TweenPlugin
   {
      
      public static const VERSION:Number = 1.01;
      
      public static const API:Number = 1;
      
      protected var _setWidth:Boolean;
      
      public var width:Number;
      
      public var height:Number;
      
      protected var _hasSetSize:Boolean;
      
      protected var _setHeight:Boolean;
      
      protected var _target:Object;
      
      public function SetSizePlugin()
      {
         super();
         this.propName = "setSize";
         this.overwriteProps = ["setSize","width","height","scaleX","scaleY"];
         this.round = true;
      }
      
      override public function killProps(_arg_1:Object) : void
      {
         super.killProps(_arg_1);
         if(_tweens.length == 0 || "setSize" in _arg_1)
         {
            this.overwriteProps = [];
         }
      }
      
      override public function onInitTween(_arg_1:Object, _arg_2:*, _arg_3:TweenLite) : Boolean
      {
         this._target = _arg_1;
         this._hasSetSize = Boolean("setSize" in this._target);
         if("width" in _arg_2 && this._target.width != _arg_2.width)
         {
            addTween(this._hasSetSize ? this : this._target,"width",this._target.width,_arg_2.width,"width");
            this._setWidth = this._hasSetSize;
         }
         if("height" in _arg_2 && this._target.height != _arg_2.height)
         {
            addTween(this._hasSetSize ? this : this._target,"height",this._target.height,_arg_2.height,"height");
            this._setHeight = this._hasSetSize;
         }
         return true;
      }
      
      override public function set changeFactor(_arg_1:Number) : void
      {
         updateTweens(_arg_1);
         if(this._hasSetSize)
         {
            this._target.setSize(this._setWidth ? this.width : this._target.width,this._setHeight ? this.height : this._target.height);
         }
      }
   }
}

