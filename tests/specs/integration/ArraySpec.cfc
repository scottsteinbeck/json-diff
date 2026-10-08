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
		describe("Test Array Functions", ()=>{
			it("top level array & array diff", () => {
				expect(jsondiff.diff(["test", "testing"], ["test"])).toBe([
					{
						"type": "REMOVE",
						"path": [2],
						"old": "testing",
						"new": ""
					}
				]);
			});

			it("nested array", () => {
				expect(jsondiff.diff(["test", ["test"]], ["test", ["test", "test2"]])).toBe(
					[{
						"type":"ADD",
						"path":[2,2],
						"old":"",
						"new":"test2"
					}]
				);
			});

			it("appends an item", () => {
				expect(jsondiff.diff(["test"], ["test", "testing"])).toBe([
					{
						"type": "ADD",
						"path": [2],
						"old": "",
						"new": "testing"
					}
				]);
			});

			it("diffs empty arrays", () => {
				expect(jsondiff.diff([], [])).toBe([]);
				expect(jsondiff.diff([], ["test"])).toBe([
					{
						"type": "ADD",
						"path": [1],
						"old": "",
						"new": "test"
					}
				]);
			});

			it("changes a number in an array", () => {
				expect(jsondiff.diff([1], [2])).toBe([
					{
						"type": "CHANGE",
						"path": [1],
						"old": 1,
						"new": 2
					}
				]);
			});

			it("identical arrays have no diff", () => {
				var scaled = createObject("java", "java.math.BigDecimal").init("18.110");
				expect(jsondiff.diff(["test"], ["test"])).toBe([]);
				expect(jsondiff.diff([18.11], [scaled])).toBe([]);
			});

			it("object in array in object", () => {
				expect(
					jsondiff.diff(
						{ test: ["test", { test: true }] },
						{ test: ["test", { test: false }] }
					)).toBe(
					[
						{
							"type": "CHANGE",
							"path": ["test", 2, "test"],
							"key": "test",
							"old": true,
							"new": false,
						},
					]
				);
			});

			it("array add null value", () => {
				expect(
					jsondiff.diff(
						{ test: [] },
						{ test: [nullValue()] }
					)).toBe([
						{"path":["TEST",1],"old":"","type":"ADD","new":""}
				]);
			});

			it("array remove null value", () => {
				expect(
					jsondiff.diff(
						{ test: [nullValue()] },
						{ test: [] }
					)).toBe([
						{"path":["TEST",1],"old":"","type":"REMOVE","new":""}
				]);
			});

			it("array change null value", () => {
				expect(
					jsondiff.diff(
						{ test: [nullValue()] },
						{ test: ["foo"] }
					)).toBe([
						{"path":["TEST",1],"old":"","type":"CHANGE","new":"foo"}
				]);
			});
		})
	}

}
