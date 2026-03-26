package com.robot.core.info
{
   import com.robot.core.utils.SolidType;
   import flash.geom.Point;
   import flash.utils.IDataInput;
   
   public class FitmentInfo
   {
      
      public var isFixed:Boolean = false;
      
      public var pos:Point = new Point();
      
      public var dir:uint;
      
      public var status:uint;
      
      public var type:uint;
      
      protected var _id:uint;
      
      protected var _usedCount:uint;
      
      protected var _allCount:uint;
      
      protected var _unUsedCount:uint;
      
      public function FitmentInfo()
      {
         super();
      }
      
      public static function setFor10008(_arg_1:FitmentInfo, _arg_2:IDataInput = null) : void
      {
         _arg_1.id = _arg_2.readUnsignedInt();
         _arg_1.pos.x = _arg_2.readUnsignedInt();
         _arg_1.pos.y = _arg_2.readUnsignedInt();
         _arg_1.dir = _arg_2.readUnsignedInt();
         _arg_1.status = _arg_2.readUnsignedInt();
      }
      
      public static function setFor10007(_arg_1:FitmentInfo, _arg_2:IDataInput = null) : void
      {
         _arg_1.id = _arg_2.readUnsignedInt();
         _arg_1.usedCount = _arg_2.readUnsignedInt();
         _arg_1.allCount = _arg_2.readUnsignedInt();
      }
      
      public function get id() : uint
      {
         return this._id;
      }
      
      public function set id(_arg_1:uint) : void
      {
         this._id = _arg_1;
         if(this._id >= 500001 && this._id <= 500100)
         {
            this.type = SolidType.FRAME;
         }
         else if(this._id >= 500101 && this._id <= 500300)
         {
            this.type = SolidType.WAP;
         }
         else if(this._id >= 500301 && this._id <= 500500)
         {
            this.type = SolidType.FLO;
         }
         else if(this._id >= 500501 && this._id <= 500800)
         {
            this.type = SolidType.PUT;
         }
         else if(this._id >= 500801)
         {
            this.type = SolidType.HANG;
         }
      }
      
      public function get usedCount() : uint
      {
         return this._usedCount;
      }
      
      public function set usedCount(_arg_1:uint) : void
      {
         this._usedCount = _arg_1;
         this.unUsedCount = this.allCount - this._usedCount;
      }
      
      public function get allCount() : uint
      {
         return this._allCount;
      }
      
      public function set allCount(_arg_1:uint) : void
      {
         this._allCount = _arg_1;
         this.unUsedCount = this._allCount - this._usedCount;
      }
      
      public function get unUsedCount() : uint
      {
         return this._unUsedCount;
      }
      
      public function set unUsedCount(_arg_1:uint) : void
      {
         this._unUsedCount = _arg_1;
         this._usedCount = this._allCount - this._unUsedCount;
      }
   }
}

