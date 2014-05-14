package edu.ewu.components
{
	import edu.ewu.events.AppEvent;
	import flash.display.MovieClip;
	import flash.display.SimpleButton;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFieldType;
	import flash.text.TextFormat;
	
	/**
	 * ...
	 * @author Jon Roster
	 */
	public class NamePrompt extends MovieClip
	{
		private var _entry:TextField;
		private var _prompt:TextField;
		private var _submit:SubmitButton;
		private var _submitText:TextField;
		
		public function NamePrompt()
		{
			super();
			var fmt:TextFormat;
			
			fmt = new TextFormat("Arial", 12, 0xCC0000);
			_prompt = new TextField();
			_prompt.defaultTextFormat = fmt;
			_prompt.autoSize = TextFieldAutoSize.LEFT;
			_prompt.text = "Enter your name below";
			_prompt.x = 10;
			_prompt.y = 10;
			
			this.addChild(_prompt);
			
			_entry = new TextField();
			_entry.type = TextFieldType.INPUT;
			_entry.border = true;
			_entry.multiline = false;
			_entry.height = 20;
			_entry.x = 10;
			_entry.y = _prompt.y + _prompt.textHeight + 5;
			
			this.addChild(_entry);
			
			_submit = new SubmitButton();
			_submit.x = this.width/2 - _submit.width/2;
			_submit.y = this.height - _submit.height;
			_submit.addEventListener(MouseEvent.CLICK, onSubmit);
			this.addChild(_submit);
		
		}
		
		public function onSubmit($e:MouseEvent)
		{
			var uname:String = (_entry.text == "") ? ("Anon") : _entry.text;
			_submit.removeEventListener(MouseEvent.CLICK, onSubmit);
			dispatchEvent(new AppEvent(AppEvent.NAME_SUBMIT, false, false, uname));
			
		}
	
	}

}