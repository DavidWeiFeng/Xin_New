package com.robot.core.info
{
   import com.robot.core.manager.*;
   import flash.net.SharedObject;
   import flash.utils.*;
   import org.taomee.manager.*;
   import org.taomee.utils.*;
   
   public class NonoInfo
   {
      
      public var userID:uint;
      
      public var flag:Array;
      
      public var state:Array;
      
      public var nick:String;
      
      public var superNono:Boolean;
      
      public var color:uint;
      
      public var power:Number;
      
      public var mate:Number;
      
      public var iq:uint;
      
      public var ai:uint;
      
      public var birth:Number;
      
      public var chargeTime:uint;
      
      public var func:Array;
      
      public var superEnergy:Number;
      
      public var superLevel:uint;
      
      public var superStage:uint;
      
      public function NonoInfo(data:IDataInput = null)
      {
         var num:uint = 0;
         var f:int = 0;
         var s:int = 0;
         var i:int = 0;
         var k:int = 0;
         this.flag = [];
         this.state = [];
         this.func = [];
         super();
         if(Boolean(data))
         {
            this.userID = data.readUnsignedInt();
            num = uint(data.readUnsignedInt());
            if(num == 0)
            {
               return;
            }
            f = 0;
            while(f < 32)
            {
               this.flag.push(Boolean(BitUtil.getBit(num,f)));
               f += 1;
            }
            num = uint(data.readUnsignedInt());
            s = 0;
            while(s < 32)
            {
               this.state.push(Boolean(BitUtil.getBit(num,s)));
               s += 1;
            }
            this.nick = data.readUTFBytes(16);
            this.superNono = Boolean(data.readUnsignedInt());
            this.color = data.readUnsignedInt();
            this.power = data.readUnsignedInt() / 1000;
            this.mate = data.readUnsignedInt() / 1000;
            this.iq = data.readUnsignedInt();
            this.ai = data.readUnsignedShort();
            this.birth = data.readUnsignedInt() * 1000;
            this.chargeTime = data.readUnsignedInt();
            i = 0;
            while(i < 20)
            {
               num = uint(data.readUnsignedByte());
               k = 0;
               while(k < 8)
               {
                  this.func.push(Boolean(BitUtil.getBit(num,k)));
                  k += 1;
               }
               i += 1;
            }
            this.superEnergy = data.readUnsignedInt();
            this.superLevel = data.readUnsignedInt();
            this.superStage = data.readUnsignedInt();
            if(this.superStage > 4)
            {
               this.superStage = 4;
            }
            if(this.superStage == 0)
            {
               this.superStage = 1;
            }
            setTimeout(function():void
            {
               var so:SharedObject = SOManager.getUserSO(SOManager.LOCAL_CONFIG);
               if(!so.data["nonoSpriteTrack"])
               {
                  try
                  {
                     if(Boolean(func[14]))
                     {
                        TaomeeManager.nonoSpriteTrack = 1;
                     }
                     else
                     {
                        TaomeeManager.nonoSpriteTrack = 0;
                     }
                  }
                  catch(error:Error)
                  {
                     TaomeeManager.nonoSpriteTrack = 0;
                  }
                  so.data["nonoSpriteTrack"] = String(TaomeeManager.nonoSpriteTrack);
                  SOManager.flush(so);
               }
               else
               {
                  TaomeeManager.nonoSpriteTrack = int(so.data["nonoSpriteTrack"]);
               }
            },10);
         }
      }
      
      public function getMateLevel() : uint
      {
         if(this.mate <= 30)
         {
            return 1;
         }
         if(this.mate >= 31 && this.mate <= 69)
         {
            return 2;
         }
         return 3;
      }
      
      public function getPowerLevel() : uint
      {
         if(this.power <= 30)
         {
            return 1;
         }
         if(this.power >= 31 && this.power <= 69)
         {
            return 2;
         }
         return 3;
      }
   }
}

