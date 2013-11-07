package tools.embed {
	
	import flash.utils.ByteArray;
	import com.demonsters.debugger.MonsterDebugger;
	//import com.adobe.serialization.json.JSON;
	
	public final class JSONEmbedder {
		
		
		//private const self:JSONEmbedder = new JSONEmbedder();
		/// Regular Expression defining anything shaped like a constant (UPPERCASE_UNDERSCORE_ETC).
		private static const refPattern:RegExp = /\"[A-Z]+[_[A-Z]+]?\"/g;
		private static const quotePattern:RegExp = /\"/g;
		
		private var refName:String = "";
		
		private static var self:JSONEmbedder = new JSONEmbedder();
		
		/// The object from which to request all the values to replace. 
		private var source:Object;
		
		/**
		 * 
		 * @param	source Pass an object which contains a list of constants; it will be used during the replace function. 
		 * @param	SourceClass If used, the source is a JSON object that must be loaded before use.
		 */
		public function JSONEmbedder(source:Object = null, SourceClass:Class = null) {
			if (SourceClass != null)
				source = load(SourceClass, false).text;
			this.source = source;
		}
		
		//TODO: Use dependency injection to decouple JSONEmbedder from the Data class. 
		//		When loading files, also give JSONEmbedder a ref to a "bank" object
		//		which contains all the values.
		//		Also, consider making Data and JSONEmbedder non-static, to allow for
		//		interfaces, easier passing, etc.
		
		public function load(Embedded:Class, evaluateThis:Boolean = true):Object {
			var bytes:ByteArray = new Embedded() as ByteArray;
			var rawString:String = bytes.readUTFBytes(bytes.length);
			if (evaluateThis) {
				rawString = evaluateRefs(rawString);
			}
			//MonsterDebugger.trace(self, rawString);
			//MonsterDebugger.trace(self, JSON.parse(rawString));
			
            return JSON.parse(rawString);
		}
		
		/**
		 * Replaces all the string variable names (the refs to string values)
		 * with the actual value, which is found in Text.json.
		 * @return
		 */
		private function evaluateRefs(string:String):String {
			var result:Object = refPattern.exec(string);
			var index:int = 0;
			var lastIndex:uint = 0;
			var quote:String = "\"";
			//MonsterDebugger.trace(self, result);
			while (result != null) {
				
				// the result found includes quotes for stricter RegExp search, 
				refName = result[0].concat();
				//MonsterDebugger.trace(self, refName, "JSONEmbedder");
				// removing quotes is needed to find the refName property in Data.text
				refName = refName.replace(quotePattern, "");
				
				// when a reference is invalid (no matching variable in Data.text),
				// skip the rest of the loop cycle and continues searching
				// also, simple !source[refName] does not work, need to call the hasOwnProperty functio
				if (!source.hasOwnProperty(refName) ) {
					//return string;
					
					//TODO: a simple fix is to make sure there are no "invalid" values
					//		by making sure that none of the string values can be all uppercase
					//		and mistaken for a reference. To do this, rename the NPC class into
					//		something more descriptive like Friendly...or give them proper, unique
					//	 	names.
					
					// when global is false, lastIndex is ignored
					
					//refPattern.lastIndex = lastIndex;//string.indexOf( refName ) + refName.length;
					MonsterDebugger.trace(self,
					"A wild reference (all uppercase String with no corresponding value) found in JSON file",
					"", "WARNING", 0xF4AB00);
					result = refPattern.exec(string);
					continue;
				}
				// need to surround by quotes for string values, but not for number values
				if (source[refName] is String) {
					//MonsterDebugger.trace(self, "YOU CAN COPY DATA.TEXT VALUES INTO STATIC CONSTS IN THE DATA CLASS: " + Data["GRAVITY"]);
					//string = string.replace(refPattern, ("\"" + Data.text[refName] + "\""));
					quote = "\"";
				} else {
					//string = string.replace(refPattern, (Data.text[refName]));
					quote = "";
				}
				index = string.indexOf(refName/*, lastIndex*/);
				//
				//var testValue:String = (quote + Data.text[refName] + quote);//string.substring( index, lastIndex);
				var testRefName:String = refName;
				refPattern.lastIndex;
				var testString:String = string.slice(0, refPattern.lastIndex) + ("###") + string.slice(refPattern.lastIndex);
				// replacing ref with matching value in Data.text
				string = string.slice (0, index-1 ) + (quote + source[refName] + quote) + string.slice(index + refName.length+1);
				//TODO: tilePresets and entitys cause the refPatter.exec search to fail (it skips some refs)
				//		the problem is possibly that the refPattern.lastIndex property starts the search in a wrong place,
				//		too far ahead. In files where there is very little space between the refs, the search ends up
				//		skipping some of refs because it started too far ahead. This can be seen when we add filler characters
				//		into the JSON files. When enough filler is added, the the search still starts far ahead
				//		but not far enough to skip the next ref.
				//TODO: the problem could be that when modifying the values, the location of lastIndex becomes irrelevant
				//		because the string has been shifted. When a ref is replaced by its value, it reduces the size of the
				//		entire string, making the lastIndex appear to shift forward.
				
				// BUG FIX
				// After the refs are replaced by the values, the entire string is modified.
				// The refName is replaced by a text/value that is of different length (freq. shorter) 
				// causing a problem where the lastIndex location is shifted from the accurate location.
				// Since the RegExp search depends on the lastIndex, the search begins in the wrong place
				// and sometimes entirely misses the next match.
				// This line compensates for the shift by finding the diff between the matched string
				// and the string that replaced it.
				refPattern.lastIndex = refPattern.lastIndex - Math.abs( (String((quote + source[refName] + quote)).length) - refName.length );
				
				result = refPattern.exec(string);
				lastIndex = refPattern.lastIndex;
				var testString2:String = string.slice(0, lastIndex) + ("###") + string.slice(lastIndex);
				
			}
			
			return string;
		}
		
	}
	
}