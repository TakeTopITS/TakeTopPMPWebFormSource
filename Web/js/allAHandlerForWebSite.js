
document.write("<script language=javascript src='../../../js/layer/layer/layer.js'></script>");
document.write("<script language=javascript src='../../../js/popwindow.js'></script>");
document.write("<script language=javascript src='../../../js/allLanguageHandler.js'></script>");
document.write("<script language=javascript src='../../../js/AllHandlerForDialog.js'></script>");

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

