
document.write("<script language=javascript src='js/layer/layer/layer.js'></script>");
document.write("<script language=javascript src='js/popwindow.js'></script>");
document.write("<script language=javascript src='js/allLanguageHandler.js'></script>");
document.write("<script language=javascript src='js/AllHandlerForDialog.js'></script>");

function aHandler() {

    $("a").not(".notTab").each(function () {

        var title = $(this).html().replace('---&gt;', '').replace('--&gt;', '');

        var url = $(this).attr("href");
        var click = $(this).attr("onclick");


        //判断是否是tree，或者分页
        if (click != "" && click != null && click != undefined) {
            if (click.toLowerCase().indexOf("treeview") == -1 && url.toLowerCase().indexOf("lbt_delete") == -1) {
                $(this).click(function () {

                    if (url.indexOf("TakeTopAPPMain") == -1 && url.indexOf("TTAppTask") == -1 && url.indexOf("tencent:") == -1 && url.indexOf("tel:") == -1 && url.indexOf("#") == -1 && url.toLowerCase().indexOf(".doc") == -1 && url.toLowerCase().indexOf(".xls") == -1 && url.toLowerCase().indexOf(".mpp") == -1) {

                        top.frames[0].frames[2].parent.frames["rightTabFrame"].popShowByURL(url, title, 800, 600, window.location, window.location);
                        return false;
                    }

                    //top.frames[0].frames[2].parent.frames["rightTabFrame"].popShowByURL(url, title, 800, 600,window.location);


                });
            }
        }
        else if (title != ">" && title != "<" && (title.toLowerCase().indexOf("img") == -1 || url.toLowerCase().indexOf("treeview") == -1 || url.indexOf("TTDocumentTreeView") != -1 || url.indexOf("TakeTopAPPMain") == -1 || url.toLowerCase().indexOf("lbt_delete") == -1) && title != null && title != "" && title != "&gt;" && title != "&lt;") {
            $(this).click(function () {
                if (title.toLowerCase().indexOf("icon_del") == -1 && url.toLowerCase().indexOf("javascript") == -1 && url.toLowerCase().indexOf(".doc") == -1 && url.toLowerCase().indexOf(".xls") == -1 && url.toLowerCase().indexOf(".mpp") == -1) {

                    if (url.indexOf("TakeTopAPPMain") == -1 && url.indexOf("TTAppTask") == -1 && url.indexOf("tencent:") == -1 && url.indexOf("tel:") == -1 && url.indexOf("#") == -1) {

                        top.frames[0].frames[2].parent.frames["rightTabFrame"].popShowByURL(url, title, 800, 600, window.location, window.location);
                        return false;
                    }

                    //top.frames[0].frames[2].parent.frames["rightTabFrame"].popShowByURL(url, title, 800, 600,window.location);
                }
            });
        }

    });
}

//在当前窗口弹出窗口
function aHandlerForCurentWindow() {

    $("a").not(".notTab").each(function () {

        var title = $(this).html().replace('---&gt;', '').replace('--&gt;', '');

        var url = $(this).attr("href");
        var click = $(this).attr("onclick");


        //判断是否是tree，或者分页
        if (click != "" && click != null && click != undefined) {
            if (click.toLowerCase().indexOf("treeview") == -1 && url.toLowerCase().indexOf("lbt_delete") == -1) {
                $(this).click(function () {

                    if (url.indexOf("TakeTopAPPMain") == -1 && url.indexOf("TTAppTask") == -1 && url.indexOf("tencent:") == -1 && url.indexOf("tel:") == -1 && url.indexOf("#") == -1 && url.toLowerCase().indexOf(".doc") == -1 && url.toLowerCase().indexOf(".xls") == -1 && url.toLowerCase().indexOf(".mpp") == -1 && url.toLowerCase().indexOf(".zip") == -1 && url.toLowerCase().indexOf(".rar") == -1) {

                        popShowByURL(url, title, 800, 600, window.location, window.location);
                        return false;
                    }

                    //top.frames[0].frames[2].parent.frames["rightTabFrame"].popShowByURL(url, title, 800, 600,window.location);


                });
            }
        }
        else if (title != ">" && title != "<" && (title.toLowerCase().indexOf("img") == -1 || url.toLowerCase().indexOf("treeview") == -1 || url.indexOf("TTDocumentTreeView") != -1 || url.indexOf("TakeTopAPPMain") == -1 || url.toLowerCase().indexOf("lbt_delete") == -1) && title != null && title != "" && title != "&gt;" && title != "&lt;") {
            $(this).click(function () {
                if (title.toLowerCase().indexOf("icon_del") == -1 && url.toLowerCase().indexOf("javascript") == -1 && url.toLowerCase().indexOf(".doc") == -1 && url.toLowerCase().indexOf(".xls") == -1 && url.toLowerCase().indexOf(".mpp") == -1 && url.toLowerCase().indexOf(".zip") == -1 && url.toLowerCase().indexOf(".rar") == -1) {

                    if (url.indexOf("TakeTopAPPMain") == -1 && url.indexOf("TTAppTask") == -1 && url.indexOf("tencent:") == -1 && url.indexOf("tel:") == -1 && url.indexOf("#") == -1) {

                        popShowByURL(url, title, 800, 600, window.location, window.location);
                        return false;
                    }

                    //top.frames[0].frames[2].parent.frames["rightTabFrame"].popShowByURL(url, title, 800, 600,window.location);
                }
            });
        }

    });
}

