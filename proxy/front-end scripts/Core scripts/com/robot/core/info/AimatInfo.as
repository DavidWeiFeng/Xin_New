package com.robot.core.info
{
   import com.robot.core.config.xml.AimatXMLInfo;
   import flash.geom.Point;
   
   public class AimatInfo
   {
      
      public var id:uint;
      
      public var userID:uint;
      
      public var startPos:Point;
      
      public var endPos:Point;
      
      public var speed:Number = 36;
      
      public function AimatInfo(_arg_1:uint, _arg_2:uint, _arg_3:Point = null, _arg_4:Point = null)
      {
         super();
         this.id = _arg_1;
         this.userID = _arg_2;
         this.startPos = _arg_3;
         this.endPos = _arg_4;
         this.speed = AimatXMLInfo.getSpeed(this.id);
      }
      
      public function clone() : AimatInfo
      {
         return new AimatInfo(this.id,this.userID,this.startPos,this.endPos);
      }
   }
}

