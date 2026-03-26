package org.taomee.data
{
   import flash.events.EventDispatcher;
   import flash.events.IEventDispatcher;
   
   [Event(name="preDataChange",type="fl.events.DataChangeEvent")]
   [Event(name="dataChange",type="fl.events.DataChangeEvent")]
   public class ArrayProvider extends EventDispatcher
   {
      
      private var _data:Array = [];
      
      public var autoUpdate:Boolean = true;
      
      public function ArrayProvider(_arg_1:Array = null)
      {
         super();
         if(Boolean(_arg_1))
         {
            this._data = _arg_1.concat();
         }
      }
      
      protected function dispatchPreChangeEvent(_arg_1:String, _arg_2:Array, _arg_3:int = -1, _arg_4:int = -1) : void
      {
         if(!this.autoUpdate)
         {
            return;
         }
         if(hasEventListener(DataChangeEvent.PRE_DATA_CHANGE))
         {
            dispatchEvent(new DataChangeEvent(DataChangeEvent.PRE_DATA_CHANGE,_arg_1,_arg_2,_arg_3,_arg_4));
         }
      }
      
      public function shift() : *
      {
         var _local_1:* = this._data.shift();
         this.dispatchChangeEvent(DataChangeType.REMOVE,[_local_1],0,0);
         return _local_1;
      }
      
      public function dispatchSelectMulti(_arg_1:IEventDispatcher, _arg_2:Array) : void
      {
         var _local_3:int = this._data.length - 1;
         this._data.splice(_local_3,0,_arg_2);
         _arg_1.dispatchEvent(new DataChangeEvent(DataChangeEvent.DATA_CHANGE,DataChangeType.SELECT,_arg_2,_local_3,this._data.length - 1));
      }
      
      public function remove(_arg_1:*) : *
      {
         var _local_2:int = int(this._data.indexOf(_arg_1));
         if(_local_2 != -1)
         {
            return this.removeAt(_local_2)[0];
         }
         return null;
      }
      
      public function getItemIndex(_arg_1:*) : int
      {
         return this._data.indexOf(_arg_1);
      }
      
      public function removeAll() : void
      {
         var _local_1:Array = this._data.concat();
         this._data = [];
         this.dispatchChangeEvent(DataChangeType.REMOVE_ALL,_local_1,0,_local_1.length - 1);
      }
      
      public function pop() : *
      {
         var _local_1:* = this._data.pop();
         var _local_2:int = int(this._data.length);
         this.dispatchChangeEvent(DataChangeType.REMOVE,[_local_1],_local_2,_local_2);
         return _local_1;
      }
      
      public function removeMulti(items:Array) : Array
      {
         var arr:Array = null;
         arr = null;
         arr = [];
         this._data = this._data.filter(function(_arg_1:*, _arg_2:int, _arg_3:Array):Boolean
         {
            if(items.indexOf(_arg_1) == -1)
            {
               return true;
            }
            arr.push(_arg_1);
            return false;
         },this);
         if(arr.length > 0)
         {
            this.dispatchChangeEvent(DataChangeType.REMOVE,arr.concat(),0,arr.length - 1);
         }
         return arr;
      }
      
      public function dispatchSelect(_arg_1:IEventDispatcher, _arg_2:*) : void
      {
         var _local_3:int = int(this._data.push(_arg_2));
         _arg_1.dispatchEvent(new DataChangeEvent(DataChangeEvent.DATA_CHANGE,DataChangeType.SELECT,[_arg_2],_local_3,_local_3));
      }
      
      public function removeAt(_arg_1:uint, _arg_2:uint = 1) : Array
      {
         this.checkIndex(_arg_1);
         var _local_3:Array = this._data.splice(_arg_1,_arg_2);
         this.dispatchChangeEvent(DataChangeType.REMOVE,_local_3.concat(),_arg_1,_arg_1 + _local_3.length - 1);
         return _local_3;
      }
      
      public function swapItemAt(_arg_1:*, _arg_2:*) : void
      {
         var _local_3:int = int(this._data.indexOf(_arg_1));
         if(_local_3 == -1)
         {
            return;
         }
         var _local_4:int = int(this._data.indexOf(_arg_2));
         if(_local_4 == -1)
         {
            return;
         }
         this.swapIndexAt(_local_3,_local_4);
      }
      
      public function removeForProperty(p:String, value:*) : *
      {
         var _index:int = 0;
         var _item:* = undefined;
         var b:Boolean = Boolean(this._data.some(function(_arg_1:*, _arg_2:int, _arg_3:Array):Boolean
         {
            if(_arg_1[p] == value)
            {
               _item = _arg_1;
               _index = _arg_2;
               return true;
            }
            return false;
         },this));
         if(b)
         {
            this.dispatchChangeEvent(DataChangeType.REMOVE,[_item],_index,_index);
         }
         return _item;
      }
      
      public function refresh() : void
      {
         this.dispatchChangeEvent(DataChangeType.RESET,this._data.concat(),0,this._data.length - 1);
      }
      
      public function getItemAt(_arg_1:uint) : *
      {
         this.checkIndex(_arg_1);
         return this._data[_arg_1];
      }
      
      public function sortOn(_arg_1:Object, _arg_2:Object = null) : Array
      {
         this.dispatchPreChangeEvent(DataChangeType.SORT,this._data.concat(),0,this._data.length - 1);
         var _local_3:Array = this._data.sortOn(_arg_1,_arg_2);
         this.dispatchChangeEvent(DataChangeType.SORT,this._data.concat(),0,this._data.length - 1);
         return _local_3;
      }
      
      public function sort(... _args) : Array
      {
         this.dispatchPreChangeEvent(DataChangeType.SORT,this._data.concat(),0,this._data.length - 1);
         var _local_2:Array = this._data.sort(_args);
         this.dispatchChangeEvent(DataChangeType.SORT,this._data.concat(),0,this._data.length - 1);
         return _local_2;
      }
      
      public function contains(_arg_1:*) : Boolean
      {
         if(this._data.indexOf(_arg_1) == -1)
         {
            return false;
         }
         return true;
      }
      
      public function add(_arg_1:*) : void
      {
         var _local_2:int = int(this._data.push(_arg_1));
         this.dispatchChangeEvent(DataChangeType.ADD,[_arg_1],_local_2,_local_2);
      }
      
      public function every(_arg_1:Function, _arg_2:* = null) : Boolean
      {
         return this._data.every(_arg_1,_arg_2);
      }
      
      public function upDateItem(_arg_1:*, _arg_2:*) : *
      {
         var _local_3:int = int(this._data.indexOf(_arg_1));
         if(_local_3 != -1)
         {
            return this.upDateItemAt(_local_3,_arg_2);
         }
         return null;
      }
      
      public function toArray() : Array
      {
         return this._data.concat();
      }
      
      public function get length() : uint
      {
         return this._data.length;
      }
      
      public function addMulti(_arg_1:Array) : void
      {
         this.addMultiAt(_arg_1,this._data.length - 1);
      }
      
      public function setItemIndexAt(_arg_1:int, _arg_2:int) : void
      {
         this.checkIndex(_arg_1);
         this.checkIndex(_arg_2);
         var _local_3:Array = this._data.splice(_arg_1,1);
         this._data.splice(_arg_2,0,_local_3);
         this.dispatchChangeEvent(DataChangeType.MOVE,_local_3,_arg_1,_arg_2);
      }
      
      public function removeMultiForProperty(p:String, value:*) : Array
      {
         var arr:Array = null;
         arr = null;
         arr = [];
         this._data = this._data.filter(function(_arg_1:*, _arg_2:int, _arg_3:Array):Boolean
         {
            if(_arg_1[p] == value)
            {
               arr.push(_arg_1);
               return false;
            }
            return true;
         },this);
         if(arr.length == 0)
         {
            return arr;
         }
         this.dispatchChangeEvent(DataChangeType.REMOVE,arr,0,arr.length - 1);
         return arr;
      }
      
      public function setItemIndex(_arg_1:*, _arg_2:int) : void
      {
         this.checkIndex(_arg_2);
         var _local_3:int = int(this._data.indexOf(_arg_1));
         if(_local_3 == -1)
         {
            return;
         }
         this.setItemIndexAt(_local_3,_arg_2);
      }
      
      public function addMultiAt(_arg_1:Array, _arg_2:uint) : void
      {
         this.checkIndex(_arg_2);
         this._data.splice(_arg_2,0,_arg_1);
         this.dispatchChangeEvent(DataChangeType.ADD,_arg_1.concat(),_arg_2,_arg_2 + _arg_1.length - 1);
      }
      
      override public function toString() : String
      {
         return "ArrayProvider [" + this._data.join(" , ") + "]";
      }
      
      public function upDateItemAt(_arg_1:uint, _arg_2:*) : *
      {
         this.checkIndex(_arg_1);
         var _local_3:* = this._data[_arg_1];
         this.dispatchPreChangeEvent(DataChangeType.UPDATE,[_local_3],_arg_1,_arg_1);
         this._data[_arg_1] = _arg_2;
         this.dispatchChangeEvent(DataChangeType.UPDATE,[_arg_2],_arg_1,_arg_1);
         return _local_3;
      }
      
      protected function checkIndex(_arg_1:int) : void
      {
         if(_arg_1 > this._data.length - 1 || _arg_1 < 0)
         {
            throw new RangeError("ArrayProvider index (" + _arg_1.toString() + ") is not in acceptable range (0 - " + (this._data.length - 1).toString() + ")");
         }
      }
      
      public function addAt(_arg_1:*, _arg_2:uint) : void
      {
         this.checkIndex(_arg_2);
         this._data.splice(_arg_2,0,_arg_1);
         this.dispatchChangeEvent(DataChangeType.ADD,[_arg_1],_arg_2,_arg_2);
      }
      
      protected function dispatchChangeEvent(_arg_1:String, _arg_2:Array, _arg_3:int = -1, _arg_4:int = -1) : void
      {
         if(!this.autoUpdate)
         {
            return;
         }
         if(hasEventListener(DataChangeEvent.DATA_CHANGE))
         {
            dispatchEvent(new DataChangeEvent(DataChangeEvent.DATA_CHANGE,_arg_1,_arg_2,_arg_3,_arg_4));
         }
      }
      
      public function filter(_arg_1:Function, _arg_2:* = null) : Array
      {
         return this._data.filter(_arg_1,_arg_2);
      }
      
      public function forEach(_arg_1:Function, _arg_2:* = null) : void
      {
         this._data.forEach(_arg_1,_arg_2);
      }
      
      public function some(_arg_1:Function, _arg_2:* = null) : Boolean
      {
         return this._data.some(_arg_1,_arg_2);
      }
      
      public function removeMultiIndex(indexs:Array) : Array
      {
         var arr:Array = null;
         arr = null;
         arr = [];
         this._data = this._data.filter(function(_arg_1:*, _arg_2:int, _arg_3:Array):Boolean
         {
            if(indexs.indexOf(_arg_2) == -1)
            {
               return true;
            }
            arr.push(_arg_1);
            return false;
         },this);
         if(arr.length > 0)
         {
            this.dispatchChangeEvent(DataChangeType.REMOVE,arr.concat(),0,arr.length - 1);
         }
         return arr;
      }
      
      public function map(_arg_1:Function, _arg_2:* = null) : Array
      {
         return this._data.map(_arg_1,_arg_2);
      }
      
      public function swapIndexAt(_arg_1:int, _arg_2:int) : void
      {
         var _local_3:Array = null;
         var _local_4:Array = null;
         if(_arg_1 == _arg_2)
         {
            return;
         }
         this.checkIndex(_arg_1);
         this.checkIndex(_arg_2);
         if(_arg_1 < _arg_2)
         {
            _local_4 = this._data.splice(_arg_2,1);
            _local_3 = this._data.splice(_arg_1,1,_local_4);
            this._data.splice(_arg_2,1,_local_3);
            this.dispatchChangeEvent(DataChangeType.SWAP,_local_4.concat(_local_3),_arg_1,_arg_2);
         }
         else
         {
            _local_3 = this._data.splice(_arg_1,1);
            _local_4 = this._data.splice(_arg_2,1);
            this._data.splice(_arg_1,1,_local_4);
            this.dispatchChangeEvent(DataChangeType.SWAP,_local_3.concat(_local_4),_arg_2,_arg_1);
         }
      }
   }
}

