/**
* Tests for the summary method
*/
component extends="testbox.system.BaseSpec"{
        function beforeAll(){
                jsondiff = new models.jsondiff();
        }

        function run(){
                describe("Test Summary", ()=>{
                        it("counts diff types", ()=>{
                                var diffs = jsondiff.diff({a:1},{a:2,b:3});
                                expect(jsondiff.summary(diffs)).toBe({
                                        add:1,
                                        remove:0,
                                        change:1,
                                        update:0
                                });
                        });
                        it("counts removals", ()=>{
                                var diffs = jsondiff.diff({ "a": 1, "b": 2 }, { "a": 1 });
                                expect(jsondiff.summary(diffs)).toBe({
                                        add: 0,
                                        remove: 1,
                                        change: 0,
                                        update: 0
                                });
                        });
                        it("counts a grouped diff", ()=>{
                                var diffs = jsondiff.diffByKey(
                                        [{ "id": 1, "name": "a" }],
                                        [{ "id": 1, "name": "b" }, { "id": 2, "name": "c" }],
                                        "id"
                                );
                                expect(jsondiff.summary(diffs)).toBe({
                                        add: 1,
                                        remove: 0,
                                        change: 0,
                                        update: 1
                                });
                        });
                        it("counts an empty diff", ()=>{
                                expect(jsondiff.summary([])).toBe({
                                        add: 0,
                                        remove: 0,
                                        change: 0,
                                        update: 0
                                });
                        });
                });
        }
}
