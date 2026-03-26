package gs.plugins
{
   import gs.*;
   import gs.utils.tween.*;
   
   public class BezierPlugin extends TweenPlugin
   {
      
      public static const VERSION:Number = 1.01;
      
      public static const API:Number = 1;
      
      protected static const _RAD2DEG:Number = 180 / Math.PI;
      
      protected var _future:Object = {};
      
      protected var _orient:Boolean;
      
      protected var _orientData:Array;
      
      protected var _target:Object;
      
      protected var _beziers:Object;
      
      public function BezierPlugin()
      {
         super();
         this.propName = "bezier";
         this.overwriteProps = [];
      }
      
      public static function parseBeziers(_arg_1:Object, _arg_2:Boolean = false) : Object
      {
         var _local_3:int = 0;
         var _local_4:Array = null;
         var _local_5:Object = null;
         var _local_6:String = null;
         var _local_7:Object = {};
         if(_arg_2)
         {
            for(_local_6 in _arg_1)
            {
               _local_4 = _arg_1[_local_6];
               _local_7[_local_6] = _local_5 = [];
               if(_local_4.length > 2)
               {
                  _local_5[_local_5.length] = [_local_4[0],_local_4[1] - (_local_4[2] - _local_4[0]) / 4,_local_4[1]];
                  _local_3 = 1;
                  while(_local_3 < _local_4.length - 1)
                  {
                     _local_5[_local_5.length] = [_local_4[_local_3],_local_4[_local_3] + (_local_4[_local_3] - _local_5[_local_3 - 1][1]),_local_4[_local_3 + 1]];
                     _local_3++;
                  }
               }
               else
               {
                  _local_5[_local_5.length] = [_local_4[0],(_local_4[0] + _local_4[1]) / 2,_local_4[1]];
               }
            }
         }
         else
         {
            for(_local_6 in _arg_1)
            {
               _local_4 = _arg_1[_local_6];
               _local_7[_local_6] = _local_5 = [];
               if(_local_4.length > 3)
               {
                  _local_5[_local_5.length] = [_local_4[0],_local_4[1],(_local_4[1] + _local_4[2]) / 2];
                  _local_3 = 2;
                  while(_local_3 < _local_4.length - 2)
                  {
                     _local_5[_local_5.length] = [_local_5[_local_3 - 2][2],_local_4[_local_3],(_local_4[_local_3] + _local_4[_local_3 + 1]) / 2];
                     _local_3++;
                  }
                  _local_5[_local_5.length] = [_local_5[_local_5.length - 1][2],_local_4[_local_4.length - 2],_local_4[_local_4.length - 1]];
               }
               else if(_local_4.length == 3)
               {
                  _local_5[_local_5.length] = [_local_4[0],_local_4[1],_local_4[2]];
               }
               else if(_local_4.length == 2)
               {
                  _local_5[_local_5.length] = [_local_4[0],(_local_4[0] + _local_4[1]) / 2,_local_4[1]];
               }
            }
         }
         return _local_7;
      }
      
      override public function killProps(_arg_1:Object) : void
      {
         var _local_2:String = null;
         for(_local_2 in this._beziers)
         {
            if(_local_2 in _arg_1)
            {
               delete this._beziers[_local_2];
            }
         }
         super.killProps(_arg_1);
      }
      
      protected function init(_arg_1:TweenLite, _arg_2:Array, _arg_3:Boolean) : void
      {
         var _local_4:int = 0;
         var _local_5:String = null;
         this._target = _arg_1.target;
         if(_arg_1.exposedVars.orientToBezier == true)
         {
            this._orientData = [["x","y","rotation",0]];
            this._orient = true;
         }
         else if(_arg_1.exposedVars.orientToBezier is Array)
         {
            this._orientData = _arg_1.exposedVars.orientToBezier;
            this._orient = true;
         }
         var _local_6:Object = {};
         _local_4 = 0;
         while(_local_4 < _arg_2.length)
         {
            for(_local_5 in _arg_2[_local_4])
            {
               if(_local_6[_local_5] == undefined)
               {
                  _local_6[_local_5] = [_arg_1.target[_local_5]];
               }
               if(typeof _arg_2[_local_4][_local_5] == "number")
               {
                  _local_6[_local_5].push(_arg_2[_local_4][_local_5]);
               }
               else
               {
                  _local_6[_local_5].push(_arg_1.target[_local_5] + Number(_arg_2[_local_4][_local_5]));
               }
            }
            _local_4++;
         }
         for(_local_5 in _local_6)
         {
            this.overwriteProps[this.overwriteProps.length] = _local_5;
            if(_arg_1.exposedVars[_local_5] != undefined)
            {
               if(typeof _arg_1.exposedVars[_local_5] == "number")
               {
                  _local_6[_local_5].push(_arg_1.exposedVars[_local_5]);
               }
               else
               {
                  _local_6[_local_5].push(_arg_1.target[_local_5] + Number(_arg_1.exposedVars[_local_5]));
               }
               delete _arg_1.exposedVars[_local_5];
               _local_4 = _arg_1.tweens.length - 1;
               while(_local_4 > -1)
               {
                  if(_arg_1.tweens[_local_4].name == _local_5)
                  {
                     _arg_1.tweens.splice(_local_4,1);
                  }
                  _local_4--;
               }
            }
         }
         this._beziers = parseBeziers(_local_6,_arg_3);
      }
      
      override public function onInitTween(_arg_1:Object, _arg_2:*, _arg_3:TweenLite) : Boolean
      {
         if(!(_arg_2 is Array))
         {
            return false;
         }
         this.init(_arg_3,_arg_2 as Array,false);
         return true;
      }
      
      override public function set changeFactor(_arg_1:Number) : void
      {
         var _local_2:int = 0;
         var _local_3:String = null;
         var _local_4:Object = null;
         var _local_6:uint = 0;
         var _local_8:int = 0;
         var _local_9:Object = null;
         var _local_10:Boolean = false;
         var _local_13:Array = null;
         var _local_5:Number = NaN;
         var _local_7:Number = NaN;
         var _local_11:Number = NaN;
         var _local_12:Number = NaN;
         var _local_14:Number = NaN;
         if(_arg_1 == 1)
         {
            for(_local_3 in this._beziers)
            {
               _local_2 = this._beziers[_local_3].length - 1;
               this._target[_local_3] = this._beziers[_local_3][_local_2][2];
            }
         }
         else
         {
            for(_local_3 in this._beziers)
            {
               _local_6 = uint(this._beziers[_local_3].length);
               if(_arg_1 < 0)
               {
                  _local_2 = 0;
               }
               else if(_arg_1 >= 1)
               {
                  _local_2 = _local_6 - 1;
               }
               else
               {
                  _local_2 = int(_local_6 * _arg_1);
               }
               _local_5 = (_arg_1 - _local_2 * (1 / _local_6)) * _local_6;
               _local_4 = this._beziers[_local_3][_local_2];
               if(this.round)
               {
                  _local_7 = _local_4[0] + _local_5 * (2 * (1 - _local_5) * (_local_4[1] - _local_4[0]) + _local_5 * (_local_4[2] - _local_4[0]));
                  _local_8 = _local_7 < 0 ? -1 : 1;
                  this._target[_local_3] = _local_7 % 1 * _local_8 > 0.5 ? int(_local_7) + _local_8 : int(_local_7);
               }
               else
               {
                  this._target[_local_3] = _local_4[0] + _local_5 * (2 * (1 - _local_5) * (_local_4[1] - _local_4[0]) + _local_5 * (_local_4[2] - _local_4[0]));
               }
            }
         }
         if(this._orient)
         {
            _local_9 = this._target;
            _local_10 = this.round;
            this._target = this._future;
            this.round = false;
            this._orient = false;
            this.changeFactor = _arg_1 + 0.01;
            this._target = _local_9;
            this.round = _local_10;
            this._orient = true;
            _local_2 = 0;
            while(_local_2 < this._orientData.length)
            {
               _local_13 = this._orientData[_local_2];
               _local_14 = Number(Number(_local_13[3]) || 0);
               _local_11 = this._future[_local_13[0]] - this._target[_local_13[0]];
               _local_12 = this._future[_local_13[1]] - this._target[_local_13[1]];
               this._target[_local_13[2]] = Math.atan2(_local_12,_local_11) * _RAD2DEG + _local_14;
               _local_2++;
            }
         }
      }
   }
}

