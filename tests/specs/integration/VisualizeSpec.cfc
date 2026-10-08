/**
* Tests for the visualizeDiff method
*/
component extends="testbox.system.BaseSpec"{
    function beforeAll(){
        jsondiff = new models.jsondiff();
    }

    function run(){
        describe("Test VisualizeDiff", ()=>{
            it("outputs html", ()=>{
                var html = jsondiff.visualizeDiff({a:1},{a:2});
                expect(html).toBe('<ul><li><span style="font-weight:bold">a</span>: <span style="background: ##ffbbbb;text-decoration: line-through;">1</span> <span style="background: ##bbffbb;">2</span></li></ul>');
            });
            it("renders an added value", ()=>{
                expect(jsondiff.visualizeDiff({}, { "a": 1 })).toBe('<ul><li><span style="font-weight:bold">a</span>: <span style="background: ##bbffbb;">1</span></li></ul>');
            });
            it("renders a removed value", ()=>{
                expect(jsondiff.visualizeDiff({ "a": 1 }, {})).toBe('<ul><li><span style="font-weight:bold">a</span>: <span style="background: ##ffbbbb;text-decoration: line-through;">1</span></li></ul>');
            });
            it("renders an unchanged value", ()=>{
                expect(jsondiff.visualizeDiff({ "a": 1 }, { "a": 1 })).toBe('<ul><li><span style="font-weight:bold">a</span>: <span style="color:##666">1</span></li></ul>');
            });
            it("leaves ignored keys unchanged in the html", ()=>{
                var original = structNew("ordered");
                original["a"] = 1;
                original["dirty"] = true;
                var updated = structNew("ordered");
                updated["a"] = 2;
                updated["dirty"] = false;
                expect(jsondiff.visualizeDiff(original, updated, ["dirty"])).toBe('<ul><li><span style="font-weight:bold">a</span>: <span style="background: ##ffbbbb;text-decoration: line-through;">1</span> <span style="background: ##bbffbb;">2</span></li><li><span style="font-weight:bold">dirty</span>: <span style="color:##666">true</span></li></ul>');
            });
        });
    }
}