//在网站顶部弹出窗口到内容层
function aHandlerForSiteTopWindow() {

    $("a").not(".notTab").each(function () {

        var title = $(this).html().replace('---&gt;', '').replace('--&gt;', '');

        var url = $(this).attr("href");
        var click = $(this).attr("onclick");


        //判断是否是tree，或者分页
        if (click != "" && click != null && click != undefined) {
            if (click.toLowerCase().indexOf("treeview") == -1 && url.toLowerCase().indexOf("lbt_delete") == -1) {
                $(this).click(function () {

                    if (url.indexOf("TakeTopAPPMain") == -1 && url.indexOf("TTAppTask") == -1 && url.indexOf("tencent:") == -1 && url.indexOf("tel:") == -1 && url.indexOf("#") == -1 && url.toLowerCase().indexOf(".doc") == -1 && url.toLowerCase().indexOf(".xls") == -1 && url.toLowerCase().indexOf(".mpp") == -1 && url.toLowerCase().indexOf(".zip") == -1 && url.toLowerCase().indexOf(".rar") == -1) {

                        try {
                            var rightFrame = parent.frames['SiteRightContainerFrame'] ||
                                parent.frames.SiteRightContainerFrame;
                            if (rightFrame && typeof rightFrame.popShowByURL === 'function') {
                                rightFrame.popShowByURL(url, title, 800, 600, window.location, window.location);
                            } else {
                                console.error('Target frame or method not found');
                            }
                        } catch (e) {
                            console.error('Error calling popShowByURL:', e);
                        }

                        return false;
                    }

                    //top.frames[0].frames[2].parent.frames["rightTabFrame"].popShowByURL(url, title, 800, 600,window.location);


                });
            }
        }
        else if (title != ">" && title != "<" && (title.toLowerCase().indexOf("img") == -1 || url.toLowerCase().indexOf("treeview") == -1 || url.indexOf("TTDocumentTreeView") != -1 || url.indexOf("TakeTopAPPMain") == -1 || url.toLowerCase().indexOf("lbt_delete") == -1) && title != null && title != "" && title != "&gt;" && title != "&lt;") {
            $(this).click(function () {
                if (title.toLowerCase().indexOf("icon_del") == -1 && url.toLowerCase().indexOf("javascript") == -1 && url.toLowerCase().indexOf(".doc") == -1 && url.toLowerCase().indexOf(".xls") == -1 && url.toLowerCase().indexOf(".mpp") == -1 && url.toLowerCase().indexOf(".zip") == -1 && url.toLowerCase().indexOf(".rar") == -1) {

                    if (url.indexOf("TakeTopAPPMain") == -1 && url.indexOf("TTAppTask") == -1 && url.indexOf("tencent:") == -1 && url.indexOf("tel:") == -1 && url.indexOf("#") == -1) {

                        try {
                            var rightFrame = parent.frames['SiteRightContainerFrame'] ||
                                parent.frames.SiteRightContainerFrame;
                            if (rightFrame && typeof rightFrame.popShowByURL === 'function') {
                                rightFrame.popShowByURL(url, title, 800, 600, window.location, window.location);
                            } else {
                                console.error('Target frame or method not found');
                            }
                        } catch (e) {
                            console.error('Error calling popShowByURL:', e);
                        }

                        return false;
                    }

                    //top.frames[0].frames[2].parent.frames["rightTabFrame"].popShowByURL(url, title, 800, 600,window.location);
                }
            });
        }

    });
}

//在网站底部弹出窗口到内容层
function aHandlerForSiteBottomWindow() {

    $("a").not(".notTab").each(function () {

        var title = $(this).html().replace('---&gt;', '').replace('--&gt;', '');

        var url = $(this).attr("href");
        var click = $(this).attr("onclick");



        //判断是否是tree，或者分页
        if (click != "" && click != null && click != undefined) {
            if (click.toLowerCase().indexOf("treeview") == -1 && url.toLowerCase().indexOf("lbt_delete") == -1) {
                $(this).click(function () {

                    if (url.indexOf("TakeTopAPPMain") == -1 && url.indexOf("TTAppTask") == -1 && url.indexOf("tencent:") == -1 && url.indexOf("tel:") == -1 && url.indexOf("#") == -1 && url.toLowerCase().indexOf(".doc") == -1 && url.toLowerCase().indexOf(".xls") == -1 && url.toLowerCase().indexOf(".mpp") == -1 && url.toLowerCase().indexOf(".zip") == -1 && url.toLowerCase().indexOf(".rar") == -1) {

                        if (parent.popShowByURL) {

                            alert("kkk");
                            parent.popShowByURL(url, title, 800, 600, window.location, window.location);
                        }
                        else {
                            alert("gggg");
                            parent.parent.popShowByURL(url, title, 800, 600, window.location, window.location);
                        }


                        return false;
                    }

                    //top.frames[0].frames[2].parent.frames["rightTabFrame"].popShowByURL(url, title, 800, 600,window.location);


                });
            }
        }
        else if (title != ">" && title != "<" && (title.toLowerCase().indexOf("img") == -1 || url.toLowerCase().indexOf("treeview") == -1 || url.indexOf("TTDocumentTreeView") != -1 || url.indexOf("TakeTopAPPMain") == -1 || url.toLowerCase().indexOf("lbt_delete") == -1) && title != null && title != "" && title != "&gt;" && title != "&lt;") {
            $(this).click(function () {
                if (title.toLowerCase().indexOf("icon_del") == -1 && url.toLowerCase().indexOf("javascript") == -1 && url.toLowerCase().indexOf(".doc") == -1 && url.toLowerCase().indexOf(".xls") == -1 && url.toLowerCase().indexOf(".mpp") == -1 && url.toLowerCase().indexOf(".zip") == -1 && url.toLowerCase().indexOf(".rar") == -1) {

                    if (url.indexOf("TakeTopAPPMain") == -1 && url.indexOf("TTAppTask") == -1 && url.indexOf("tencent:") == -1 && url.indexOf("tel:") == -1 && url.indexOf("#") == -1) {

                        if (parent.popShowByURL) {

                            parent.popShowByURL(url, title, 800, 600, window.location, window.location);
                        }
                        else {

                            parent.parent.popShowByURL(url, title, 800, 600, window.location, window.location);
                        }

                        return false;
                    }

                    //top.frames[0].frames[2].parent.frames["rightTabFrame"].popShowByURL(url, title, 800, 600,window.location);
                }
            });
        }

    });
}

