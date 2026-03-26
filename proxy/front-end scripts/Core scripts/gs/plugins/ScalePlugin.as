package gs.plugins
{
   import flash.display.*;
   import gs.*;
   
   public class ScalePlugin extends TweenPlugin
   {
      
      public static const VERSION:Number = 1.11;
      
      public static const API:Number = 1;
      
      protected var _changeX:Number;
      
      protected var _changeY:Number;
      
      protected var _target:Object;
      
      protected var _startX:Number;
      
      protected var _startY:Number;
      
      public function ScalePlugin()
      {
         super();
         this.propName = "scale";
         this.overwriteProps = ["scaleX","scaleY","width","height"];
      }
      
      override public function killProps(_arg_1:Object) : void
      {
         var _local_2:int = this.overwriteProps.length - 1;
         while(_local_2 > -1)
         {
            if(this.overwriteProps[_local_2] in _arg_1)
            {
               this.overwriteProps = [];
               return;
            }
            _local_2--;
         }
      }
      
      override public function onInitTween(_arg_1:Object, _arg_2:*, _arg_3:TweenLite) : Boolean
      {
         if(!_arg_1.hasOwnProperty("scaleX"))
         {
            return false;
         }
         this._target = _arg_1;
         this._startX = this._target.scaleX;
         this._startY = this._target.scaleY;
         if(typeof _arg_2 == "number")
         {
            this._changeX = _arg_2 - this._startX;
            this._changeY = _arg_2 - this._startY;
         }
         else
         {
            this._changeX = this._changeY = Number(_arg_2);
         }
         return true;
      }
      
      override public function set changeFactor(_arg_1:Number) : void
      {
         this._target.scaleX = this._startX + _arg_1 * this._changeX;
         this._target.scaleY = this._startY + _arg_1 * this._changeY;
      }
   }
}

