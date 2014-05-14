package edu.ewu.datastructures
{
	/**
	 * A basic implimentation of Stack using a LinkedList approach
	 * 
	 * @author Justin Breitenbach
	 */
	public class Stack
	{
		/** Stores the head of the Stack **/
		protected var	 	_oHead 		:Node;
		
		/* ---------------------------------------------------------------------------------------- */
		
		/**
		 * Constructs the Stack object.
		 */
		public function Stack()
		{
		}
   
		/* ---------------------------------------------------------------------------------------- */
		
		/**
		 * Adds a new Node to the head of the Stack.
		 * 
		 * @param	$oNewData	Data to be added to stack.
		 */
		public function push(oNewData:Object):void
		{
			var oOldHead:Node = this._oHead;
			this._oHead = new Node();
			this._oHead.oData = oNewData;
			this._oHead.oNext = oOldHead;
		}
	   
		/* ---------------------------------------------------------------------------------------- */
		
		/**
		 * Returns the object at the head of the Stack and removes it.
		 */
		public function pop():Object 
		{
			var oReturn:Object = null;
			if (this.isEmpty() == false)
			{
				oReturn = this._oHead.oData;
				this._oHead = this._oHead.oNext;
			}
			return oReturn;
		}

		/* ---------------------------------------------------------------------------------------- */
		
		/**
		 * Returns data at the head of the Stack without removing it.
		 */
		public function peek():Object 
		{
			var oReturn:Object = null;
			if (this.isEmpty() == false)
			{
				oReturn = this._oHead.oData;
			}
			return oReturn;
		}
		
		
		/* ---------------------------------------------------------------------------------------- */
		
		/**
		 * Tells whether the Stack is empty.
		 *
		 * @return			Boolean describing whether the stack is empty or not.
		 */
		public function isEmpty():Boolean
		{
			return this._oHead == null;
		}
	}
}

class Node
{
	/** Stores the next node in the LinkedList **/
    public var 		oNext 	:Node;
	/** Stores the data that is contained in this Node **/
    public var		oData 	:Object;
}