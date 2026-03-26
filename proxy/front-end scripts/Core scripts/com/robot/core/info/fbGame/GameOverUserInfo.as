package com.robot.core.info.fbGame
{
   import flash.geom.Point;
   import flash.utils.IDataInput;
   
   public class GameOverUserInfo
   {
      
      public var id:uint;
      
      public var pos:Point;
      
      public function GameOverUserInfo(_arg_1:IDataInput)
      {
         super();
         this.id = _arg_1.readUnsignedInt();
         this.pos = new Point(_arg_1.readUnsignedInt(),_arg_1.readUnsignedInt());
      }
   }
}

