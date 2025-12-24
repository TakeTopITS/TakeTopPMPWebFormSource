
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
    // 保存每个层的原始状态
    window.layerStates = window.layerStates || {};

    layer.open({
        type: 2,
        title: titleName,
        content: pageName,
        area: ['460px', '800px'],
        offset: 'rb',
        shade: 0,
        fixed: false,
        zIndex: layer.zIndex,
        maxmin: true,
        resize: false,
        move: false,
        success: function (layero, index) {
            // 手动设置更高 z-index
            layero.css('z-index', layer.zIndex + 100);

            // 保存层索引
            layero.data('layer-index', index);

            // 保存原始状态
            window.layerStates[index] = {
                originalWidth: 460,
                originalHeight: 800,
                // 状态记录：normal（原始大小）, minimized（最小化）, maximized（最大化）
                currentState: 'normal',
                // 记录从哪个状态进入最小化的
                minimizedFrom: null
            };

            // 设置初始位置：距离顶部20px
            setLayerPosition(layero, 'normal');

            // 监听窗口大小变化
            $(window).off('resize.layer-' + index).on('resize.layer-' + index, function () {
                var state = window.layerStates[index];
                if (state) {
                    setLayerPosition(layero, state.currentState);
                }
            });

            // 重写最小化和最大化行为
            setTimeout(function () {
                overrideLayerControls(layero, index);
            }, 100);
        },
        cancel: function (index) {
            // 清理事件监听
            $(window).off('resize.layer-' + index);
            // 清理状态
            if (window.layerStates && window.layerStates[index]) {
                delete window.layerStates[index];
            }
        },
        // 添加关闭时的清理
        end: function (index) {
            $(window).off('resize.layer-' + index);
            if (window.layerStates && window.layerStates[index]) {
                delete window.layerStates[index];
            }
        }
    });
}

// 设置层位置（根据状态）
function setLayerPosition(layero, state) {
    var $layero = $(layero);
    var index = $layero.data('layer-index');
    var layerState = window.layerStates[index];

    if (!layerState) return;

    var windowHeight = $(window).height();
    var windowWidth = $(window).width();

    var layerWidth, layerHeight, topPosition, leftPosition;

    switch (state) {
        case 'minimized':
            // 最小化状态：右上角小窗口
            layerWidth = 200;
            layerHeight = 60;
            topPosition = 20;
            var rightPosition = 20;

            // 确保最小化窗口不会超出窗口左侧
            var maxLeft = windowWidth - layerWidth - 5; // 减去5px边距
            leftPosition = Math.min(windowWidth - layerWidth - rightPosition, maxLeft);

            // 如果窗口太小，确保层始终可见
            if (windowWidth < layerWidth + 40) {
                layerWidth = Math.max(150, windowWidth - 40); // 最小宽度150px
                leftPosition = 10; // 左边距10px
            }
            break;

        case 'maximized':
            // 最大化状态：全屏
            layerWidth = windowWidth;
            layerHeight = windowHeight;
            topPosition = 0;
            leftPosition = 0;
            break;

        case 'normal':
        default:
            // 正常状态：原始大小，右侧显示
            layerWidth = layerState.originalWidth;
            layerHeight = layerState.originalHeight;
            topPosition = 20;
            var rightPosition = 20;

            // 确保不会超出窗口左侧
            var maxNormalLeft = windowWidth - layerWidth - 5;
            leftPosition = Math.min(windowWidth - layerWidth - rightPosition, maxNormalLeft);

            // 如果窗口太小，调整宽度
            if (windowWidth < layerWidth + 40) {
                layerWidth = Math.max(300, windowWidth - 40); // 最小宽度300px
                leftPosition = 10; // 左边距10px
            }

            // 确保层不会超出窗口底部
            if (topPosition + layerHeight > windowHeight) {
                topPosition = windowHeight - layerHeight - 5;
                if (topPosition < 5) topPosition = 5;
            }
            break;
    }

    // 确保leftPosition不会为负数
    leftPosition = Math.max(5, leftPosition);

    // 应用位置
    $layero.css({
        'position': 'fixed',
        'top': topPosition + 'px',
        'left': leftPosition + 'px',
        'right': 'auto',
        'bottom': 'auto',
        'width': layerWidth + 'px',
        'height': layerHeight + 'px',
        'transition': 'all 0.3s ease'
    });

    // 记录当前实际尺寸到状态中
    layerState.actualWidth = layerWidth;
    layerState.actualHeight = layerHeight;
}

