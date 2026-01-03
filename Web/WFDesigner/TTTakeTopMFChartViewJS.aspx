<%@ Page Language="C#" AutoEventWireup="true" CodeFile="TTTakeTopMFChartViewJS.aspx.cs" Inherits="WFDesigner_TTTakeTopMFChartViewJS" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
    <title>Workflow View</title>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <link type="text/css" href="lib/jquery-ui-1.8.4.custom/css/smoothness/jquery-ui-1.8.4.custom.css" rel="stylesheet" />

    <style type="text/css">
        body {
            margin: 0;
            padding: 0;
            text-align: left;
            font-family: Arial, sans-serif, Helvetica, Tahoma;
            font-size: 12px;
            line-height: 1.5;
            color: black;
            background-image: url(img/Backgroud.jpg);
            background-size: cover;
            background-position: center center;
            background-repeat: no-repeat;
            background-attachment: fixed;
        }

        /* 外部容器：控制对齐方式 */
        #TakeTopFlow {
            width: 100%;
            height: 100vh;
            display: flex;
            flex-direction: column;
            overflow-x: auto; /* 核心：超出时显示滚动条 */
            overflow-y: auto;
        }

        /* 默认状态：当内容窄时居中 */
        .justify-center {
            align-items: center;
        }

        /* 靠左状态：当内容宽时靠左 */
        .justify-left {
            align-items: flex-start;
        }

        svg {
            display: block;
            flex-shrink: 0;
            /* 移除可能存在的默认 margin */
            margin-left: 0;
            margin-right: 0;
        }

        .settings-button {
            position: fixed;
            top: 10px;
            right: 10px;
            width: 21px;
            height: 21px;
            cursor: pointer;
            z-index: 1000;
        }
    </style>

    <script type="text/javascript" src="lib/jquery-ui-1.8.4.custom/js/jquery-1.4.2.min.js"></script>
    <script type="text/javascript" src="lib/jquery-ui-1.8.4.custom/js/jquery-ui-1.8.4.custom.min.js"></script>
    <script type="text/javascript" src="lib/TakeTopFlowBase.js"></script>
    <script type="text/javascript" src="TakeTopModuleFlowView.js"></script>
    <script type="text/javascript" src="TakeTopModuleFlow.jpdtd.js"></script>
    <script type="text/javascript" src="TakeTopModuleFlow.editors.js"></script>

    <script type="text/javascript">
        $(function () {
            if (top.location != self.location) {
                loadChartImmediately();
            }
            $(window).resize(function () {
                resizeSvg("auto");
            });
        });

        function loadChartImmediately() {
            LoadWFChart();
            if (typeof displayProcessing === "function") displayProcessing('NONE');
            setTimeout(function () {
                resizeSvg("auto");
            }, 500);
        }

        // 核心函数：仅针对 rect 元素计算精确边界
        function findBoundariesOfRects(svgElement) {
            let minX = Infinity;
            let maxX = -Infinity;
            const rects = svgElement.getElementsByTagName('rect');

            let foundValidRect = false;
            for (let i = 0; i < rects.length; i++) {
                const bbox = rects[i].getBBox();
                // 排除宽度极小或隐藏的 rect
                if (bbox.width > 1) {
                    if (bbox.x < minX) minX = bbox.x;
                    if (bbox.x + bbox.width > maxX) maxX = bbox.x + bbox.width;
                    foundValidRect = true;
                }
            }

            return foundValidRect ? { minX: minX, maxX: maxX, width: (maxX - minX) } : null;
        }

        function resizeSvg(varSvgStatus) {
            const svgs = document.getElementsByTagName("svg");
            const container = document.getElementById("TakeTopFlow");
            const windowWidth = $(window).width();

            for (let i = 0; i < svgs.length; i++) {
                const svg = svgs[i];
                const bounds = findBoundariesOfRects(svg);

                if (!bounds) continue;

                // 1. 设置 SVG 的高度（保持原有逻辑）
                svg.style.height = "2148px";
                svg.style.overflow = varSvgStatus;

                // 2. 核心修正：使用 viewBox 裁剪掉左边的空白
                // viewBox = "minX minY width height"
                // 这样 SVG 的内容就会从最左边的 rect 开始显示
                const sidePadding = 20; // 给左右留一点点呼吸间距
                const totalWidth = bounds.width + (sidePadding * 2);

                svg.setAttribute("viewBox", (bounds.minX - sidePadding) + " 0 " + totalWidth + " 2148");
                svg.style.width = totalWidth + "px";

                // 3. 判断是否需要居中
                if (totalWidth < windowWidth) {
                    // 图形窄于页面 -> 居中
                    container.className = "justify-center";
                } else {
                    // 图形宽于页面 -> 靠左，最左边的 rect 会挨着页面左边
                    container.className = "justify-left";
                }
            }
        }

        function displayProcessing(varStatus) {
            try {
                parent.parent.parent.window.document.getElementById("loading").style.display = varStatus;
            } catch (e) { }
        }
    </script>
</head>
<body>
    <form id="form1" runat="server">
        <div id="divMFDesign" runat="server" class="settings-button">
            <img src="img/Set.jpg" alt="Design" width="21px" height="21px" />
        </div>

        <div id="TakeTopFlow" class="justify-center">
            </div>

        <div id="contextMenu" class="context-menu"></div>
    </form>
</body>
</html>