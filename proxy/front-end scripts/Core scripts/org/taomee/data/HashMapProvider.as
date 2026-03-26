package org.taomee.data
{
   import flash.events.EventDispatcher;
   import flash.events.IEventDispatcher;
   import org.taomee.ds.*;
   
   [Event(name="preDataChange",type="fl.events.DataChangeEvent")]
   [Event(name="dataChange",type="fl.events.DataChangeEvent")]
   public class HashMapProvider extends EventDispatcher
   {
      
      private var _data:HashMap = new HashMap();
      
      public var autoUpdate:Boolean = true;
      
      public function HashMapProvider()
      {
         super();
      }
      
      public function containsKey(_arg_1:*) : Boolean
      {
         return this._data.containsKey(_arg_1);
      }
      
      protected function dispatchPreChangeEvent(_arg_1:String, _arg_2:Array) : void
      {
         if(!this.autoUpdate)
         {
            return;
         }
         if(hasEventListener(DataChangeEvent.PRE_DATA_CHANGE))
         {
            dispatchEvent(new DataChangeEvent(DataChangeEvent.PRE_DATA_CHANGE,_arg_1,_arg_2));
         }
      }
      
      public function dispatchSelectMulti(_arg_1:IEventDispatcher, _arg_2:Array, _arg_3:Array) : void
      {
         var _local_5:int = 0;
         var _local_4:int = int(_arg_2.length);
         while(_local_5 < _local_4)
         {
            this._data.add(_arg_2[_local_5],_arg_3[_local_5]);
            _local_5++;
         }
         _arg_1.dispatchEvent(new DataChangeEvent(DataChangeEvent.DATA_CHANGE,DataChangeType.SELECT,_arg_3.concat()));
      }
      
      public function remove(_arg_1:*) : *
      {
         var _local_2:* = this._data.remove(_arg_1);
         if(_local_2)
         {
            this.dispatchChangeEvent(DataChangeType.REMOVE,[_local_2]);
            return _local_2;
         }
         return null;
      }
      
      public function addMulti(_arg_1:Array, _arg_2:Array) : Array
      {
         var _local_6:int = 0;
         var _local_3:* = undefined;
         var _local_4:Array = [];
         var _local_5:int = int(_arg_1.length);
         while(_local_6 < _local_5)
         {
            _local_3 = this._data.add(_arg_1[_local_6],_arg_2[_local_6]);
            if(_local_3)
            {
               _local_4.push(_local_3);
            }
            _local_6++;
         }
         this.dispatchChangeEvent(DataChangeType.ADD,_arg_2.concat());
         return _local_4;
      }
      
      public function removeForValue(_arg_1:*) : *
      {
         var _local_2:* = undefined;
         var _local_3:* = this._data.getKey(_arg_1);
         if(_local_3)
         {
            _local_2 = this._data.remove(_local_3);
            if(_local_2)
            {
               this.dispatchChangeEvent(DataChangeType.REMOVE,[_local_2]);
               return _local_2;
            }
         }
         return null;
      }
      
      public function removeMulti(_arg_1:Array) : Array
      {
         var _local_2:* = undefined;
         var _local_3:* = undefined;
         var _local_4:Array = [];
         for each(_local_2 in _arg_1)
         {
            _local_3 = this._data.remove(_local_2);
            if(_local_3)
            {
               _local_4.push(_local_3);
            }
         }
         if(_local_4.length > 0)
         {
            this.dispatchChangeEvent(DataChangeType.REMOVE,_local_4.concat());
         }
         return _local_4;
      }
      
      public function dispatchSelect(_arg_1:IEventDispatcher, _arg_2:*, _arg_3:*) : void
      {
         this._data.add(_arg_2,_arg_3);
         _arg_1.dispatchEvent(new DataChangeEvent(DataChangeEvent.DATA_CHANGE,DataChangeType.SELECT,[_arg_3]));
      }
      
      public function getValues() : Array
      {
         return this._data.getValues();
      }
      
      public function containsValue(_arg_1:*) : Boolean
      {
         return this._data.containsValue(_arg_1);
      }
      
      public function refresh() : void
      {
         this.dispatchChangeEvent(DataChangeType.RESET,this._data.getValues());
      }
      
      public function removeMultiForValue(_arg_1:Array) : Array
      {
         var _local_2:* = undefined;
         var _local_3:* = undefined;
         var _local_4:* = undefined;
         var _local_5:Array = [];
         for each(_local_2 in _arg_1)
         {
            _local_3 = this._data.getKey(_local_2);
            if(_local_3)
            {
               _local_4 = this._data.remove(_local_3);
               if(_local_4)
               {
                  _local_5.push(_local_4);
               }
            }
         }
         if(_local_5.length > 0)
         {
            this.dispatchChangeEvent(DataChangeType.REMOVE,_local_5.concat());
         }
         return _local_5;
      }
      
      public function upDateForKey(_arg_1:*, _arg_2:*) : void
      {
         var _local_3:* = undefined;
         if(this._data.containsKey(_arg_1))
         {
            _local_3 = this._data.add(_arg_1,_arg_2);
            if(_local_3)
            {
               this.dispatchPreChangeEvent(DataChangeType.UPDATE,[_local_3]);
            }
            this.dispatchChangeEvent(DataChangeType.UPDATE,[_arg_2]);
         }
      }
      
      public function add(_arg_1:*, _arg_2:*) : *
      {
         var _local_3:* = this._data.add(_arg_1,_arg_2);
         this.dispatchChangeEvent(DataChangeType.ADD,[_arg_2]);
         return _local_3;
      }
      
      public function get length() : uint
      {
         return this._data.length;
      }
      
      public function getKey(_arg_1:*) : *
      {
         return this._data.getKey(_arg_1);
      }
      
      public function getKeys() : Array
      {
         return this._data.getKeys();
      }
      
      public function upDateForValue(_arg_1:*, _arg_2:*) : void
      {
         var _local_3:* = this._data.getKey(_arg_1);
         if(_local_3)
         {
            this._data.add(_local_3,_arg_2);
            this.dispatchPreChangeEvent(DataChangeType.UPDATE,[_arg_1]);
            this.dispatchChangeEvent(DataChangeType.UPDATE,[_arg_2]);
         }
      }
      
      protected function dispatchChangeEvent(_arg_1:String, _arg_2:Array) : void
      {
         if(!this.autoUpdate)
         {
            return;
         }
         if(hasEventListener(DataChangeEvent.DATA_CHANGE))
         {
            dispatchEvent(new DataChangeEvent(DataChangeEvent.DATA_CHANGE,_arg_1,_arg_2));
         }
      }
      
      public function toHashMap() : HashMap
      {
         return this._data.clone();
      }
      
      public function getValue(_arg_1:*) : *
      {
         return this._data.getValue(_arg_1);
      }
      
      public function removeAll() : void
      {
         var _local_1:Array = this._data.getValues();
         this._data.clear();
         this.dispatchChangeEvent(DataChangeType.REMOVE_ALL,_local_1);
      }
   }
}