function aHandlerForPopFixedSizeWindow() {

    $("a").not(".notTab").each(function () {

        var title = $(this).html().replace('---&gt;', '').replace('--&gt;', '');

        var url = $(this).attr("href");
        var click = $(this).attr("onclick");


        //判断是否是tree，或者分页
        if (click != "" && click != null && click != undefined) {
            if (click.toLowerCase().indexOf("treeview") == -1 && url.toLowerCase().indexOf("lbt_delete") == -1) {
                $(this).click(function () {

                    if (url.indexOf("TakeTopAPPMain") == -1 && url.indexOf("TTAppTask") == -1 && url.indexOf("tencent:") == -1) {

                        top.frames[0].frames[2].parent.frames["rightTabFrame"].popShowByURLForFixedSize(url, title, 800, 600, window.location, window.location);
                        return false;
                    }

                    //top.frames[0].frames[2].parent.frames["rightTabFrame"].popShowByURL(url, title, 800, 600,window.location);


                });
            }
        }
        else if (title != ">" && title != "<" && (title.toLowerCase().indexOf("img") == -1 || url.toLowerCase().indexOf("treeview") == -1 || url.indexOf("TTDocumentTreeView") != -1 || url.indexOf("TakeTopAPPMain") == -1 || url.toLowerCase().indexOf("lbt_delete") == -1) && title != null && title != "" && title != "&gt;" && title != "&lt;") {
            $(this).click(function () {
                if (title.toLowerCase().indexOf("icon_del") == -1 && url.toLowerCase().indexOf("javascript") == -1) {

                    if (url.indexOf("TakeTopAPPMain") == -1 && url.indexOf("TTAppTask") == -1 && url.indexOf("tencent:") == -1) {

                        top.frames[0].frames[2].parent.frames["rightTabFrame"].popShowByURLForFixedSize(url, title, 800, 600, window.location, window.location)
                        return false;
                    }

                    //top.frames[0].frames[2].parent.frames["rightTabFrame"].popShowByURL(url, title, 800, 600,window.location);


                }
            });
        }

    });
}

//使链接打开的窗口在框架内，用于自定义表单页面
function aHandlerForWorkflowDIYFormDataPopWindow(e) {
    e = e || event;
    var target = e.target || e.srcElement,
        url;
    if (target.tagName === 'A') {

        url = target.href;
        title = target.innerText;

    } else if (target.tagName === 'SPAN') {

        //父标签onclick属性的值
        url = target.parentNode.href;
        if (url === 'undefined' || url === null || url === "") {
            return;
        }
        title = target.innerText;
    }

    if (url.toUpperCase().indexOf("TTUserInforSimple.aspx".toUpperCase()) !== -1 || url.toUpperCase().indexOf("TTWorkFlowViewMain.aspx".toUpperCase()) !== -1
        || url.toUpperCase().indexOf("TTWFChartView".toUpperCase()) !== -1 || url.toUpperCase().indexOf("TTWLRelatedDoc.aspx".toUpperCase()) !== -1
    ) {

        top.frames[0].frames[2].parent.frames["rightTabFrame"].popShowByURL(url, title, 800, 600, window.location, window.location)

        stopDefault(e);
    }
}

//取消事件的默认行为
function stopDefault(e) {
    if (e && e.preventDefault) {
        e.preventDefault();
    } else {
        window.event.returnValue = false;
    }
}

//工作流表单数据显示，弹出顶层框架的层，调用当前方法
function aHandlerForWorkflowCommonFormDataPopWindow() {

    $("a").not(".notTab").each(function () {

        var title = $(this).html().replace('---&gt;', '').replace('--&gt;', '');

        var url = $(this).attr("href");
        var click = $(this).attr("onclick");

        //判断是否是tree，或者分页
        if (click !== "") {

            $(this).click(function () {

                if (url.indexOf("TakeTopAPPMain") == -1 && url.indexOf("TTAppTask") == -1 && url.indexOf("NoPop=YES") == -1) {

                    top.frames[0].frames[2].parent.frames["rightTabFrame"].popShowByURL(url, title, 800, 600, window.location, window.location)


                    return false;
                }

            });

        }

    });
}


