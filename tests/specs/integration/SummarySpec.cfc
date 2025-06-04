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
                });
        }
}
