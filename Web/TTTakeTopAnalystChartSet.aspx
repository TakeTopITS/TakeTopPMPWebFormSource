<%@ Page Language="C#" AutoEventWireup="true" CodeFile="TTTakeTopAnalystChartSet.aspx.cs" Inherits="TTTakeTopAnalystChartSet" %>

<%--<%@ OutputCache Duration="2678400" VaryByParam="*" %>--%>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">

    <title></title>

    <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
    <meta charset="utf-8" />

    <style>
        .card-container {
            display: flex;
            gap: 10px;
            vertical-align: bottom;
        }

        .card {
            width: 100%;
            padding: 20px;
            border-radius: 5px;
            box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
            text-align: center;
        }

            .card.blue {
                background-color: #367E7F;
            }

            .card.red {
                background-color: #d9534f;
            }

            .card.green {
                background-color: #5cb85c;
            }

            .card.lightblue {
                background-color: #7092BE;
            }

            .card.brown {
                background-color: #818049;
            }

            .card img {
                max-width: 30px;
                margin-bottom: 10px;
            }

            .card h3 {
                margin: 0;
                font-size: 18px;
                color: white;
            }

            .card p {
                margin: 5px 0;
                font-size: 14px;
                color: white;
            }

        /* 加载中的数字样式 */
        .loading-number {
            display: inline-block;
            min-width: 20px;
            animation: pulse 1.5s ease-in-out infinite;
        }

        @keyframes pulse {
            0%, 100% { opacity: 0.4; }
            50% { opacity: 1; }
        }
    </style>
    <script src="js/jquery-1.10.2.min.js"></script>
</head>