//弹出顶层框架的层，调用当前方法
function aHandlerForSpecialPopWindow() {
    $("a").not(".notTab").each(function () {

        var title = $(this).html().replace('---&gt;', '').replace('--&gt;', '');

        var url = $(this).attr("href");
        var click = $(this).attr("onclick");


        //判断是否是tree，或者分页
        if (click != "" && click != null && click != undefined) {
            if (click.toLowerCase().indexOf("treeview") == -1 && url.toLowerCase().indexOf("lbt_delete") == -1) {
                $(this).click(function () {

                    if (top.frames[0].frames[2].parent.document.getElementById("rightFrame").rows != '40,*') {

                        /*  top.frames[0].frames[2].parent.document.getElementById("rightFrame").rows = '40,*';*/

                        if (url != "https://www.taketopits.com" & url != "TTTakeTopIM.aspx" & url != "TTUnHandledCaseMain.aspx") {

                            /* top.frames[0].frames[2].parent.frames["rightTabFrame"].addTab("PersonalSpace", "TakeTopPersonalSpace.aspx", "new");*/
                        }
                    }

                    if (url.indexOf("TakeTopAPPMain") == -1 && url.indexOf("TTAppTask") == -1) {

                        top.frames[0].frames[2].parent.frames["rightTabFrame"].popShowByURL(url, title, 800, 600, window.location, window.location)


                        return false;
                    }

                });
            }
        }
        else if (title != ">" && title != "<" && (title.toLowerCase().indexOf("img") == -1 || url.toLowerCase().indexOf("treeview") == -1 || url.indexOf("TTDocumentTreeView") != -1 || url.indexOf("TakeTopAPPMain") == -1 || url.toLowerCase().indexOf("lbt_delete") == -1) && title != null && title != "" && title != "&gt;" && title != "&lt;") {
            $(this).click(function () {
                if (title.toLowerCase().indexOf("icon_del") == -1 && url.toLowerCase().indexOf("javascript") == -1) {

                    if (top.frames[0].frames[2].parent.document.getElementById("rightFrame").rows != '40,*') {

                        /*   top.frames[0].frames[2].parent.document.getElementById("rightFrame").rows = '40,*';*/

                        if (url != "https://www.taketopits.com" & url != "TTTakeTopIM.aspx" & url != "TTUnHandledCaseMain.aspx") {

                            /*  top.frames[0].frames[2].parent.frames["rightTabFrame"].addTab("PersonalSpace", "TakeTopPersonalSpace.aspx", "new");*/
                        }
                    }

                    if (url.indexOf("TakeTopAPPMain") == -1 && url.indexOf("TTAppTask") == -1) {

                        top.frames[0].frames[2].parent.frames["rightTabFrame"].popShowByURL(url, title, 800, 600, window.location, window.location)

                        return false;
                    }

                }
            });
        }

    });
}


//弹出顶层框架的层，调用当前方法
function aHandlerForPersonalSpaceIOSAddTab() {
    $("a").not(".notTab").each(function () {

        var title = $(this).html().replace('---&gt;', '').replace('--&gt;', '');

        var url = $(this).attr("href");
        var click = $(this).attr("onclick");

        //判断是否是tree，或者分页
        if (click != "" && click != null && click != undefined) {

            if (click.toLowerCase().indexOf("treeview") == -1 && url.toLowerCase().indexOf("lbt_delete") == -1) {
                $(this).click(function () {

                    if (top.frames[2].parent.document.getElementById("rightFrame").rows != '40,*') {

                        /*   top.frames[2].parent.document.getElementById("rightFrame").rows = '40,*';*/

                        if (url != "https://www.taketopits.com" & url != "TTTakeTopIM.aspx" & url != "TTUnHandledCaseMain.aspx") {

                            /*  top.frames[2].parent.frames["rightTabFrame"].addTab("PersonalSpace", "TakeTopPersonalSpace.aspx", "new");*/
                        }
                    }

                    if (url.indexOf("TakeTopAPPMain") == -1 && url.indexOf("TTAppTask") == -1) {

                        top.frames[2].parent.frames["rightTabFrame"].addTab(title, url, "old");

                        return false;
                    }

                });
            }
        }
        else if (title != ">" && title != "<" && (title.toLowerCase().indexOf("img") == -1 || url.toLowerCase().indexOf("treeview") == -1 || url.indexOf("TTDocumentTreeView") != -1 || url.indexOf("TakeTopAPPMain") == -1 || url.toLowerCase().indexOf("lbt_delete") == -1) && title != null && title != "" && title != "&gt;" && title != "&lt;") {
            $(this).click(function () {

                if (title.toLowerCase().indexOf("icon_del") == -1 && url.toLowerCase().indexOf("javascript") == -1) {

                    if (top.frames[2].parent.document.getElementById("rightFrame").rows != '40,*') {

                        /*  top.frames[2].parent.document.getElementById("rightFrame").rows = '40,*';*/

                        if (url != "https://www.taketopits.com" & url != "TTTakeTopIM.aspx" & url != "TTUnHandledCaseMain.aspx") {

                            /*  top.frames[2].parent.frames["rightTabFrame"].addTab("PersonalSpace", "TakeTopPersonalSpace.aspx", "new");*/
                        }
                    }

                    if (url.indexOf("TakeTopAPPMain") == -1 && url.indexOf("TTAppTask") == -1) {

                        top.frames[2].parent.frames["rightTabFrame"].addTab(title, url, "old");

                        return false;
                    }

                }
            });
        }

    });
}


