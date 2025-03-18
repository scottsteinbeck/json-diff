/**
* This tests the BDD functionality in TestBox. This is CF10+, Lucee4.5+
*/
component extends="testbox.system.BaseSpec"{
	/*********************************** LIFE CYCLE Methods ***********************************/

	function beforeAll(){
		jsondiff = new models.jsondiff();
	}

	/*********************************** BDD SUITES ***********************************/

	function run() {
		describe("Test Text", ()=>{
			it("same text value", () => {
				var obj = { test: "foo" };
				var changed = { test: "foo" };
				var diff = jsondiff.diff(obj,changed);
				var display = jsondiff.displayDiff(obj,diff);
				// writeOutput(display);
				expect(display).toBe('<ul><li><span style="font-weight:bold">TEST</span>: <span style="color:##666">"foo"</span> (same)</li></ul>');
			});
			it("new text value", () => {
				var obj = {};
				var changed = { test: "bar" };
				var diff = jsondiff.diff(obj,changed);
				var display = jsondiff.displayDiff(obj,diff);
				// writeOutput(display);
				expect(display).toBe('<ul><li><span style="font-weight:bold">TEST</span>: <span style="background: ##bbffbb;">"bar"</span> (add)</li></ul>');
			});
			it("change text value", () => {
				var obj = { test: "foo" };
				var changed = { test: "bar" };
				var diff = jsondiff.diff(obj,changed);
				var display = jsondiff.displayDiff(obj,diff);
				// writeOutput(display);
				expect(display).toBe('<ul><li><span style="font-weight:bold">TEST</span>: <span style="background: ##ffbbbb;text-decoration: line-through;">"foo"</span> <span style="background: ##bbffbb;">"bar"</span> (change)</li></ul>');
			});
		});
		describe("Test Arrays", ()=>{
			it("same array value", () => {
				var obj = { test: [1]};
				var changed = { test: [1] };
				var diff = jsondiff.diff(obj,changed);
				var display = jsondiff.displayDiff(obj,diff);
				// writeOutput(display);
				expect(display).toBe('<ul><li><span style="font-weight:bold">TEST</span>: <ul><li><span style="font-weight:bold">1</span> <span style="color:##666">1</span> (same)</li></ul></li></ul>');
			});
			it("add array value", () => {
				var obj = { test: [1]};
				var changed = { test: [1,2] };
				var diff = jsondiff.diff(obj,changed);
				var display = jsondiff.displayDiff(obj,diff);
				// writeOutput(display);
				expect(display).toBe('<ul><li><span style="font-weight:bold">TEST</span>: <ul><li><span style="font-weight:bold">1</span> <span style="color:##666">1</span> (same)</li><li><span style="font-weight:bold">2</span> <span style="background: ##bbffbb;">2</span> (add)</li></ul></li></ul>');
			});
			it("remove array value", () => {
				var obj = { test: [1,2]};
				var changed = { test: [1] };
				var diff = jsondiff.diff(obj,changed);
				var display = jsondiff.displayDiff(obj,diff);
				// writeOutput(display);
				expect(display).toBe('<ul><li><span style="font-weight:bold">TEST</span>: <ul><li><span style="font-weight:bold">1</span> <span style="color:##666">1</span> (same)</li><li><span style="font-weight:bold">2</span> <span style="background: ##ffbbbb;text-decoration: line-through;">2</span> (remove) </li></ul></li></ul>');
			});
			it("new array", () => {
				var obj = {};
				var changed = { test: [] };
				var diff = jsondiff.diff(obj,changed);
				var display = jsondiff.displayDiff(obj,diff);
				// writeOutput(display);
				expect(display).toBe('<ul><li><span style="font-weight:bold">TEST</span>: <span style="background: ##bbffbb;">[]</span> (add)</li></ul>');
			});
			it("remove array", () => {
				var obj = { test: [] };
				var changed = {};
				var diff = jsondiff.diff(obj,changed);
				var display = jsondiff.displayDiff(obj,diff);
				// writeOutput(display);
				expect(display).toBe('<ul><li><span style="font-weight:bold">TEST</span>: <span style="background: ##ffbbbb;text-decoration: line-through;">[]</span> (remove) </li></ul>');
			});
		})
		describe("Nested Objects", ()=>{
			it("add and arrays", () => {
				var obj = { test: { foo: [1] } };
				var changed = { test: { bar: [1] } };
				var diff = jsondiff.diff(obj,changed);
				var display = jsondiff.displayDiff(obj,diff);
				// writeOutput(display);
				expect(display).toBe('<ul><li><span style="font-weight:bold">TEST</span>: <ul><li><span style="font-weight:bold">FOO</span>: <span style="background: ##ffbbbb;text-decoration: line-through;">[1]</span> (remove) </li><li><span style="font-weight:bold">BAR</span>: <span style="background: ##bbffbb;">[1]</span> (add)</li></ul></li></ul>');
			});
			it("change nested props", () => {
				var obj = { test: { foo: { bar: "a" } } };
				var changed = { test: { foo: { bar: "b" } } };
				var diff = jsondiff.diff(obj,changed);
				var display = jsondiff.displayDiff(obj,diff);
				// writeOutput(display);
				expect(display).toBe('<ul><li><span style="font-weight:bold">TEST</span>: <ul><li><span style="font-weight:bold">FOO</span>: <ul><li><span style="font-weight:bold">BAR</span>: <span style="background: ##ffbbbb;text-decoration: line-through;">"a"</span> <span style="background: ##bbffbb;">"b"</span> (change)</li></ul></li></ul></li></ul>');
			});
		});
	}

}
