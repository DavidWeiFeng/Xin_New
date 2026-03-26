package com.robot.core.info.pet
{
   import flash.filters.ColorMatrixFilter;
   import flash.filters.GlowFilter;
   import flash.utils.IDataInput;
   
   public class PetGlowFilter
   {
      
      public var color:uint;
      
      public var alpha:Number;
      
      private var _blurX:uint;
      
      private var _blurY:uint;
      
      private var _strength:uint;
      
      public var quality:int;
      
      public var inner:Boolean;
      
      public var knockout:Boolean;
      
      public var level:int;
      
      public var colorMatrixFilter:Array;
      
      private var _local_5:ColorMatrixFilter;
      
      private var _local_3:GlowFilter;
      
      public function PetGlowFilter(_arg_1:IDataInput = null)
      {
         var i:int = 0;
         super();
         this.color = 16711680;
         this.alpha = 1;
         this._blurX = 6;
         this._blurY = 6;
         this._strength = 2;
         this.quality = 1;
         this.inner = false;
         this.knockout = false;
         this.colorMatrixFilter = new Array(20);
         if(_arg_1 != null)
         {
            this.color = _arg_1.readUnsignedInt();
            this.alpha = _arg_1.readFloat();
            this._blurX = _arg_1.readUnsignedByte();
            this._blurY = _arg_1.readUnsignedByte();
            this._strength = _arg_1.readUnsignedByte();
            this.quality = _arg_1.readInt();
            this.inner = _arg_1.readBoolean();
            this.knockout = _arg_1.readBoolean();
            for(i = 0; i < 20; i++)
            {
               this.colorMatrixFilter[i] = _arg_1.readFloat();
            }
            this.level = _arg_1.readUnsignedByte();
            this._local_3 = new GlowFilter(this.color,this.alpha,this.blurX,this.blurY,this.strength,this.quality,this.inner,this.knockout);
            this._local_5 = new ColorMatrixFilter(this.colorMatrixFilter);
         }
      }
      
      public function get blurX() : uint
      {
         return this._blurX;
      }
      
      public function get GetColorMatrixFilter() : ColorMatrixFilter
      {
         return this._local_5;
      }
      
      public function get GetGlowFilter() : GlowFilter
      {
         return this._local_3;
      }
      
      public function set blurX(value:uint) : void
      {
         this._blurX = value > 255 ? 255 : (value < 0 ? 0 : value);
      }
      
      public function get blurY() : uint
      {
         return this._blurY;
      }
      
      public function set blurY(value:uint) : void
      {
         this._blurY = value > 255 ? 255 : (value < 0 ? 0 : value);
      }
      
      public function get strength() : uint
      {
         return this._strength;
      }
      
      public function set strength(value:uint) : void
      {
         this._strength = value > 255 ? 255 : (value < 0 ? 0 : value);
      }
   }
}