// 重写layer.js的控制按钮行为
function overrideLayerControls(layero, index) {
    var $layero = $(layero);
    var state = window.layerStates[index];

    // 获取控制按钮
    var minBtn = $layero.find('.layui-layer-min');
    var maxBtn = $layero.find('.layui-layer-max');

    // 1. 重写最小化按钮
    if (minBtn.length) {
        minBtn.off('click').on('click', function (e) {
            e.preventDefault();
            e.stopPropagation();

            // 更新状态：记录是从哪个状态最小化的
            state.minimizedFrom = state.currentState;
            state.currentState = 'minimized';

            // 执行最小化
            executeStateChange(layero, index, 'minimized');

            // 更新按钮显示
            updateButtonDisplay($layero, 'minimized');
        });
    }

    // 2. 重写最大化按钮
    if (maxBtn.length) {
        maxBtn.off('click').on('click', function (e) {
            e.preventDefault();
            e.stopPropagation();

            if (state.currentState === 'minimized') {
                // 如果当前是最小化状态
                if (state.minimizedFrom === 'maximized') {
                    // 如果是从最大化状态最小化的，还原到最大化
                    state.currentState = 'maximized';
                    executeStateChange(layero, index, 'maximized');
                    updateButtonDisplay($layero, 'maximized');
                } else {
                    // 如果是从正常状态最小化的，还原到正常状态
                    state.currentState = 'normal';
                    state.minimizedFrom = null;
                    executeStateChange(layero, index, 'normal');
                    updateButtonDisplay($layero, 'normal');
                }
            } else if (state.currentState === 'maximized') {
                // 如果当前是最大化状态，还原到正常状态
                state.currentState = 'normal';
                state.minimizedFrom = null;
                executeStateChange(layero, index, 'normal');
                updateButtonDisplay($layero, 'normal');
            } else if (state.currentState === 'normal') {
                // 如果当前是正常状态，最大化
                state.currentState = 'maximized';
                state.minimizedFrom = null;
                executeStateChange(layero, index, 'maximized');
                updateButtonDisplay($layero, 'maximized');
            }
        });
    }

    // 初始按钮显示
    updateButtonDisplay($layero, state.currentState);
}

// 执行状态变化
function executeStateChange(layero, index, targetState) {
    var $layero = $(layero);
    var state = window.layerStates[index];

    // 设置位置
    setLayerPosition(layero, targetState);

    // 处理内容显示/隐藏
    var $content = $layero.find('.layui-layer-content');
    if ($content.length) {
        if (targetState === 'minimized') {
            $content.hide();
            $layero.addClass('minimized-state');
        } else {
            $content.show();
            $layero.removeClass('minimized-state');
        }
    }

    // 确保层级
    if (targetState === 'minimized') {
        $layero.css('z-index', layer.zIndex + 200);
    }
}

// 更新按钮显示
function updateButtonDisplay($layero, state) {
    var minBtn = $layero.find('.layui-layer-min');
    var maxBtn = $layero.find('.layui-layer-max');

    switch (state) {
        case 'minimized':
            // 最小化时：隐藏减号按钮，最大化按钮显示为还原图标
            minBtn.hide();
            maxBtn.removeClass('layui-layer-max').addClass('layui-layer-maxmin');
            break;

        case 'maximized':
            // 最大化时：显示减号按钮，最大化按钮显示为还原图标
            minBtn.show();
            maxBtn.removeClass('layui-layer-max').addClass('layui-layer-maxmin');
            break;

        case 'normal':
        default:
            // 正常状态时：显示减号按钮，最大化按钮显示为放大图标
            minBtn.show();
            maxBtn.removeClass('layui-layer-maxmin').addClass('layui-layer-max');
            break;
    }
}

// 全局监听窗口大小变化
$(window).on('resize', function () {
    var windowWidth = $(window).width();

    $('.layui-layer').each(function () {
        var $layero = $(this);
        var index = $layero.data('layer-index');

        if (index && window.layerStates && window.layerStates[index]) {
            var state = window.layerStates[index];

            // 实时更新位置
            setLayerPosition($layero, state.currentState);
        }
    });
});

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

