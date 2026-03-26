package org.taomee.ds
{
   import flash.utils.*;
   
   public class HashMap implements ICollection
   {
      
      private var _length:int;
      
      private var _weakKeys:Boolean;
      
      private var _content:Dictionary;
      
      public function HashMap(_arg_1:Boolean = false)
      {
         super();
         this._weakKeys = _arg_1;
         this._length = 0;
         this._content = new Dictionary(_arg_1);
      }
      
      public function containsKey(_arg_1:*) : Boolean
      {
         if(this._content[_arg_1] === undefined)
         {
            return false;
         }
         return true;
      }
      
      public function remove(_arg_1:*) : *
      {
         if(this._content[_arg_1] === undefined)
         {
            return null;
         }
         var _local_2:* = this._content[_arg_1];
         delete this._content[_arg_1];
         --this._length;
         return _local_2;
      }
      
      public function some(_arg_1:Function) : Boolean
      {
         var _local_2:* = undefined;
         for(_local_2 in this._content)
         {
            if(_arg_1(_local_2,this._content[_local_2]))
            {
               return true;
            }
         }
         return false;
      }
      
      public function clear() : void
      {
         this._length = 0;
         this._content = new Dictionary(this._weakKeys);
      }
      
      public function each2(_arg_1:Function) : void
      {
         var _local_2:* = undefined;
         for(_local_2 in this._content)
         {
            _arg_1(_local_2,this._content[_local_2]);
         }
      }
      
      public function isEmpty() : Boolean
      {
         return this._length == 0;
      }
      
      public function getValues() : Array
      {
         var _local_3:int = 0;
         var _local_1:* = undefined;
         var _local_2:Array = new Array(this._length);
         for each(_local_1 in this._content)
         {
            _local_2[_local_3] = _local_1;
            _local_3++;
         }
         return _local_2;
      }
      
      public function containsValue(_arg_1:*) : Boolean
      {
         var _local_2:* = undefined;
         for each(_local_2 in this._content)
         {
            if(_local_2 === _arg_1)
            {
               return true;
            }
         }
         return false;
      }
      
      public function clone() : HashMap
      {
         var _local_1:* = undefined;
         var _local_2:HashMap = new HashMap(this._weakKeys);
         for(_local_1 in this._content)
         {
            _local_2.add(_local_1,this._content[_local_1]);
         }
         return _local_2;
      }
      
      public function eachKey(_arg_1:Function) : void
      {
         var _local_2:* = undefined;
         for(_local_2 in this._content)
         {
            _arg_1(_local_2);
         }
      }
      
      public function add(_arg_1:*, _arg_2:*) : *
      {
         var _local_3:* = undefined;
         if(_arg_1 == null)
         {
            throw new ArgumentError("cannot put a value with undefined or null key!");
         }
         switch(_arg_2)
         {
            case undefined:
               return null;
            case undefined:
               ++this._length;
         }
         _local_3 = this.getValue(_arg_1);
         this._content[_arg_1] = _arg_2;
         return _local_3;
      }
      
      public function get length() : int
      {
         return this._length;
      }
      
      public function getKey(_arg_1:*) : *
      {
         var _local_2:* = undefined;
         for(_local_2 in this._content)
         {
            if(this._content[_local_2] == _arg_1)
            {
               return _local_2;
            }
         }
         return null;
      }
      
      public function getKeys() : Array
      {
         var _local_3:int = 0;
         var _local_1:* = undefined;
         var _local_2:Array = new Array(this._length);
         for(_local_1 in this._content)
         {
            _local_2[_local_3] = _local_1;
            _local_3++;
         }
         return _local_2;
      }
      
      public function toString() : String
      {
         var _local_1:int = 0;
         var _local_2:Array = this.getKeys();
         var _local_3:Array = this.getValues();
         var _local_4:int = int(_local_2.length);
         var _local_5:String = "HashMap Content:\n";
         _local_1 = 0;
         while(_local_1 < _local_4)
         {
            _local_5 += _local_2[_local_1] + " -> " + _local_3[_local_1] + "\n";
            _local_1++;
         }
         return _local_5;
      }
      
      public function eachValue(_arg_1:Function) : void
      {
         var _local_2:* = undefined;
         for each(_local_2 in this._content)
         {
            _arg_1(_local_2);
         }
      }
      
      public function filter(_arg_1:Function) : Array
      {
         var _local_2:* = undefined;
         var _local_3:* = undefined;
         var _local_4:Array = [];
         for(_local_2 in this._content)
         {
            _local_3 = this._content[_local_2];
            if(_arg_1(_local_2,_local_3))
            {
               _local_4.push(_local_3);
            }
         }
         return _local_4;
      }
      
      public function getValue(_arg_1:*) : *
      {
         var _local_2:* = this._content[_arg_1];
         return _local_2 === undefined ? null : _local_2;
      }
   }
}

