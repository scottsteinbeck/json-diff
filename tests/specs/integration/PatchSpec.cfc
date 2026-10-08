/**
* Tests for patch
*/
component extends="testbox.system.BaseSpec"{

	function beforeAll(){
		jsondiff = new models.jsondiff();
	}

	function run(){
		describe("Test Patch", ()=>{
			it("applies struct changes and additions", ()=>{
				var original = { "a": 1, "user": { "name": "a" } };
				var updated = { "a": 2, "user": { "name": "b", "city": "x" }, "b": 3 };
				expect(jsondiff.patch(original, jsondiff.diff(original, updated))).toBe(updated);
			});

			it("applies an added struct", ()=>{
				var updated = { "user": { "name": "a" } };
				expect(jsondiff.patch({}, jsondiff.diff({}, updated))).toBe(updated);
			});

			it("applies an appended array item", ()=>{
				expect(jsondiff.patch(["a"], jsondiff.diff(["a"], ["a", "b"]))).toBe(["a", "b"]);
			});

			it("replaces a removed struct value with an empty string", ()=>{
				var original = { "a": 1, "b": 2 };
				expect(jsondiff.patch(original, jsondiff.diff(original, { "a": 1 }))).toBe({
					"a": 1,
					"b": ""
				});
			});

			it("replaces a removed array item with an empty string", ()=>{
				expect(jsondiff.patch(["a", "b"], jsondiff.diff(["a", "b"], ["a"]))).toBe(["a", ""]);
			});
		});
	}

}