//------------------APP端下拉刷新功能开始--------------------------
function initPullToRefresh() {
    var startY = 0;
    var currentY = 0;
    var distance = 0;
    var threshold = 80; // 下拉阈值（像素）
    var isRefreshing = false;
    var pullStart = 0;
    var maxPull = 120; // 最大下拉距离

    // 存储原始URL（页面首次加载时的URL，包含所有查询参数）
    var originalUrl = window.location.href;
    var originalTitle = document.title;

    console.log('原始URL:', originalUrl);
    console.log('原始标题:', originalTitle);

    // 创建下拉刷新指示器
    var refreshIndicator = document.createElement('div');
    refreshIndicator.id = 'pullToRefreshIndicator';
    refreshIndicator.className = 'pull-refresh-indicator';
    refreshIndicator.innerHTML = '<div class="refresh-icon">↓</div><div class="refresh-text"><asp:Label ID="LabelRefreshHint" runat="server" Text="<%$ Resources:lang,XLSXH %>" /></div>';
    document.body.insertBefore(refreshIndicator, document.body.firstChild);

    // 添加样式
    var style = document.createElement('style');
    style.textContent = `
        .pull-refresh-indicator {
            position: fixed;
            top: -60px;
            left: 0;
            width: 100%;
            height: 60px;
            background: linear-gradient(to bottom, #f8f8f8, #ffffff);
            display: flex;
            align-items: center;
            justify-content: center;
            flex-direction: column;
            z-index: 9998;
            transition: top 0.3s ease;
            border-bottom: 1px solid #ddd;
            box-shadow: 0 2px 5px rgba(0,0,0,0.1);
        }
        
        .pull-refresh-indicator.active {
            top: 0 !important;
        }
        
        .pull-refresh-indicator.refreshing {
            background: linear-gradient(to bottom, #e8f4ff, #ffffff);
        }
        
        .refresh-icon {
            font-size: 20px;
            margin-bottom: 5px;
            transition: transform 0.3s ease;
        }
        
        .pull-refresh-indicator.active .refresh-icon {
            transform: rotate(180deg);
        }
        
        .pull-refresh-indicator.refreshing .refresh-icon {
            animation: spin 1s linear infinite;
        }
        
        .refresh-text {
            font-size: 14px;
            color: #666;
            text-align: center;
        }
        
        @keyframes spin {
            0% { transform: rotate(0deg); }
            100% { transform: rotate(360deg); }
        }
    `;
    document.head.appendChild(style);

    // 触摸开始事件
    document.addEventListener('touchstart', function (e) {
        // 如果页面正在刷新，则不处理
        if (isRefreshing) return;

        // 只有在页面顶部且没有水平滚动时才允许下拉刷新
        if (window.scrollY <= 0 && !isHorizontalScroll(e)) {
            startY = e.touches[0].pageY;
            currentY = startY;
            pullStart = Date.now();

            // 初始化指示器位置
            refreshIndicator.style.top = '-60px';
            refreshIndicator.classList.remove('active', 'refreshing');
        }
    });

    // 触摸移动事件
    document.addEventListener('touchmove', function (e) {
        // 如果页面正在刷新，则不处理
        if (isRefreshing) return;

        if (startY > 0 && window.scrollY <= 0) {
            currentY = e.touches[0].pageY;
            distance = currentY - startY;

            // 只有下拉才处理
            if (distance > 0) {
                e.preventDefault(); // 阻止默认滚动

                // 限制最大下拉距离
                var pullDistance = Math.min(distance, maxPull);

                // 移动指示器
                var indicatorTop = Math.min(pullDistance - 60, 0);
                refreshIndicator.style.top = indicatorTop + 'px';
                refreshIndicator.style.transition = 'none';

                // 超过阈值时显示激活状态
                if (pullDistance >= threshold) {
                    refreshIndicator.classList.add('active');
                } else {
                    refreshIndicator.classList.remove('active');
                }
            }
        }
    });

    // 触摸结束事件
    document.addEventListener('touchend', function (e) {
        // 如果页面正在刷新，则不处理
        if (isRefreshing) return;

        if (startY > 0 && distance > 0) {
            var pullDistance = Math.min(distance, maxPull);
            var pullDuration = Date.now() - pullStart;

            // 如果下拉距离超过阈值，触发刷新
            if (pullDistance >= threshold) {
                triggerRefresh();
            } else {
                // 回弹效果
                refreshIndicator.style.transition = 'top 0.3s ease';
                refreshIndicator.style.top = '-60px';
                refreshIndicator.classList.remove('active');
            }
        }

        // 重置变量
        startY = 0;
        currentY = 0;
        distance = 0;
    });

    // 检查是否为水平滚动
    function isHorizontalScroll(e) {
        var startX = e.touches[0].pageX;
        var startY = e.touches[0].pageY;

        // 临时监听移动来判断滚动方向
        var isHorizontal = false;
        var checkDirection = function (moveEvent) {
            var deltaX = Math.abs(moveEvent.touches[0].pageX - startX);
            var deltaY = Math.abs(moveEvent.touches[0].pageY - startY);

            if (deltaX > deltaY + 10) { // 水平滚动更明显
                isHorizontal = true;
            }

            document.removeEventListener('touchmove', checkDirection);
        };

        document.addEventListener('touchmove', checkDirection, { once: true });
        return isHorizontal;
    }

    // 触发刷新
    function triggerRefresh() {
        if (isRefreshing) return;

        isRefreshing = true;
        refreshIndicator.classList.add('refreshing');
        refreshIndicator.style.transition = 'top 0.3s ease';
        refreshIndicator.style.top = '0';

        // 显示刷新文本
        var refreshText = refreshIndicator.querySelector('.refresh-text');
        var originalText = refreshText.innerHTML;
        refreshText.innerHTML = '<asp:Label ID="LabelRefreshing" runat="server" Text="<%$ Resources:lang,SZXZ %>" />';

        // 执行刷新操作
        performRefresh();
    }

    // 执行刷新 - 使用原始URL重新加载页面
    function performRefresh() {
        console.log('执行刷新，使用原始URL:', originalUrl);

        // 显示等待指示器
        var waitingImg = document.getElementById('IMG_Waiting');
        if (waitingImg) {
            waitingImg.style.display = 'block';
        }

        // 方法1：使用原始URL重新加载（确保获取最新数据）
        // 使用replace=true确保从服务器获取而不是缓存
        try {
            // 先尝试ASP.NET UpdatePanel刷新（如果可用）
            var updatePanel = document.querySelector('[id*="UpdatePanel"]');
            var scriptManager = document.querySelector('[id*="ScriptManager"]');

            if (updatePanel && scriptManager && typeof __doPostBack === 'function') {
                console.log('尝试UpdatePanel刷新');
                __doPostBack(updatePanel.id, '');

                // UpdatePanel刷新后结束刷新状态
                setTimeout(function () {
                    endRefreshing();
                }, 1500);
            } else {
                // 回退到完整页面刷新
                console.log('执行完整页面刷新');

                // 保存当前的滚动位置（如果需要的话）
                var scrollPosition = {
                    x: window.scrollX,
                    y: window.scrollY
                };

                // 使用location.replace确保获取最新数据
                // 添加时间戳避免缓存
                var refreshUrl = originalUrl;
                if (refreshUrl.indexOf('?') === -1) {
                    refreshUrl += '?_refresh=' + Date.now();
                } else {
                    refreshUrl += '&_refresh=' + Date.now();
                }

                // 显示加载中
                refreshIndicator.querySelector('.refresh-text').innerHTML =
                    '<asp:Label ID="LabelLoading" runat="server" Text="<%$ Resources:lang,JZZZ %>" />';

                // 延迟一点让用户看到反馈
                setTimeout(function () {
                    window.location.href = refreshUrl;
                }, 800);
            }
        } catch (e) {
            console.error('刷新出错:', e);
            // 出错时回退到简单刷新
            setTimeout(function () {
                window.location.href = originalUrl +
                    (originalUrl.indexOf('?') === -1 ? '?' : '&') +
                    '_refresh=' + Date.now();
            }, 800);
        }
    }

    // 结束刷新
    function endRefreshing() {
        isRefreshing = false;

        // 恢复指示器状态
        refreshIndicator.style.transition = 'top 0.3s ease';
        refreshIndicator.style.top = '-60px';
        refreshIndicator.classList.remove('active', 'refreshing');

        // 恢复原始文本
        var refreshText = refreshIndicator.querySelector('.refresh-text');
        refreshText.innerHTML = '<asp:Label ID="LabelRefreshHint" runat="server" Text="<%$ Resources:lang,XLSXH %>" />';

        // 隐藏等待指示器
        var waitingImg = document.getElementById('IMG_Waiting');
        if (waitingImg) {
            waitingImg.style.display = 'none';
        }
    }

    // 监听页面加载完成事件
    document.addEventListener('DOMContentLoaded', function () {
        // 检查URL中是否有刷新标记，如果有则滚动到顶部
        if (window.location.href.indexOf('_refresh=') !== -1) {
            window.scrollTo(0, 0);

            // 移除刷新参数（避免刷新循环）
            setTimeout(function () {
                var cleanUrl = window.location.href.replace(/[?&]_refresh=\d+/, '');
                cleanUrl = cleanUrl.replace(/\?$/, ''); // 移除末尾的?
                window.history.replaceState({}, document.title, cleanUrl);
            }, 100);
        }
    });

    // 公共API
    window.PullToRefresh = {
        trigger: triggerRefresh,
        end: endRefreshing,
        isRefreshing: function () { return isRefreshing; },
        getOriginalUrl: function () { return originalUrl; }
    };
}