//判断是否关闭当前TAB
function aHandlerForTab() {
    $("a").not(".notTab").each(function () {

        var title = $(this).html().replace('---&gt;', '').replace('--&gt;', '');

        var url = $(this).attr("href");
        var click = $(this).attr("onclick");


        //判断是否是tree，或者分页
        if (click != "" && click != null && click != undefined) {
            if (click.toLowerCase().indexOf("treeview") == -1 && url.toLowerCase().indexOf("lbt_delete") == -1 && url.toLowerCase().indexOf("javascript") == -1) {
                $(this).click(function () {

                    if (top.frames[0].frames[2].parent.document.getElementById("rightFrame").rows != '40,*') {

                        top.frames[0].frames[2].parent.document.getElementById("rightFrame").rows = '40,*';

                        if (url != "http://www.taketopits.com" & url != "TTTakeTopIM.aspx" & url != "TTUnHandledCaseMain.aspx") {

                            top.frames[0].frames[2].parent.frames["rightTabFrame"].addTab(currentParentPageTitle(), currentParentPageName(), "old");

                        }
                    }

                    top.frames[0].frames[2].parent.frames["rightTabFrame"].addTab(title, url, "old");

                    return false;

                });
            }
        }
        else if (title != ">" && title != "<" && (title.toLowerCase().indexOf("img") == -1 || url.toLowerCase().indexOf("treeview") == -1 || url.indexOf("TTDocumentTreeView") != -1 || url.indexOf("TakeTopAPPMain") == -1 || url.toLowerCase().indexOf("lbt_delete") == -1) && title != null && title != "" && title != "&gt;" && title != "&lt;") {
            $(this).click(function () {
                if (title.toLowerCase().indexOf("icon_del") == -1 && url.toLowerCase().indexOf("javascript") == -1) {

                    if (top.frames[0].frames[2].parent.document.getElementById("rightFrame").rows != '40,*') {

                        top.frames[0].frames[2].parent.document.getElementById("rightFrame").rows = '40,*';

                        if (url != "http://www.taketopits.com" & url != "TTTakeTopIM.aspx" & url != "TTUnHandledCaseMain.aspx") {

                            top.frames[0].frames[2].parent.frames["rightTabFrame"].addTab("PersonalSpace", "TakeTopPersonalSpace.aspx", "new");

                        }
                    }

                    top.frames[0].frames[2].parent.frames["rightTabFrame"].addTab(title, url, "old");

                    return false;
                }
            });
        }

    });
}

// 在页面侧边栏打开窗口，带回调函数的版本（支持放大/缩小）
function openRightLayer(pageName, titleName) {
    layer.open({
        type: 2,
        title: titleName,
        content: pageName,
        area: ['460px', '800px'],  // 默认尺寸
        offset: 'r',               // 右侧弹出
        shade: 0,                  // 无遮罩
        fixed: true,               // 固定位置
        zIndex: layer.zIndex,      // 使用 layer 管理的 z-index
        maxmin: true,              // 启用最大化/最小化按钮
        resize: true,              // 允许调整大小（可选）
        move: false,               // 禁止拖动
        success: function (layero, index) {
            // 手动设置更高 z-index
            layero.css('z-index', layer.zIndex + 1);
        }
    });
}

//AI-设置右边AI窗口的AI提示词文本
function setAIWindowPromptText(text) {

    var iframe = top.frames[0].document.getElementById("rightTabFrameID");
    var iframeDoc = iframe.contentDocument || iframe.contentWindow.document;


    var divArr = jQuery(iframeDoc).find('div[class="layui-layer-title"]');


    var div = null;
    for (var i = 0; i < divArr.length; i++) {
        if (jQuery(divArr[i]).text() == "TakeTopAI") {
            div = divArr[i];
            break;
        }
    }
    if (div) {
        jQuery(div).next().find('iframe').contents().find("#txtPrompt").text(text);
    }
}

//AI-取得右边AI窗口的AI查询返回值文本
function getAIWindowReturnText() {

    var iframe = top.frames[0].document.getElementById("rightTabFrameID");
    var iframeDoc = iframe.contentDocument || iframe.contentWindow.document;
    var divArr = jQuery(iframeDoc).find('div[class="layui-layer-title"]');
    var div = null;
    for (var i = 0; i < divArr.length; i++) {
        if (jQuery(divArr[i]).text() == "TakeTopAI") {
            div = divArr[i];
            break;
        }
    }
    if (div) {

        //document.getElementById('_0_0_my:TxtQueryPutValue').innerText = jQuery(div).next().find('iframe').contents().find("#txtPrompt").text();
        //document.getElementById('_0_1_my:TxtQueryReturnValue').innerText = jQuery(div).next().find('iframe').contents().find("#lblGeneratedText").text();

        return jQuery(div).next().find('iframe').contents().find("#lblGeneratedText").text();
    }
    return '';
}

//AI-调用AI接口一般处理程序 
async function callAIWithFetch(promptWord) {
    try {
        const response = await jQuery.ajax({
            url: 'Handler/AIHandleForQuery.ashx',
            type: 'POST',
            data: { promptWord: promptWord },
            dataType: 'text', // 先接收 text，再手动解析 JSON
        });

        console.log("Raw response:", response);

        // 尝试解析 JSON（如果返回的是 JSON 字符串）
        try {
            const jsonData = JSON.parse(response);
            if (jsonData && jsonData.success !== undefined) {
                return jsonData; // 如果是 JSON 格式
            }
            return response; // 如果不是 JSON 格式
        } catch (e) {
            return response; // 纯文本直接返回
        }

    } catch (error) {
        console.error("Error invoking AI:", error);
        throw error;
    }
}


