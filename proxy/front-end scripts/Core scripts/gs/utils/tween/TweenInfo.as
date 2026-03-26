package gs.utils.tween
{
   public class TweenInfo
   {
      
      public var start:Number;
      
      public var name:String;
      
      public var change:Number;
      
      public var target:Object;
      
      public var property:String;
      
      public var isPlugin:Boolean;
      
      public function TweenInfo(_arg_1:Object, _arg_2:String, _arg_3:Number, _arg_4:Number, _arg_5:String, _arg_6:Boolean)
      {
         super();
         this.target = _arg_1;
         this.property = _arg_2;
         this.start = _arg_3;
         this.change = _arg_4;
         this.name = _arg_5;
         this.isPlugin = _arg_6;
      }
   }
}