// 修改后的右滑返回功能（提示层在底部）
function initSwipeBack() {
    var startX = 0;
    var startY = 0;
    var threshold = 100;
    var restraint = 100;
    var feedbackShown = false;

    // 修改滑动反馈层的位置到页面底部
    function moveFeedbackToBottom() {
        var feedback = document.getElementById('swipeFeedback');
        if (feedback) {
            // 移除原有样式
            feedback.style.top = 'auto';
            feedback.style.bottom = '0';
            feedback.style.transform = 'translateY(100%)';

            // 修改动画
            var style = document.createElement('style');
            style.textContent = `
                #swipeFeedback {
                    position: fixed;
                    bottom: 0;
                    left: 0;
                    width: 100%;
                    height: 40px;
                    background: rgba(0, 150, 255, 0.9);
                    color: white;
                    display: flex;
                    align-items: center;
                    justify-content: center;
                    z-index: 9999;
                    animation: fadeInOutBottom 3s ease-in-out forwards;
                    font-size: 14px;
                }
                
                @keyframes fadeInOutBottom {
                    0% { opacity: 0; transform: translateY(100%); }
                    10% { opacity: 1; transform: translateY(0); }
                    90% { opacity: 1; transform: translateY(0); }
                    100% { opacity: 0; transform: translateY(100%); }
                }
            `;
            document.head.appendChild(style);
        }
    }

    // 页面加载完成后移动提示层到底部
    if (document.readyState === 'loading') {
        document.addEventListener('DOMContentLoaded', moveFeedbackToBottom);
    } else {
        moveFeedbackToBottom();
    }

    // 显示滑动反馈（在底部）
    function showSwipeFeedback() {
        var feedback = document.getElementById('swipeFeedback');
        if (feedback) {
            feedback.style.display = 'flex';
            feedback.style.animation = 'fadeInOutBottom 3s ease-in-out forwards';
        }
    }

    // 隐藏滑动反馈
    function hideSwipeFeedback() {
        var feedback = document.getElementById('swipeFeedback');
        if (feedback) {
            feedback.style.display = 'none';
            feedback.style.animation = 'none';
        }
    }

    // 显示滑动反馈提示
    showSwipeFeedback();

    // 触摸开始事件
    document.addEventListener('touchstart', function (e) {
        startX = e.touches[0].pageX;
        startY = e.touches[0].pageY;
        hideSwipeFeedback();
        feedbackShown = true;
    });

    // 触摸移动事件 - 检测右滑动作
    document.addEventListener('touchmove', function (e) {
        if (!startX) return;

        var currentX = e.touches[0].pageX;
        var currentY = e.touches[0].pageY;
        var distX = currentX - startX;
        var distY = Math.abs(currentY - startY);

        // 如果已经开始右滑且垂直偏移不大，显示提示
        if (distX > 30 && distY < restraint && !feedbackShown) {
            showSwipeFeedback();
        }
    });

    // 触摸结束事件
    document.addEventListener('touchend', function (e) {
        if (!startX) return;

        var endX = e.changedTouches[0].pageX;
        var endY = e.changedTouches[0].pageY;
        var distX = endX - startX;
        var distY = Math.abs(endY - startY);

        // 检查是否为有效的右滑
        if (distX >= threshold && distY <= restraint) {
            triggerBackLink();
        }

        startX = 0;
        startY = 0;
        feedbackShown = false;
    });

    // 点击页面任何地方也隐藏提示
    document.addEventListener('click', function () {
        hideSwipeFeedback();
        feedbackShown = true;
    });

    // 新增：初始化下拉刷新
    setTimeout(function () {
        initPullToRefresh();
    }, 500);
}

// 触发返回链接
function triggerBackLink() {
    console.log('执行返回主页');
    var waitingImg = document.getElementById('IMG_Waiting');
    if (waitingImg) {
        waitingImg.style.display = 'block';
    }
    setTimeout(function () {
        var backLink = document.getElementById("aAPPBackPriorPage");
        if (backLink) {
            backLink.click();
        } else {
            console.error('返回链接未找到');
        }
    }, 300);
}

// 手动触发刷新的函数（可以从其他地方调用）
function manualRefresh() {
    if (window.PullToRefresh && !window.PullToRefresh.isRefreshing()) {
        window.PullToRefresh.trigger();
    } else {
        // 直接重新加载
        window.location.href = window.location.href +
            (window.location.href.indexOf('?') === -1 ? '?' : '&') +
            '_refresh=' + Date.now();
    }
}
//------------------APP端下拉刷新功能结束--------------------------



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