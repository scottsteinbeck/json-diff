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
                expect(html).toBe('<ul><li><span style="font-weight:bold">a</span>: <span style="background: #ffbbbb;text-decoration: line-through;">1</span> <span style="background: #bbffbb;">2</span></li></ul>');
            });
        });
    }
}