<body>
    <form id="form1" runat="server">
        <div style="width: 100%; text-align: center;">
            <div id="m2" style="width: 100%; height: 270px; overflow: hidden;"></div>
        </div>
    </form>

    <script src="Scripts/ECharts/echarts-all.js"></script>

    <script type="text/javascript">

        //取得URL参数的值
        function GetQueryValue(queryName) {
            var query = decodeURI(window.location.search.substring(1));
            var vars = query.split('&');
            for (var i = 0; i < vars.length; i++) {
                var pair = vars[i].split('=');
                if (pair[0] == queryName) { return pair[1]; }
            }
            return null;
        }

        $(function () {
            var formType = GetQueryValue("FormType");
            var chartType = GetQueryValue("ChartType");
            var chartName = GetQueryValue("ChartName");

            // 卡片类型图表：先显示骨架，再异步加载数据
            if (chartType == 'HRuningProjectStatus' || chartType == 'HDelayProjectStatus' ||
                chartType == 'HAnnualPaymentStatus' || chartType == 'HAnnualWorkHourStatus' ||
                chartType == 'HRuningTaskStatus') {
                // 先显示卡片骨架（带占位符）
                showCardSkeleton(chartType);
                // 异步加载数据
                loadCardDataAsync(chartType, chartName);
            } else {
                // 其他图表类型：显示 loading 后加载
                $('#m2').html('<div style="text-align:center; padding:50px;"><img src="Images/Processing.gif" alt="Loading..." /></div>');
                loadChartAsync();
            }
        });

        // 显示卡片骨架（带占位符）
        function showCardSkeleton(chartType) {
            var cardConfig = {
                'HRuningProjectStatus': {
                    className: 'blue',
                    icon: 'Running.png',
                    title: '<%=LanguageHandle.GetWord("ZaiZiXingXiangMuZhongShu").ToString() %>',
                    sub1: '<%=LanguageHandle.GetWord("NianDuXingZeng").ToString() %>',
                    sub2: '<%=LanguageHandle.GetWord("NianDuWanCheng").ToString() %>'
                },
                'HDelayProjectStatus': {
                    className: 'red',
                    icon: 'Process.png',
                    title: '<%=LanguageHandle.GetWord("NianDuYanWuXiangMuShu").ToString() %>',
                    sub1: '<%=LanguageHandle.GetWord("JingDuZhengChang").ToString() %>',
                    sub2: '<%=LanguageHandle.GetWord("QingDuYanWu").ToString() %>'
                },
                'HAnnualPaymentStatus': {
                    className: 'green',
                    icon: 'PaymentCollection.png',
                    title: '<%=LanguageHandle.GetWord("XiangMuNianDuhHuiKan").ToString() %>',
                    sub1: '<%=LanguageHandle.GetWord("NianDuChengBenHeShuan").ToString() %>',
                    sub2: '<%=LanguageHandle.GetWord("ChengBenChaoZiXiangMuShu").ToString() %>'
                },
                'HAnnualWorkHourStatus': {
                    className: 'brown',
                    icon: 'WorkHour.png',
                    title: '<%=LanguageHandle.GetWord("NianDuXiangMuGongShiTouRu").ToString() %>',
                    sub1: '<%=LanguageHandle.GetWord("NianDuTeiBaoRenShu").ToString() %>',
                    sub2: '<%=LanguageHandle.GetWord("RenGongChengBen").ToString() %>'
                },
                'HRuningTaskStatus': {
                    className: 'lightblue',
                    icon: 'RunningTask.png',
                    title: '<%=LanguageHandle.GetWord("ZaiZhiXingRenWuZhongShu").ToString() %>',
                    sub1: '<%=LanguageHandle.GetWord("NianDuXingZeng").ToString() %>',
                    sub2: '<%=LanguageHandle.GetWord("NianDuWanCheng").ToString() %>'
                }
            };

            var config = cardConfig[chartType];
            if (!config) return;

            // 先显示 "--" 占位符，不显示转圈
            var placeholder = "<span style='color:rgba(255,255,255,0.6);'>--</span>";
            var html = "<div class='card-container' style='padding-top:12px;'>" +
                "<div class='card " + config.className + "'>" +
                "<table>" +
                "<tr>" +
                "<td colspan='3' width='30%' align='left' style='padding-left:20px;'>" +
                "<img src='ImagesSkin/" + config.icon + "' alt='Icon'/>" +
                "</td>" +
                "<td align='left'>" +
                config.title + ": <span id='spanXNumber'>" + placeholder + "</span>" +
                "<p>" + config.sub1 + ": <span id='spanYNumber'>" + placeholder + "</span></p>" +
                "<p>" + config.sub2 + ": <span id='spanZNumber'>" + placeholder + "</span></p>" +
                "</td>" +
                "</tr>" +
                "</table>" +
                "</div>" +
                "</div>";

            document.getElementById('m2').innerHTML = html;
        }

        // 异步加载卡片数据
        function loadCardDataAsync(chartType, chartName) {
            var sqlCode = escape(unescape(GetQueryValue("SqlCode")));

            $.ajax({
                type: "post",
                async: true,
                timeout: 35000, // 35秒超时
                url: "Handler/EchartHandler.ashx",
                data: {
                    FormType: GetQueryValue("FormType"),
                    ChartName: chartName,
                    SqlCode: sqlCode
                },
                datatype: "json",
                contentType: "application/x-www-form-urlencoded; charset=utf-8",
                success: function (result) {
                    if (result && result != "") {
                        try {
                            eval("var transresult=" + result);
                            updateCardNumbers(transresult);
                        } catch (e) {
                            console.error("Data parsing error:", e);
                        }
                    }
                    // 通知父页面加载完成
                    if (parent && parent.window && parent.window.chartLoaded) {
                        parent.window.chartLoaded();
                    }
                },
                error: function (xhr, status, error) {
                    console.error("Loading failed:", status, error);
                    if (parent && parent.window && parent.window.chartLoaded) {
                        parent.window.chartLoaded();
                    }
                }
            });
        }

        // 更新卡片数字
        function updateCardNumbers(data) {
            if (data && data.length > 0) {
                var xNum = document.getElementById("spanXNumber");
                var yNum = document.getElementById("spanYNumber");
                var zNum = document.getElementById("spanZNumber");
                
                if (xNum) xNum.innerHTML = data[0].XName || '0';
                if (data[0].YNumber) {
                    var parts = data[0].YNumber.split(',');
                    if (yNum) yNum.innerHTML = parts[0] || '0';
                    if (zNum) zNum.innerHTML = parts[1] || '0';
                }
            }
        }

        function loadChartAsync() {
            var myChart1 = echarts.init(document.getElementById('m2'));

            var formType = GetQueryValue("FormType");
            var chartType = GetQueryValue("ChartType");
            var chartName = GetQueryValue("ChartName");
            var sqlCode = escape(unescape(GetQueryValue("SqlCode")));

            // 先显示加载中
            showLoading(myChart1);

            // 异步加载数据
            $.ajax({
                type: "post",
                async: true,
                timeout: 35000, // 35秒超时（后端30秒超时 + 缓冲）
                url: "Handler/EchartHandler.ashx",
                data: {
                    FormType: formType,
                    ChartName: chartName,
                    SqlCode: sqlCode
                },
                datatype: "json",
                contentType: "application/x-www-form-urlencoded; charset=utf-8",
                success: function (result) {
                    if (result && result != "") {
                        try {
                            eval("var transresult=" + result);

                            // 卡片类型图表
                            if (chartType == 'HRuningProjectStatus' || chartType == 'HDelayProjectStatus' ||
                                chartType == 'HAnnualPaymentStatus' || chartType == 'HAnnualWorkHourStatus' ||
                                chartType == 'HRuningTaskStatus') {
                                updateCardChart(chartType, chartName, transresult);
                            } else {
                                // ECharts类型 - 直接使用原始代码的方式更新
                                updateEChart(myChart1, chartType, formType, chartName, transresult);
                            }
                        } catch (e) {
                            console.error("Data parsing error:", e);
                            showNoData(myChart1, chartType, chartName);
                        }
                    } else {
                        showNoData(myChart1, chartType, chartName);
                    }

                    // 通知父页面图表加载完成
                    if (parent && parent.window && parent.window.chartLoaded) {
                        parent.window.chartLoaded();
                    }
                },
                error: function (xhr, status, error) {
                    console.error("Loading failed:", status, error);
                    showNoData(myChart1, chartType, chartName);
                    if (parent && parent.window && parent.window.chartLoaded) {
                        parent.window.chartLoaded();
                    }
                },
                complete: function(xhr, status) {
                    // 无论成功失败，确保loading被隐藏
                    myChart1.hideLoading();
                }
            });
        }

        function showLoading(chart) {
            chart.showLoading({
                text: 'Loading...',
                effect: 'bubble'
            });
        }

        function showNoData(chart, chartType, chartName) {
            chart.hideLoading();

            // 显示无数据提示
            var option = {
                title: {
                    text: chartName,
                    x: 'center',
                    y: 'center',
                    textStyle: { fontSize: 10 }
                },
                noDataLoadingOption: {
                    text: 'No data available',
                    effect: 'bubble'
                }
            };

            if (chartType == 'Column' || chartType == 'Bar') {
                option.xAxis = [{ type: 'category', data: [] }];
                option.yAxis = [{ type: 'value' }];
                option.series = [{ type: 'bar', data: [] }];
            } else if (chartType == 'Line') {
                option.xAxis = [{ type: 'category', data: [] }];
                option.yAxis = [{ type: 'value' }];
                option.series = [{ type: 'line', data: [] }];
            } else {
                option.series = [{ type: chartType == 'Gauge' ? 'gauge' : 'pie', data: [] }];
            }

            chart.setOption(option);
        }

        function updateEChart(chart, chartType, formType, chartName, data) {
            chart.hideLoading();

            // 仪表盘
            if (chartType == 'Gauge') {
                var option1 = {
                    title: {
                        text: chartName,
                        subtext: '',
                        itemGap: 8,
                        x: 'center',
                        y: 'center',
                        textAlign: 'center',
                        textStyle: {
                            color: '#000000',
                            fontSize: 10,
                        },
                        subtextStyle: {
                            color: '#000000',
                            fontSize: 8
                        },
                    },
                    tooltip: {
                        trigger: 'item',
                        transitionDuration: 8,
                        formatter: "{b}:{c} "
                    },
                    series: [
                        {
                            name: '',
                            type: 'gauge',
                            splitLine: { show: false },
                            axisLabel: false,
                            radius: '55%',
                            center: ['50%', '30%'],
                            data: []
                        }
                    ]
                };

                var eSeries = [];
                for (var i = 0; i < data.length; i++) {
                    eSeries.push({
                        value: data[i].YNumber,
                        name: data[i].XName
                    });
                }
                option1.series[0].data = eSeries;
                chart.setOption(option1);
            }

            // 饼图
            if (chartType == 'Pie') {
                var option1 = {
                    title: {
                        text: chartName,
                        subtext: '',
                        itemGap: 8,
                        x: 'center',
                        y: 'center',
                        textAlign: 'center',
                        textStyle: {
                            color: '#000000',
                            fontSize: 10,
                        },
                        subtextStyle: {
                            color: '#000000',
                            fontSize: 8
                        },
                    },
                    tooltip: {
                        trigger: 'item',
                        transitionDuration: 0,
                        formatter: '{b}: {c}\n ({d}%)'
                    },
                    series: [
                        {
                            name: '',
                            type: 'pie',
                            radius: '35%',
                            center: ['50%', '30%'],
                            data: [],
                            itemStyle: {
                                normal: {
                                    borderWidth: 1,
                                    label: {
                                        show: true,
                                        position: 'outer',
                                        textStyle: { fontSize: 10 },
                                        formatter: '{b}: {c}\n ({d}%)'
                                    },
                                    labelLine: { show: true, length: 5 }
                                }
                            }
                        }
                    ]
                };

                var eSeries = [];
                for (var i = 0; i < data.length; i++) {
                    eSeries.push({
                        value: data[i].YNumber,
                        name: data[i].XName
                    });
                }
                option1.series[0].data = eSeries;
                chart.setOption(option1);
            }

            // 圈图
            if (chartType == 'Doughnut') {
                var option1 = {
                    title: {
                        text: chartName,
                        subtext: '',
                        itemGap: 8,
                        x: 'center',
                        y: 'center',
                        textAlign: 'center',
                        textStyle: {
                            color: '#000000',
                            fontSize: 10,
                        },
                        subtextStyle: {
                            color: '#000000',
                            fontSize: 8
                        },
                    },
                    tooltip: {
                        trigger: 'item',
                        transitionDuration: 8,
                        formatter: '{b}: {c}\n ({d}%)'
                    },
                    series: [
                        {
                            name: '',
                            type: 'pie',
                            radius: ['30%', '50%'],
                            center: ['50%', '30%'],
                            avoidLabelOverlap: false,
                            itemStyle: {
                                borderRadius: 10,
                                borderColor: '#fff',
                                borderWidth: 2,
                                normal: {
                                    borderWidth: 1,
                                    label: {
                                        show: true,
                                        position: 'outer',
                                        textStyle: { fontSize: 10 },
                                        formatter: '{b}: {c}\n ({d}%)'
                                    },
                                    labelLine: { show: true, length: 5 }
                                }
                            },
                            label: { show: false, position: 'center' },
                            emphasis: {
                                label: {
                                    show: true,
                                    fontSize: '8',
                                    fontWeight: 'bold'
                                }
                            },
                            labelLine: { show: false },
                            data: []
                        }
                    ]
                };

                var eSeries = [];
                for (var i = 0; i < data.length; i++) {
                    eSeries.push({
                        value: data[i].YNumber,
                        name: data[i].XName
                    });
                }
                option1.series[0].data = eSeries;
                chart.setOption(option1);
            }

            // 纵向柱状图
            if (chartType == 'Column') {
                var option1 = {
                    title: {
                        text: chartName,
                        subtext: '',
                        x: 'center',
                        y: 'center',
                        textAlign: 'center',
                        textStyle: {
                            color: '#000000',
                            fontSize: 10,
                        },
                        subtextStyle: {
                            color: '#000000',
                            fontSize: 8
                        },
                    },
                    tooltip: {
                        trigger: 'axis',
                        transitionDuration: 8,
                        axisPointer: { type: 'shadow' }
                    },
                    grid: {
                        x: 40,
                        y: 50,
                        x2: 40,
                        y2: 75,
                        containLabel: true
                    },
                    xAxis: [{ type: 'category', data: [] }],
                    yAxis: [{ type: 'value' }],
                    series: []
                };

                for (var i = 0; i < data.length; i++) {
                    option1.xAxis[0].data.push(data[i].XName);
                }

                if (formType == "Column1") {
                    option1.series = [{
                        name: '',
                        type: 'bar',
                        data: [],
                        markPoint: {
                            data: [
                                { type: 'max', name: 'Max Value' },
                                { type: 'min', name: 'Min Value' }
                            ]
                        }
                    }];
                    for (var i = 0; i < data.length; i++) {
                        option1.series[0].data.push(data[i].YNumber);
                    }
                }
                else if (formType == "Column2") {
                    option1.series = [
                        {
                            name: '',
                            type: 'bar',
                            data: [],
                            markPoint: {
                                data: [
                                    { type: 'max', name: 'Max Value' },
                                    { type: 'min', name: 'Min Value' }
                                ]
                            }
                        },
                        {
                            name: '',
                            type: 'bar',
                            data: [],
                            markPoint: {
                                data: [
                                    { type: 'max', name: 'Max Value' },
                                    { type: 'min', name: 'Min Value' }
                                ]
                            }
                        }
                    ];
                    for (var i = 0; i < data.length; i++) {
                        option1.series[0].data.push(data[i].YNumber);
                        option1.series[1].data.push(data[i].ZNumber);
                    }
                }
                else if (formType == "Column3") {
                    option1.series = [
                        {
                            name: '',
                            type: 'bar',
                            data: [],
                            markPoint: {
                                data: [
                                    { type: 'max', name: 'Max Value' },
                                    { type: 'min', name: 'Min Value' }
                                ]
                            }
                        },
                        {
                            name: '',
                            type: 'bar',
                            data: [],
                            markPoint: {
                                data: [
                                    { type: 'max', name: 'Max Value' },
                                    { type: 'min', name: 'Min Value' }
                                ]
                            }
                        },
                        {
                            name: '',
                            type: 'bar',
                            data: [],
                            markPoint: {
                                data: [
                                    { type: 'max', name: 'Max Value' },
                                    { type: 'min', name: 'Min Value' }
                                ]
                            }
                        }
                    ];
                    for (var i = 0; i < data.length; i++) {
                        option1.series[0].data.push(data[i].HNumber);
                        option1.series[1].data.push(data[i].YNumber);
                        option1.series[2].data.push(data[i].ZNumber);
                    }
                }
                else if (formType == "Column4") {
                    option1.series = [
                        {
                            name: '',
                            type: 'bar',
                            data: [],
                            markPoint: {
                                data: [
                                    { type: 'max', name: 'Max Value' },
                                    { type: 'min', name: 'Min Value' }
                                ]
                            }
                        },
                        {
                            name: '',
                            type: 'bar',
                            data: [],
                            markPoint: {
                                data: [
                                    { type: 'max', name: 'Max Value' },
                                    { type: 'min', name: 'Min Value' }
                                ]
                            }
                        },
                        {
                            name: '',
                            type: 'bar',
                            data: [],
                            markPoint: {
                                data: [
                                    { type: 'max', name: 'Max Value' },
                                    { type: 'min', name: 'Min Value' }
                                ]
                            }
                        },
                        {
                            name: '',
                            type: 'bar',
                            data: [],
                            markPoint: {
                                data: [
                                    { type: 'max', name: 'Max Value' },
                                    { type: 'min', name: 'Min Value' }
                                ]
                            }
                        }
                    ];
                    for (var i = 0; i < data.length; i++) {
                        option1.series[0].data.push(data[i].HNumber);
                        option1.series[1].data.push(data[i].kNumber);
                        option1.series[2].data.push(data[i].YNumber);
                        option1.series[3].data.push(data[i].ZNumber);
                    }
                }

                chart.setOption(option1);
            }

            // 横向柱状图
            if (chartType == 'Bar') {
                var option1 = {
                    title: {
                        text: chartName,
                        subtext: '',
                        itemGap: 8,
                        x: 'center',
                        y: 'center',
                        textAlign: 'center',
                        textStyle: {
                            color: '#000000',
                            fontSize: 10,
                        },
                        subtextStyle: {
                            color: '#000000',
                            fontSize: 8
                        },
                    },
                    tooltip: {
                        trigger: 'axis',
                        transitionDuration: 8,
                        axisPointer: { type: 'shadow' }
                    },
                    grid: {
                        x: 80,
                        y: 55,
                        x2: 40,
                        y2: 80,
                        containLabel: true
                    },
                    xAxis: [{ type: 'value' }],
                    yAxis: [{ type: 'category', data: [] }],
                    series: []
                };

                for (var i = 0; i < data.length; i++) {
                    option1.yAxis[0].data.push(data[i].XName);
                }

                if (formType == "Bar1") {
                    option1.series = [{
                        name: '',
                        type: 'bar',
                        data: [],
                        markPoint: {
                            data: [
                                { type: 'max', name: 'Max Value' },
                                { type: 'min', name: 'Min Value' }
                            ]
                        }
                    }];
                    for (var i = 0; i < data.length; i++) {
                        option1.series[0].data.push(data[i].YNumber);
                    }
                }
                else if (formType == "Bar2") {
                    option1.series = [
                        {
                            name: '',
                            type: 'bar',
                            data: [],
                            markPoint: {
                                data: [
                                    { type: 'max', name: 'Max Value' },
                                    { type: 'min', name: 'Min Value' }
                                ]
                            }
                        },
                        {
                            name: '',
                            type: 'bar',
                            data: [],
                            markPoint: {
                                data: [
                                    { type: 'max', name: 'Max Value' },
                                    { type: 'min', name: 'Min Value' }
                                ]
                            }
                        }
                    ];
                    for (var i = 0; i < data.length; i++) {
                        option1.series[0].data.push(data[i].YNumber);
                        option1.series[1].data.push(data[i].ZNumber);
                    }
                }
                else if (formType == "Bar3") {
                    option1.series = [
                        {
                            name: '',
                            type: 'bar',
                            data: [],
                            markPoint: {
                                data: [
                                    { type: 'max', name: 'Max Value' },
                                    { type: 'min', name: 'Min Value' }
                                ]
                            }
                        },
                        {
                            name: '',
                            type: 'bar',
                            data: [],
                            markPoint: {
                                data: [
                                    { type: 'max', name: 'Max Value' },
                                    { type: 'min', name: 'Min Value' }
                                ]
                            }
                        },
                        {
                            name: '',
                            type: 'bar',
                            data: [],
                            markPoint: {
                                data: [
                                    { type: 'max', name: 'Max Value' },
                                    { type: 'min', name: 'Min Value' }
                                ]
                            }
                        }
                    ];
                    for (var i = 0; i < data.length; i++) {
                        option1.series[0].data.push(data[i].HNumber);
                        option1.series[1].data.push(data[i].YNumber);
                        option1.series[2].data.push(data[i].ZNumber);
                    }
                }
                else if (formType == "Bar4") {
                    option1.series = [
                        {
                            name: '',
                            type: 'bar',
                            data: [],
                            markPoint: {
                                data: [
                                    { type: 'max', name: 'Max Value' },
                                    { type: 'min', name: 'Min Value' }
                                ]
                            }
                        },
                        {
                            name: '',
                            type: 'bar',
                            data: [],
                            markPoint: {
                                data: [
                                    { type: 'max', name: 'Max Value' },
                                    { type: 'min', name: 'Min Value' }
                                ]
                            }
                        },
                        {
                            name: '',
                            type: 'bar',
                            data: [],
                            markPoint: {
                                data: [
                                    { type: 'max', name: 'Max Value' },
                                    { type: 'min', name: 'Min Value' }
                                ]
                            }
                        },
                        {
                            name: '',
                            type: 'bar',
                            data: [],
                            markPoint: {
                                data: [
                                    { type: 'max', name: 'Max Value' },
                                    { type: 'min', name: 'Min Value' }
                                ]
                            }
                        }
                    ];
                    for (var i = 0; i < data.length; i++) {
                        option1.series[0].data.push(data[i].HNumber);
                        option1.series[1].data.push(data[i].kNumber);
                        option1.series[2].data.push(data[i].YNumber);
                        option1.series[3].data.push(data[i].ZNumber);
                    }
                }

                chart.setOption(option1);
            }

            // 线图
            if (chartType == 'Line') {
                var option1 = {
                    title: {
                        text: chartName,
                        subtext: '',
                        x: 'center',
                        y: 'center',
                        textAlign: 'center',
                        textStyle: {
                            color: '#000000',
                            fontSize: 10,
                        },
                        subtextStyle: {
                            color: '#000000',
                            fontSize: 8
                        },
                    },
                    tooltip: {
                        trigger: 'axis',
                        transitionDuration: 8,
                        axisPointer: { type: 'shadow' }
                    },
                    grid: {
                        x: 40,
                        y: 50,
                        x2: 40,
                        y2: 75,
                        containLabel: true
                    },
                    xAxis: [{ type: 'category', data: [] }],
                    yAxis: [{ type: 'value' }],
                    series: [
                        {
                            name: '',
                            type: 'line',
                            data: [],
                            markPoint: {
                                data: [
                                    { type: 'max', name: 'Max Value' },
                                    { type: 'min', name: 'Min Value' }
                                ]
                            },
                            markLine: {
                                data: [
                                    { type: 'average', name: '平均值' }
                                ]
                            }
                        }
                    ]
                };

                for (var i = 0; i < data.length; i++) {
                    option1.xAxis[0].data.push(data[i].XName);
                    option1.series[0].data.push(data[i].YNumber);
                }

                chart.setOption(option1);
            }

            // 漏斗图
            if (chartType == 'Funnel') {
                var option1 = {
                    title: {
                        text: chartName,
                        subtext: '',
                        itemGap: 8,
                        x: 'center',
                        y: 'center',
                        textAlign: 'center',
                        textStyle: {
                            color: '#000000',
                            fontSize: 10,
                        },
                        subtextStyle: {
                            color: '#000000',
                            fontSize: 8
                        },
                    },
                    tooltip: {
                        trigger: 'item',
                        transitionDuration: 8,
                        formatter: '{a} <br/>{b} : {c}%'
                    },
                    series: [
                        {
                            name: '',
                            type: 'funnel',
                            radius: '90%',
                            center: ['50%', '30%'],
                            top: 1,
                            bottom: 1,
                            height: 140,
                            itemStyle: {
                                borderColor: '#fff',
                                borderWidth: 1
                            },
                            data: []
                        }
                    ]
                };

                var eSeries = [];
                for (var i = 0; i < data.length; i++) {
                    eSeries.push({
                        value: data[i].YNumber,
                        name: data[i].XName
                    });
                }
                option1.series[0].data = eSeries;
                chart.setOption(option1);
            }
        }

        function updateCardChart(chartType, chartName, data) {
            var cardConfig = {
                'HRuningProjectStatus': {
                    className: 'blue',
                    icon: 'Running.png',
                    title: '<%=LanguageHandle.GetWord("ZaiZiXingXiangMuZhongShu").ToString() %>',
                    sub1: '<%=LanguageHandle.GetWord("NianDuXingZeng").ToString() %>',
                    sub2: '<%=LanguageHandle.GetWord("NianDuWanCheng").ToString() %>'
                },
                'HDelayProjectStatus': {
                    className: 'red',
                    icon: 'Process.png',
                    title: '<%=LanguageHandle.GetWord("NianDuYanWuXiangMuShu").ToString() %>',
                    sub1: '<%=LanguageHandle.GetWord("JingDuZhengChang").ToString() %>',
                    sub2: '<%=LanguageHandle.GetWord("QingDuYanWu").ToString() %>'
                },
                'HAnnualPaymentStatus': {
                    className: 'green',
                    icon: 'PaymentCollection.png',
                    title: '<%=LanguageHandle.GetWord("XiangMuNianDuhHuiKan").ToString() %>',
                    sub1: '<%=LanguageHandle.GetWord("NianDuChengBenHeShuan").ToString() %>',
                    sub2: '<%=LanguageHandle.GetWord("ChengBenChaoZiXiangMuShu").ToString() %>'
                },
                'HAnnualWorkHourStatus': { 
                    className: 'brown', 
                    icon: 'WorkHour.png',
                    title: '<%=LanguageHandle.GetWord("NianDuXiangMuGongShiTouRu").ToString() %>',
                    sub1: '<%=LanguageHandle.GetWord("NianDuTeiBaoRenShu").ToString() %>',
                    sub2: '<%=LanguageHandle.GetWord("RenGongChengBen").ToString() %>'
                },
                'HRuningTaskStatus': { 
                    className: 'lightblue', 
                    icon: 'RunningTask.png',
                    title: '<%=LanguageHandle.GetWord("ZaiZhiXingRenWuZhongShu").ToString() %>',
                    sub1: '<%=LanguageHandle.GetWord("NianDuXingZeng").ToString() %>',
                    sub2: '<%=LanguageHandle.GetWord("NianDuWanCheng").ToString() %>'
                }
            };

            var config = cardConfig[chartType];
            if (!config) return;

            var html = "<div class='card-container' style='padding-top:12px;'>" +
                "<div class='card " + config.className + "'>" +
                "<table>" +
                "<tr>" +
                "<td colspan='3' width='30%' align='left' style='padding-left:20px;'>" +
                "<img src='ImagesSkin/" + config.icon + "' alt='Icon'/>" +
                "</td>" +
                "<td align='left'>" +
                config.title + ": <span id='spanXNumber'></span>" +
                "<p>" + config.sub1 + ": <span id='spanYNumber'></span></p>" +
                "<p>" + config.sub2 + ": <span id='spanZNumber'></span></p>" +
                "</td>" +
                "</tr>" +
                "</table>" +
                "</div>" +
                "</div>";

            document.getElementById('m2').innerHTML = html;

            if (data && data.length > 0) {
                document.getElementById("spanXNumber").innerHTML = data[0].XName;
                if (data[0].YNumber) {
                    var parts = data[0].YNumber.split(',');
                    document.getElementById("spanYNumber").innerHTML = parts[0] || '';
                    document.getElementById("spanZNumber").innerHTML = parts[1] || '';
                }
            }
        }

    </script>

</body>
</html>