//判断是否关闭当前窗口
function CloseWebPage() {
    if (navigator.userAgent.indexOf("MSIE") > 0) {
        if (navigator.userAgent.indexOf("MSIE 6.0") > 0) {
            window.opener = null;
            window.close();
        } else {
            window.open('', '_top');
            window.top.close();
        }
    }
    else if (navigator.userAgent.indexOf("Firefox") > 0) {
        window.location.href = 'about:blank ';
    }
    else {
        window.opener = null;
        window.open('', '_self', '');
        window.close();
    }
}

//判断是否关闭当前TAB
function CloseTab(msgText) {

    var con;
    con = confirm(msgText); //在页面上弹出对话框
    if (con == true) {

        var mylay = parent.parent.layer.getFrameIndex(parent.window.name);
        if (mylay != null) {

            parent.parent.layer.close(mylay);

        }
        else {

            /* top.frames[0].frames[2].parent.frames["rightTabFrame"].CloseCurrentTabPage();*/

            top.frames[0].frames[2].parent.frames["rightTabFrame"].CloseCurrentTabPageAndOpenSpecialPage();

        }
    }
}

//判断是否关闭所有TAB，并增加一TAB
function CloseAllTabAndAddNewTab(msgText) {

    var con;
    con = confirm(msgText); //在页面上弹出对话框
    if (con == true) {

        var mylay = parent.parent.layer.getFrameIndex(parent.window.name);
        if (mylay != null) {

            parent.parent.layer.close(mylay);

        }
        else {
            if (top.frames[0].frames[2].parent.frames["rightTabFrame"].intTabIndex > 2) {
                top.frames[0].frames[2].parent.frames["rightTabFrame"].CloseCurrentTabPage();
            }
            else {
                top.frames[0].frames[2].parent.frames["rightTabFrame"].CloseCurrentTabPageAndOpenSpecialPage();
            }

        }
    }
}

//隐藏和显示当前弹出层‘关闭’按钮
function HideAndDisplayCurrentlayerCloseButton(varVisible) {

    try {
        var varCloseButtons = top.frames[0].frames[2].parent.frames["rightTabFrameID"].contentWindow.document.getElementsByClassName("layui-layer-ico layui-layer-close layui-layer-close1");
        top.frames[0].frames[2].parent.frames["rightTabFrameID"].contentWindow.document.getElementsByClassName("layui-layer-ico layui-layer-close layui-layer-close1")[varCloseButtons.length - 1].style.display = varVisible;
    }
    catch
    {
    }
}


//判断是否关闭当前层
function CloseLayer() {

    var mylay = parent.layer.getFrameIndex(this.window.name);

    //alert(this.window.name);

    if (mylay != null) {

        //alert(this.window.name);
        parent.layer.close(mylay);
    }
}

//判断是否关闭当前层
function CloseCurrentLayer(msgText) {

    var con;
    con = confirm(msgText); //在页面上弹出对话框
    if (con == true) {

        var mylay = parent.parent.layer.getFrameIndex(parent.window.name);
        if (mylay != null) {
            parent.parent.layer.close(mylay);
        }
        else {

            top.frames[0].frames[2].parent.frames["rightTabFrame"].CloseCurrentTabPageAndOpenSpecialPage();
        }

    }
}


//取当前页面名称(带后缀名)
function currentPageName() {
    var strUrl = location.href;
    var arrUrl = strUrl.split("/");
    var strPage = arrUrl[arrUrl.length - 1];
    return strPage;
}

//取当前页面父页面名称(带后缀名)
function currentParentPageName() {
    var strUrl = location.parent.href;
    var arrUrl = strUrl.split("/");

    var strPage = arrUrl[arrUrl.length - 1];
    return strPage;
}


//取父页面Title
function currentParentPageTitle() {

    var strTitle = parent.location.title;

    return strTitle;
}


//用于点击APP里的DATAGRID行任一点，就打开行里的一链接
//一般结构设置行点击
function setTrClickLink(gridId) {
    //阻止事件冒泡
    jQuery("#" + gridId).find("tr:not(.notTab)").find("a").click(function () {
        event.stopPropagation();
    });

    //tr点击跳转
    jQuery("#" + gridId).find("tr:not(.notTab)").find("a").closest("tr").click(function () {
        location.href = $(this).find("a").attr("href");
    });
}

//特殊结构设置行点击
function setTrClickLinkSpec(gridId) {
    //阻止事件冒泡
    jQuery("#" + gridId).find("tr:not(.notTab)").find("a").click(function () {
        event.stopPropagation();
    });

    //tr点击跳转
    jQuery("#" + gridId).find("tr:not(.notTab)").find("a").closest("table").closest("tr").click(function () {
        location.href = $(this).find("a").attr("href");
    });
}


//用于APP，向右滑动返回上一页
function swiperRightToBack(backId) {
    //修改触发像素大小  
    jQuery.event.special.swipe.horizontalDistanceThreshold = 100;
    jQuery("body").on("swiperight", function () {
        jQuery("#" + backId).click();
    });
}


//获取指定名称的cookie的值
function getcookie(objname) {
    var arrstr = document.cookie.split("; ");
    for (var i = 0; i < arrstr.length; i++) {
        var temp = arrstr[i].split("=");
        if (temp[0] == objname) return unescape(temp[1]);
    }
}



