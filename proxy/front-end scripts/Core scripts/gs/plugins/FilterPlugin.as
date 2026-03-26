package gs.plugins
{
   import flash.display.*;
   import flash.filters.*;
   import gs.*;
   import gs.utils.tween.*;
   
   public class FilterPlugin extends TweenPlugin
   {
      
      public static const VERSION:Number = 1.03;
      
      public static const API:Number = 1;
      
      protected var _remove:Boolean;
      
      protected var _target:Object;
      
      protected var _index:int;
      
      protected var _filter:BitmapFilter;
      
      protected var _type:Class;
      
      public function FilterPlugin()
      {
         super();
      }
      
      public function onCompleteTween() : void
      {
         var _local_1:int = 0;
         var _local_2:Array = null;
         if(this._remove)
         {
            _local_2 = this._target.filters;
            if(!(_local_2[this._index] is this._type))
            {
               _local_1 = _local_2.length - 1;
               while(_local_1 > -1)
               {
                  if(_local_2[_local_1] is this._type)
                  {
                     _local_2.splice(_local_1,1);
                     break;
                  }
                  _local_1--;
               }
            }
            else
            {
               _local_2.splice(this._index,1);
            }
            this._target.filters = _local_2;
         }
      }
      
      protected function initFilter(_arg_1:Object, _arg_2:BitmapFilter) : void
      {
         var _local_3:String = null;
         var _local_4:int = 0;
         var _local_5:HexColorsPlugin = null;
         var _local_6:Array = this._target.filters;
         this._index = -1;
         if(_arg_1.index != null)
         {
            this._index = _arg_1.index;
         }
         else
         {
            _local_4 = _local_6.length - 1;
            while(_local_4 > -1)
            {
               if(_local_6[_local_4] is this._type)
               {
                  this._index = _local_4;
                  break;
               }
               _local_4--;
            }
         }
         if(this._index == -1 || _local_6[this._index] == null || _arg_1.addFilter == true)
         {
            this._index = _arg_1.index != null ? int(_arg_1.index) : int(_local_6.length);
            _local_6[this._index] = _arg_2;
            this._target.filters = _local_6;
         }
         this._filter = _local_6[this._index];
         this._remove = Boolean(_arg_1.remove == true);
         if(this._remove)
         {
            this.onComplete = this.onCompleteTween;
         }
         var _local_7:Object = _arg_1.isTV == true ? _arg_1.exposedVars : _arg_1;
         for(_local_3 in _local_7)
         {
            if(!(!(_local_3 in this._filter) || this._filter[_local_3] == _local_7[_local_3] || _local_3 == "remove" || _local_3 == "index" || _local_3 == "addFilter"))
            {
               if(_local_3 == "color" || _local_3 == "highlightColor" || _local_3 == "shadowColor")
               {
                  _local_5 = new HexColorsPlugin();
                  _local_5.initColor(this._filter,_local_3,this._filter[_local_3],_local_7[_local_3]);
                  _tweens[_tweens.length] = new TweenInfo(_local_5,"changeFactor",0,1,_local_3,false);
               }
               else if(_local_3 == "quality" || _local_3 == "inner" || _local_3 == "knockout" || _local_3 == "hideObject")
               {
                  this._filter[_local_3] = _local_7[_local_3];
               }
               else
               {
                  addTween(this._filter,_local_3,this._filter[_local_3],_local_7[_local_3],_local_3);
               }
            }
         }
      }
      
      override public function set changeFactor(_arg_1:Number) : void
      {
         var _local_2:int = 0;
         var _local_3:TweenInfo = null;
         var _local_4:Array = this._target.filters;
         _local_2 = _tweens.length - 1;
         while(_local_2 > -1)
         {
            _local_3 = _tweens[_local_2];
            _local_3.target[_local_3.property] = _local_3.start + _local_3.change * _arg_1;
            _local_2--;
         }
         if(!(_local_4[this._index] is this._type))
         {
            this._index = _local_4.length - 1;
            _local_2 = _local_4.length - 1;
            while(_local_2 > -1)
            {
               if(_local_4[_local_2] is this._type)
               {
                  this._index = _local_2;
                  break;
               }
               _local_2--;
            }
         }
         _local_4[this._index] = this._filter;
         this._target.filters = _local_4;
      }
   }
}

