package gs.utils.tween
{
   public dynamic class TweenMaxVars extends TweenLiteVars
   {
      
      public static const version:Number = 2.01;
      
      protected var _roundProps:Array;
      
      public var loop:Number;
      
      public var yoyo:Number;
      
      public var onCompleteListener:Function;
      
      public var onStartListener:Function;
      
      public var onUpdateListener:Function;
      
      public function TweenMaxVars(_arg_1:Object = null)
      {
         super(_arg_1);
      }
      
      public function get roundProps() : Array
      {
         return this._roundProps;
      }
      
      public function set roundProps(_arg_1:Array) : void
      {
         this._roundProps = _exposedVars.roundProps = _arg_1;
      }
      
      override protected function appendCloneVars(_arg_1:Object, _arg_2:Object) : void
      {
         super.appendCloneVars(_arg_1,_arg_2);
         var _local_3:Array = ["onStartListener","onUpdateListener","onCompleteListener","onCompleteAllListener","yoyo","loop"];
         var _local_4:int = _local_3.length - 1;
         while(_local_4 > -1)
         {
            _arg_1[_local_3[_local_4]] = this[_local_3[_local_4]];
            _local_4--;
         }
         _arg_2._roundProps = this._roundProps;
      }
      
      override public function clone() : TweenLiteVars
      {
         var _local_1:Object = {"protectedVars":{}};
         this.appendCloneVars(_local_1,_local_1.protectedVars);
         return new TweenMaxVars(_local_1);
      }
   }
}

