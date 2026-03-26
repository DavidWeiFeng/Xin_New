package gs.events
{
   import flash.events.Event;
   
   public class TweenEvent extends Event
   {
      
      public static const version:Number = 0.9;
      
      public static const START:String = "start";
      
      public static const UPDATE:String = "update";
      
      public static const COMPLETE:String = "complete";
      
      public var info:Object;
      
      public function TweenEvent(_arg_1:String, _arg_2:Object = null, _arg_3:Boolean = false, _arg_4:Boolean = false)
      {
         super(_arg_1,_arg_3,_arg_4);
         this.info = _arg_2;
      }
      
      override public function clone() : Event
      {
         return new TweenEvent(this.type,this.info,this.bubbles,this.cancelable);
      }
   }
}