//检测设备是否是移动端
function detectmob() {
    if (navigator.userAgent.match(/Android/i)
        || navigator.userAgent.match(/webOS/i)
        || navigator.userAgent.match(/iPhone/i)
        || navigator.userAgent.match(/iPad/i)
        || navigator.userAgent.match(/iPod/i)
        || navigator.userAgent.match(/BlackBerry/i)
        || navigator.userAgent.match(/Windows Phone/i)
    ) {
        return true;
    }
    else {
        return false;
    }
}

// 判断安卓
function isAndroid() {
    var u = navigator.userAgent;
    if (u.indexOf("Android") > -1 || u.indexOf("Linux") > -1) {
        if (window.ShowFitness !== undefined) return true;
    }
    return false;
}
// 判断设备为 ios
function isIos() {
    var u = navigator.userAgent;
    if (u.indexOf("iPhone") > -1 || u.indexOf("iOS") > -1) {
        return true;
    }
    return false;
}

//取得链接传入参数的值
function getUrlParam(name) {
    var reg = new RegExp("(^|&)" + name + "=([^&]*)(&|$)");
    var r = window.location.search.substr(1).match(reg);
    if (r != null) return unescape(r[2]); return null;
}


//--------------------物资管理模块的方法----------------------------------

//--------------------打开人员选择窗口------------------------------------
function SelectEmployee(url, id, name) {
    popShowByURLForFixedSize(url + (url.indexOf("?") == -1 ? "?" : "&") + "ctrlId=" + id + "&ctrlName=" + name, '选择人员', 600, 500);
}

function AlertProjectPage(url) {
    popShowByURLForFixedSize(url, '', 1200, 500);
}

function SelectDLCode(url, id, name) {

    popShowByURLForFixedSize(url + (url.indexOf("?") == -1 ? "?" : "&") + "ctrlId=" + id + "&ctrlName=" + name, '选择物料类型', 600, 500);

}

// 选择供应商
function SelectSupplier(id, name) {
    var url = "TTWZSelectorSupplier.aspx";

    popShowByURLForFixedSize(url + (url.indexOf("?") == -1 ? "?" : "&") + "ctrlId=" + id + "&ctrlName=" + name, '选择供应商', 600, 500);
}


//选择库别
function SelectStock(id, name) {

    var url = "TTWZSelectorStock.aspx";

    popShowByURLForFixedSize(url + (url.indexOf("?") == -1 ? "?" : "&") + "ctrlId=" + id + "&ctrlName=" + name, '选择库别', 900, 500);
}

//选择领料单位
function OnClickPickingUnit(id, name) {
    var url = "TTWZSelectorDepartment2.aspx";

    popShowByURLForFixedSize(url + (url.indexOf("?") == -1 ? "?" : "&") + "ctrlId=" + id + "&ctrlName=" + name, '选择部门', 600, 500);

}

//隐藏没有数据的分析图
function hideIframesForNoDataAnalystChart(callback) {
    // 遍历所有 iframe 控件
    $('iframe').each(function () {
        var iframe = this;

        // 等待 iframe 加载完成后再执行
        $(iframe).on('load', function () {
            // 获取 iframe 内部的文档对象
            var doc = iframe.contentWindow.document;

            // 查找 id 为 m2 的元素
            var m2 = $(doc).find('#m2');

            // 查找 m2 下的 canvas 元素
            var canvas = m2.find('canvas');

            if (canvas.length == 1) {
                $(iframe).hide();
            } else {
                $(iframe).show();
            }

            // 如果所有 iframe 都处理完成，执行回调函数
            if ($('iframe').length == $('iframe:hidden').length) {
                callback();
            }
        });
    });
}


//------------------APP端右滑返回主页功能开始--------------------------
function initSwipeBack() {
    var startX = 0;
    var startY = 0;
    var threshold = 100; // 滑动距离阈值
    var restraint = 100; // 垂直滑动限制
    var feedbackShown = false;

    // 页面加载时显示提示
    showSwipeFeedback();

    // 触摸开始 - 立即隐藏提示
    document.addEventListener('touchstart', function (e) {
        startX = e.touches[0].pageX;
        startY = e.touches[0].pageY;

        // 用户开始操作，立即隐藏提示
        hideSwipeFeedback();
        feedbackShown = true;
    });

    // 触摸结束
    document.addEventListener('touchend', function (e) {
        if (!startX) return;

        var endX = e.changedTouches[0].pageX;
        var endY = e.changedTouches[0].pageY;
        var distX = endX - startX;
        var distY = Math.abs(endY - startY);

        // 检查是否为有效的右滑
        if (distX >= threshold && distY <= restraint) {
            // 触发返回链接的点击事件
            triggerBackLink();
        }

        // 重置
        startX = 0;
        startY = 0;
    });

    // 点击页面任何地方也隐藏提示
    document.addEventListener('click', function () {
        hideSwipeFeedback();
        feedbackShown = true;
    });
}

function showSwipeFeedback() {
    var feedback = document.getElementById('swipeFeedback');
    if (feedback) {
        feedback.style.display = 'block';
        feedback.style.animation = 'fadeInOut 3s ease-in-out forwards';
    }
}

function hideSwipeFeedback() {
    var feedback = document.getElementById('swipeFeedback');
    if (feedback) {
        feedback.style.display = 'none';
        feedback.style.animation = 'none';
    }
}

