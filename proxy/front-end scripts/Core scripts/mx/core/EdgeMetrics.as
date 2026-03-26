package mx.core
{
   use namespace mx_internal;
   
   public class EdgeMetrics
   {
      
      mx_internal static const VERSION:String = "4.6.0.23201";
      
      public static const EMPTY:EdgeMetrics = new EdgeMetrics(0,0,0,0);
      
      public var bottom:Number;
      
      public var left:Number;
      
      public var right:Number;
      
      public var top:Number;
      
      public function EdgeMetrics(_arg_1:Number = 0, _arg_2:Number = 0, _arg_3:Number = 0, _arg_4:Number = 0)
      {
         super();
         this.left = _arg_1;
         this.top = _arg_2;
         this.right = _arg_3;
         this.bottom = _arg_4;
      }
      
      public function clone() : EdgeMetrics
      {
         return new EdgeMetrics(this.left,this.top,this.right,this.bottom);
      }
   }
}

