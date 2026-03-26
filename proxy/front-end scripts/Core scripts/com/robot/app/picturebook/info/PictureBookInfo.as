package com.robot.app.picturebook.info
{
   import flash.utils.IDataInput;
   
   public class PictureBookInfo
   {
      
      private var _id:uint;
      
      private var _encont:uint;
      
      private var _isCacth:Boolean;
      
      public function PictureBookInfo(_arg_1:IDataInput = null)
      {
         super();
         if(Boolean(_arg_1))
         {
            this._id = _arg_1.readUnsignedInt();
            this._encont = _arg_1.readUnsignedInt();
            this._isCacth = Boolean(_arg_1.readUnsignedInt());
            _arg_1.readUnsignedInt();
         }
      }
      
      public function get id() : uint
      {
         return this._id;
      }
      
      public function get encont() : uint
      {
         return this._encont;
      }
      
      public function get isCacth() : Boolean
      {
         return this._isCacth;
      }
   }
}