function triggerBackLink() {
    console.log('执行返回主页');

    // 显示等待指示器
    var waitingImg = document.getElementById('IMG_Waiting');
    if (waitingImg) {
        waitingImg.style.display = 'block';
    }

    // 导航到主页
    setTimeout(function () {
        this.document.getElementById("aAPPBackPriorPage").click();
    }, 300);
}
//------------------APP端右滑返回主页功能结束--------------------------


//------------------在鼠标位置加载等待图标处理开始--------------------------
(function () {
    // 配置参数
    var config = {
        containerId: 'progressContainer', // 容器ID
        iconOffset: 50,                   // 左侧偏移量（鼠标左边50px）
        verticalOffset: 10,               // 垂直偏移量
        minLeft: 10,                      // 最小左边距
        debug: false                      // 调试模式
    };

    var mouseX = 0, mouseY = 0;
    var isInitialized = false;

    // 工具函数：日志输出
    function log(message) {
        if (config.debug && console && console.log) {
            console.log('[LoadingIcon] ' + message);
        }
    }

    // 工具函数：检查元素是否存在
    function elementExists(id) {
        return document.getElementById(id) !== null;
    }

    // 捕获鼠标位置
    function trackMousePosition(e) {
        mouseX = e.pageX || e.clientX + document.documentElement.scrollLeft;
        mouseY = e.pageY || e.clientY + document.documentElement.scrollTop;
    }

    // 显示加载图标
    function showLoadingIcon() {
        var container = document.getElementById(config.containerId);
        if (!container) {
            log('容器元素未找到: ' + config.containerId);
            return;
        }

        // 计算左侧位置
        var leftPosition = mouseX - config.iconOffset;
        if (leftPosition < config.minLeft) {
            leftPosition = config.minLeft;
        }

        // 应用新位置
        container.style.left = leftPosition + 'px';
        container.style.top = (mouseY + config.verticalOffset) + 'px';
        container.style.display = 'block';

        log('显示加载图标在位置: ' + leftPosition + ', ' + (mouseY + config.verticalOffset));
    }

    // 隐藏加载图标
    function hideLoadingIcon() {
        var container = document.getElementById(config.containerId);
        if (container) {
            container.style.display = 'none';
            log('隐藏加载图标');
        }
    }

    // 初始化函数
    function initialize() {
        if (isInitialized) {
            log('已经初始化过');
            return;
        }

        // 检查容器是否存在
        if (!elementExists(config.containerId)) {
            log('等待容器元素...');
            setTimeout(initialize, 100);
            return;
        }

        log('找到容器元素: ' + config.containerId);

        // 检查ASP.NET AJAX框架
        if (typeof Sys === 'undefined') {
            log('等待Sys对象...');
            setTimeout(initialize, 100);
            return;
        }

        // 检查PageRequestManager
        if (typeof Sys.WebForms === 'undefined' ||
            typeof Sys.WebForms.PageRequestManager === 'undefined') {
            log('等待PageRequestManager...');
            setTimeout(initialize, 100);
            return;
        }

        try {
            var prm = Sys.WebForms.PageRequestManager.getInstance();

            if (!prm) {
                log('无法获取PageRequestManager实例');
                return;
            }

            // 绑定鼠标事件
            document.addEventListener('mousemove', trackMousePosition);
            document.addEventListener('click', trackMousePosition);

            // 绑定ASP.NET AJAX事件
            prm.add_beginRequest(function (sender, args) {
                log('AJAX请求开始');
                showLoadingIcon();
            });

            prm.add_endRequest(function (sender, args) {
                log('AJAX请求结束');
                hideLoadingIcon();
            });

            isInitialized = true;
            log('初始化成功');

        } catch (error) {
            log('初始化错误: ' + error.message);

            // 如果ASP.NET AJAX不可用，尝试其他方法
            setTimeout(function () {
                if (!isInitialized) {
                    initializeAlternative();
                }
            }, 500);
        }
    }

    // 备选初始化方法（不使用ASP.NET AJAX）
    function initializeAlternative() {
        log('尝试备选初始化方法');

        // 监听所有表单提交
        document.addEventListener('submit', function (e) {
            var form = e.target;
            if (form && form.tagName === 'FORM') {
                setTimeout(showLoadingIcon, 10);
            }
        });

        // 监听所有按钮点击
        document.addEventListener('click', function (e) {
            var target = e.target;
            if (target && (target.tagName === 'BUTTON' ||
                target.tagName === 'INPUT' &&
                (target.type === 'submit' || target.type === 'button'))) {
                setTimeout(showLoadingIcon, 10);
            }
        });

        // 监听所有链接点击
        document.addEventListener('click', function (e) {
            var target = e.target;
            while (target && target.tagName !== 'A') {
                target = target.parentNode;
            }
            if (target && target.tagName === 'A' &&
                target.href && !target.href.startsWith('javascript:')) {
                setTimeout(showLoadingIcon, 10);
            }
        });

        // 页面卸载时隐藏
        window.addEventListener('beforeunload', hideLoadingIcon);

        isInitialized = true;
        log('备选初始化成功');
    }

    // 公共API（如果需要从外部调用）
    window.LoadingIcon = {
        config: config,
        show: showLoadingIcon,
        hide: hideLoadingIcon,
        refresh: function () {
            if (elementExists(config.containerId)) {
                showLoadingIcon();
            }
        }
    };

    // 启动初始化
    if (document.readyState === 'loading') {
        document.addEventListener('DOMContentLoaded', initialize);
    } else {
        setTimeout(initialize, 0);
    }

})();

//------------------在鼠标位置加载等待图标处理结束--------------------------