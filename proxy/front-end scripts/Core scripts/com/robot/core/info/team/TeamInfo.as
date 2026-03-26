package com.robot.core.info.team
{
   import flash.utils.IDataInput;
   
   public class TeamInfo
   {
      
      public var id:uint;
      
      public var level:uint;
      
      public var priv:uint;
      
      public var superCore:Boolean;
      
      public var coreCount:uint;
      
      public var isShow:Boolean;
      
      public var logoBg:uint;
      
      public var logoIcon:uint;
      
      public var logoColor:uint;
      
      public var txtColor:uint;
      
      public var logoWord:String;
      
      public var allContribution:uint;
      
      public var canExContribution:uint;
      
      public function TeamInfo(_arg_1:IDataInput = null)
      {
         super();
         if(!_arg_1)
         {
            return;
         }
         this.id = _arg_1.readUnsignedInt();
         this.priv = _arg_1.readUnsignedInt();
         this.superCore = Boolean(_arg_1.readUnsignedInt());
         this.isShow = Boolean(_arg_1.readUnsignedInt());
         this.allContribution = _arg_1.readUnsignedInt();
         this.canExContribution = _arg_1.readUnsignedInt();
      }
   }
}

