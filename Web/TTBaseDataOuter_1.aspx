<%@ Page Language="C#" AutoEventWireup="true" CodeFile="TTBaseDataOuter_1.aspx.cs" Inherits="TTBaseDataOuter_1" %>

<%@ Register Assembly="NickLee.Web.UI" Namespace="NickLee.Web.UI" TagPrefix="NickLee" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1. Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head id="Head1" runat="server">
    <title></title>
    <link id="mainCss" href="css/bluelightmain.css" rel="stylesheet" type="text/css" />

    <script type="text/javascript" src="js/jquery-1.7.2.min.js"></script>
    <script type="text/javascript" src="js/allAHandler.js"></script>
    <script type="text/javascript" src="js/SetSortTextBoxMustInputIntegerNumber.js"></script>

    <style type="text/css">
        select {
            height: 30px;
        }


        .action-icons {
            display: flex;
            gap: 5px;
            margin: 5px 0;
        }

        .action-icon {
            cursor: pointer;
            font-size: 14px;
            padding: 4px 8px;
            border: 1px solid #ccc;
            border-radius: 3px;
            background: #f5f5f5;
            transition: all 0.3s ease;
        }

            .action-icon:hover {
                background: #e0e0e0;
                transform: translateY(-1px);
                box-shadow: 0 2px 4px rgba(0,0,0,0.2);
            }

        .action-add {
            color: green;
            border-color: green;
        }

        .action-edit {
            color: blue;
            border-color: blue;
        }

        .modal-overlay {
            display: none;
            position: fixed;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
            background: rgba(0,0,0,0.5);
            z-index: 1000;
        }

        .modal-content {
            position: fixed;
            background: white;
            padding: 20px;
            border-radius: 8px;
            box-shadow: 0 4px 20px rgba(0,0,0,0.3);
            min-width: 400px;
            max-width: 90%;
            max-height: 80%;
            overflow-y: auto;
            border: 1px solid #ddd;
        }

        .modal-header {
            border-bottom: 2px solid #57CD1;
            padding-bottom: 10px;
            margin-bottom: 15px;
            color: #333;
        }

        .modal-footer {
            border-top: 1px solid #ddd;
            padding-top: 10px;
            margin-top: 15px;
            text-align: right;
        }

        .close-modal {
            background: #f44336;
            color: white;
            border: none;
            padding: 6px 12px;
            cursor: pointer;
            border-radius: 4px;
            margin-left: 10px;
        }

            .close-modal:hover {
                background: #d32f2f;
            }

        .form-group {
            margin-bottom: 15px;
            display: flex;
            align-items: center;
        }

            .form-group label {
                display: inline-block;
                width: 120px;
                font-weight: bold;
                margin-right: 10px;
            }

            .form-group input, .form-group select {
                flex: 1;
                padding: 6px;
                border: 1px solid #ccc;
                border-radius: 4px;
            }

        .grid-add-icon {
            cursor: pointer;
            color: green;
            font-weight: bold;
            margin-left: 10px;
            font-size: 16px;
            padding: 4px 8px;
            border: 1px solid green;
            border-radius: 4px;
            background: #f0fff0;
            display: inline-block;
            text-align: center;
            min-width: 30px;
            float: right;
        }

            .grid-add-icon:hover {
                background: #e0ffe0;
                transform: translateY(-1px);
                box-shadow: 0 2px 4px rgba(0,255,0,0.2);
            }

        .header-cell {
            position: relative;
        }

        .header-with-icon {
            display: flex;
            justify-content: space-between;
            align-items: center;
        }

        .table-header-row {
            display: flex;
            justify-content: space-between;
            align-items: center;
            width: 100%;
        }
    </style>
    <script type="text/javascript" language="javascript">
        $(function () {
            if (top.location != self.location) { } else { CloseWebPage(); }
        });

        function showModal(modalId, buttonElement) {
            var modal = $('#' + modalId);
            modal.show();

            // 获取按钮在视口中的位置
            var buttonRect = buttonElement.getBoundingClientRect();

            // 获取模态框元素
            var modalElement = modal.find('.modal-content')[0];
            var modalWidth = modalElement.offsetWidth;
            var modalHeight = modalElement.offsetHeight;

            // 计算在按钮上方的位置(视口相对位置)
            var topPosition = buttonRect.top - modalHeight - 10; // 按钮上方10px
            var leftPosition = buttonRect.left;

            // 确保模态框不会超出视口
            var viewportWidth = window.innerWidth;
            var viewportHeight = window.innerHeight;

            // 水平方向调整
            if (leftPosition + modalWidth > viewportWidth) {
                leftPosition = Math.max(10, viewportWidth - modalWidth - 10);
            } else if (leftPosition < 0) {
                leftPosition = 10;
            }

            // 如果上方空间不够，调整到按钮下方
            if (topPosition < 0) {
                topPosition = buttonRect.bottom + 10;

                // 如果下方空间也不够，调整到视口中间
                if (topPosition + modalHeight > viewportHeight) {
                    topPosition = Math.max(10, (viewportHeight - modalHeight) / 2);
                }
            }

            // 确保不会超出底部边界
            if (topPosition + modalHeight > viewportHeight) {
                topPosition = Math.max(10, viewportHeight - modalHeight - 10);
            }

            // 设置模态框位置(相对于视口)
            $(modalElement).css({
                'top': topPosition + 'px',
                'left': leftPosition + 'px'
            });
        }

        function hideModal(modalId) {
            $('#' + modalId).hide();
        }

        // 为所有模态框添加点击外部关闭功能
        $(document).on('click', function (e) {
            $('.modal-overlay').each(function () {
                if ($(this).is(':visible') && !$(e.target).closest('.modal-content').length) {
                    $(this).hide();
                }
            });
        });

        // 阻止模态框内容点击事件冒泡
        $(document).on('click', '.modal-content', function (e) {
            e.stopPropagation();
        });

        // 处理新增按钮点击
        function handleAddClick(modalId, event) {
            if (event) {
                event.stopPropagation();
                event.preventDefault();
            }
            showModal(modalId, event.target);
            return false; // 阻止默认行为
        }

        // 全局函数，供后端调用
        function openModal(modalId) {
            var modal = $('#' + modalId);
            modal.show();

            // 居中显示模态框
            var modalElement = modal.find('.modal-content')[0];
            var topPosition = (window.innerHeight - modalElement.offsetHeight) / 2;
            var leftPosition = (window.innerWidth - modalElement.offsetWidth) / 2;

            // 设置模态框位置
            $(modalElement).css({
                'top': Math.max(topPosition, 20) + 'px',
                'left': Math.max(leftPosition, 20) + 'px'
            });
        }

    </script>
</head>
<body>
    <center>
        <form id="form1" runat="server">
            <asp:ScriptManager ID="ScriptManager1" runat="server" EnableScriptGlobalization="True" EnableScriptLocalization="True">
            </asp:ScriptManager>
            <asp:UpdatePanel ID="UpdatePanel1" runat="server">
                <ContentTemplate>
                    <div id="AboveDiv">
                        <table cellpadding="0" cellspacing="0" width="100%" class="bian">
                            <tr>
                                <td class="ItemAlignLeft">
                                    <table style="text-align: center;">
                                        <tr>
                                            <td colspan="5" style="background-color: buttonface; text-align: left;"><strong>
                                                <asp:Label ID="Label492256" runat="server" Text="<%$ Resources:lang,RenShiXinZhunLei%>"></asp:Label>
                                            </strong>

                                            </td>
                                            <td style="background-color: buttonface"></td>
                                            <td style="background-color: buttonface" colspan="2"></td>
                                        </tr>
                                        <tr>
                                            <td colspan="2"><strong>
                                                <div style="display: none;">
                                                    <asp:Label ID="Label492244" runat="server" Text="<%$ Resources:lang,RiChengKeGaiQianZhiTianShu%>"></asp:Label>
                                            </strong>

                                                <br />
                                                <NickLee:NumberBox ID="NB_ScheduleLimitedDays" runat="server" MaxAmount="10" MinAmount="0" Precision="0" Width="50px" Visible="false"></NickLee:NumberBox>
                                                <asp:Button ID="BT_ScheduleLimitedDaysUpdate" runat="server" CssClass="inpu" OnClick="BT_ScheduleLimitedDaysUpdate_Click" Text="<%$ Resources:lang,BaoCun%>" Visible="false" />

                                            </td>
                                            <td class="ItemAlignLeft">
                                                <b>
                                                    <asp:Label ID="Label17" runat="server" Text="<%$ Resources:lang,KPILeiXing%>"></asp:Label>

                                                    <span class="grid-add-icon" onclick="return handleAddClick('modalKPIType', event)">+</span>
                                                </b>


                                            </td>
                                            <td style="height: 7px;">
                                                <strong>
                                                    <asp:Label ID="Label4" runat="server" Text="<%$ Resources:lang,JiXiaoQuanZhongSheDing%>"></asp:Label>
                                                </strong>
                                            </td>
                                            <td class="ItemAlignLeft">
                                                <strong>
                                                    <asp:Label ID="Label43" runat="server" Text="<%$ Resources:lang,ZhiChengSheZhi%>"></asp:Label>
                                                    <span class="grid-add-icon" onclick="return handleAddClick('modalPosition', event)">+</span>
                                                </strong>
                                            </td>
                                            <td class="ItemAlignLeft">
                                                <strong>
                                                    <asp:Label ID="Label436" runat="server" Text="<%$ Resources:lang,ZhiWuSheZhi%>"></asp:Label>
                                                    <span class="grid-add-icon" onclick="return handleAddClick('modalDuty', event)">+</span>
                                                </strong>
                                            </td>
                                            <td class="ItemAlignLeft">
                                                <strong>
                                                    <asp:Label ID="Label425" runat="server" Text="<%$ Resources:lang,YongGongLeiXing%>"></asp:Label>
                                                    <span class="grid-add-icon" onclick="return handleAddClick('modalWorkType', event)">+</span>
                                                </strong>
                                            </td>
                                            <td class="ItemAlignLeft">
                                                <strong>
                                                    <asp:Label ID="Label159" runat="server" Text="<%$ Resources:lang,QingJiaLeiXing%>"></asp:Label>
                                                    <span class="grid-add-icon" onclick="return handleAddClick('modalLeaveType', event)">+</span>
                                                </strong>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td colspan="2" rowspan="5" width="200px;" class="ItemAlignLeft">
                                                <b>
                                                    <asp:Label ID="Label93" runat="server" Text="<%$ Resources:lang,MeiZouGongZuoRiSheDing%>"></asp:Label>
                                                    <br />
                                                </b>
                                                ( 1,2,3,4,5,6,0 )
                                               
                                                <br />
                                                <asp:Label ID="Label88" runat="server" Text="<%$ Resources:lang,ZhouMoKaiShiRiQi%>"></asp:Label>
                                                <br />
                                                <NickLee:NumberBox ID="NB_WeekendFirstDay" runat="server" MaxAmount="10" MinAmount="0" Precision="0" Width="50px" Amount="6">6</NickLee:NumberBox>
                                                <br />
                                                <asp:Label ID="Label89" runat="server" Text="<%$ Resources:lang,ZhouMoJieShuRiQi%>"></asp:Label>
                                                <br />
                                                <NickLee:NumberBox ID="NB_WeekendSecondDay" runat="server" MaxAmount="10" MinAmount="0" Precision="0" Width="50px"></NickLee:NumberBox>
                                                <br />
                                                <asp:Label ID="Label90" runat="server" Text="<%$ Resources:lang,ZhouMoShiHouGongZuoRi%>"></asp:Label>
                                                <br />
                                                <asp:DropDownList ID="DL_WeekendsAreWorkdays" runat="server">
                                                    <asp:ListItem Value="false" Text="NO"></asp:ListItem>
                                                    <asp:ListItem Value="true" Text="YES"></asp:ListItem>
                                                </asp:DropDownList>
                                                <br />
                                                <asp:Button ID="BT_UpdateWeekendFirstDay" runat="server" CssClass="inpu" Text="<%$ Resources:lang,BaoCun%>" OnClick="BT_WorkingDayRuleUpdate_Click" />
                                                <br />
                                                <br />
                                                <b>
                                                    <asp:Label ID="Label492245" runat="server" Text="<%$ Resources:lang,YiTianShangBanShiJianShu%>"></asp:Label></b>
                                                <br />
                                                <table>
                                                    <tr>
                                                        <td class="ItemAlignLeft">
                                                            <asp:Label ID="Label492246" runat="server" Text="<%$ Resources:lang,KaiShiShiJian%>"></asp:Label></td>
                                                        <td class="ItemAlignLeft">
                                                            <asp:DropDownList ID="DL_StartHour" runat="server">
                                                                <asp:ListItem>00</asp:ListItem>
                                                                <asp:ListItem>01</asp:ListItem>
                                                                <asp:ListItem>02</asp:ListItem>
                                                                <asp:ListItem>03</asp:ListItem>
                                                                <asp:ListItem>04</asp:ListItem>
                                                                <asp:ListItem>05</asp:ListItem>
                                                                <asp:ListItem>06</asp:ListItem>
                                                                <asp:ListItem>07</asp:ListItem>
                                                                <asp:ListItem>08</asp:ListItem>
                                                                <asp:ListItem>09</asp:ListItem>
                                                                <asp:ListItem>10</asp:ListItem>
                                                                <asp:ListItem>11</asp:ListItem>
                                                                <asp:ListItem>12</asp:ListItem>
                                                                <asp:ListItem>13</asp:ListItem>
                                                                <asp:ListItem>14</asp:ListItem>
                                                                <asp:ListItem>15</asp:ListItem>
                                                                <asp:ListItem>16</asp:ListItem>
                                                                <asp:ListItem>17</asp:ListItem>
                                                                <asp:ListItem>18</asp:ListItem>
                                                                <asp:ListItem>19</asp:ListItem>
                                                                <asp:ListItem>20</asp:ListItem>
                                                                <asp:ListItem>21</asp:ListItem>
                                                                <asp:ListItem>22</asp:ListItem>
                                                                <asp:ListItem>23</asp:ListItem>
                                                            </asp:DropDownList>
                                                        </td>
                                                        <td class="ItemAlignLeft">:<asp:DropDownList ID="DL_StartMin" runat="server">
                                                            <asp:ListItem>00</asp:ListItem>
                                                            <asp:ListItem>01</asp:ListItem>
                                                            <asp:ListItem>02</asp:ListItem>
                                                            <asp:ListItem>03</asp:ListItem>
                                                            <asp:ListItem>04</asp:ListItem>
                                                            <asp:ListItem>05</asp:ListItem>
                                                            <asp:ListItem>06</asp:ListItem>
                                                            <asp:ListItem>07</asp:ListItem>
                                                            <asp:ListItem>08</asp:ListItem>
                                                            <asp:ListItem>09</asp:ListItem>
                                                            <asp:ListItem>10</asp:ListItem>
                                                            <asp:ListItem>11</asp:ListItem>
                                                            <asp:ListItem>12</asp:ListItem>
                                                            <asp:ListItem>13</asp:ListItem>
                                                            <asp:ListItem>14</asp:ListItem>
                                                            <asp:ListItem>15</asp:ListItem>
                                                            <asp:ListItem>16</asp:ListItem>
                                                            <asp:ListItem>17</asp:ListItem>
                                                            <asp:ListItem>18</asp:ListItem>
                                                            <asp:ListItem>19</asp:ListItem>
                                                            <asp:ListItem>20</asp:ListItem>
                                                            <asp:ListItem>21</asp:ListItem>
                                                            <asp:ListItem>22</asp:ListItem>
                                                            <asp:ListItem>23</asp:ListItem>
                                                            <asp:ListItem>24</asp:ListItem>
                                                            <asp:ListItem>25</asp:ListItem>
                                                            <asp:ListItem>26</asp:ListItem>
                                                            <asp:ListItem>27</asp:ListItem>
                                                            <asp:ListItem>28</asp:ListItem>
                                                            <asp:ListItem>29</asp:ListItem>
                                                            <asp:ListItem>30</asp:ListItem>
                                                            <asp:ListItem>31</asp:ListItem>
                                                            <asp:ListItem>32</asp:ListItem>
                                                            <asp:ListItem>33</asp:ListItem>
                                                            <asp:ListItem>34</asp:ListItem>
                                                            <asp:ListItem>35</asp:ListItem>
                                                            <asp:ListItem>36</asp:ListItem>
                                                            <asp:ListItem>37</asp:ListItem>
                                                            <asp:ListItem>38</asp:ListItem>
                                                            <asp:ListItem>39</asp:ListItem>
                                                            <asp:ListItem>40</asp:ListItem>
                                                            <asp:ListItem>41</asp:ListItem>
                                                            <asp:ListItem>42</asp:ListItem>
                                                            <asp:ListItem>43</asp:ListItem>
                                                            <asp:ListItem>44</asp:ListItem>
                                                            <asp:ListItem>45</asp:ListItem>
                                                            <asp:ListItem>46</asp:ListItem>
                                                            <asp:ListItem>47</asp:ListItem>
                                                            <asp:ListItem>48</asp:ListItem>
                                                            <asp:ListItem>49</asp:ListItem>
                                                            <asp:ListItem>50</asp:ListItem>
                                                            <asp:ListItem>51</asp:ListItem>
                                                            <asp:ListItem>52</asp:ListItem>
                                                            <asp:ListItem>53</asp:ListItem>
                                                            <asp:ListItem>54</asp:ListItem>
                                                            <asp:ListItem>55</asp:ListItem>
                                                            <asp:ListItem>56</asp:ListItem>
                                                            <asp:ListItem>57</asp:ListItem>
                                                            <asp:ListItem>58</asp:ListItem>
                                                            <asp:ListItem>59</asp:ListItem>
                                                        </asp:DropDownList></td>
                                                    </tr>
                                                    <tr>
                                                        <td class="ItemAlignLeft">
                                                            <asp:Label ID="Label492247" runat="server" Text="<%$ Resources:lang,JieShuShiJian%>"></asp:Label></td>
                                                        <td class="ItemAlignLeft">
                                                            <asp:DropDownList ID="DL_EndHour" runat="server">
                                                                <asp:ListItem>00</asp:ListItem>
                                                                <asp:ListItem>01</asp:ListItem>
                                                                <asp:ListItem>02</asp:ListItem>
                                                                <asp:ListItem>03</asp:ListItem>
                                                                <asp:ListItem>04</asp:ListItem>
                                                                <asp:ListItem>05</asp:ListItem>
                                                                <asp:ListItem>06</asp:ListItem>
                                                                <asp:ListItem>07</asp:ListItem>
                                                                <asp:ListItem>08</asp:ListItem>
                                                                <asp:ListItem>09</asp:ListItem>
                                                                <asp:ListItem>10</asp:ListItem>
                                                                <asp:ListItem>11</asp:ListItem>
                                                                <asp:ListItem>12</asp:ListItem>
                                                                <asp:ListItem>13</asp:ListItem>
                                                                <asp:ListItem>14</asp:ListItem>
                                                                <asp:ListItem>15</asp:ListItem>
                                                                <asp:ListItem>16</asp:ListItem>
                                                                <asp:ListItem>17</asp:ListItem>
                                                                <asp:ListItem>18</asp:ListItem>
                                                                <asp:ListItem>19</asp:ListItem>
                                                                <asp:ListItem>20</asp:ListItem>
                                                                <asp:ListItem>21</asp:ListItem>
                                                                <asp:ListItem>22</asp:ListItem>
                                                                <asp:ListItem>23</asp:ListItem>
                                                            </asp:DropDownList></td>
                                                        <td class="ItemAlignLeft">:<asp:DropDownList ID="DL_EndMin" runat="server">
                                                            <asp:ListItem>00</asp:ListItem>
                                                            <asp:ListItem>01</asp:ListItem>
                                                            <asp:ListItem>02</asp:ListItem>
                                                            <asp:ListItem>03</asp:ListItem>
                                                            <asp:ListItem>04</asp:ListItem>
                                                            <asp:ListItem>05</asp:ListItem>
                                                            <asp:ListItem>06</asp:ListItem>
                                                            <asp:ListItem>07</asp:ListItem>
                                                            <asp:ListItem>08</asp:ListItem>
                                                            <asp:ListItem>09</asp:ListItem>
                                                            <asp:ListItem>10</asp:ListItem>
                                                            <asp:ListItem>11</asp:ListItem>
                                                            <asp:ListItem>12</asp:ListItem>
                                                            <asp:ListItem>13</asp:ListItem>
                                                            <asp:ListItem>14</asp:ListItem>
                                                            <asp:ListItem>15</asp:ListItem>
                                                            <asp:ListItem>16</asp:ListItem>
                                                            <asp:ListItem>17</asp:ListItem>
                                                            <asp:ListItem>18</asp:ListItem>
                                                            <asp:ListItem>19</asp:ListItem>
                                                            <asp:ListItem>20</asp:ListItem>
                                                            <asp:ListItem>21</asp:ListItem>
                                                            <asp:ListItem>22</asp:ListItem>
                                                            <asp:ListItem>23</asp:ListItem>
                                                            <asp:ListItem>24</asp:ListItem>
                                                            <asp:ListItem>25</asp:ListItem>
                                                            <asp:ListItem>26</asp:ListItem>
                                                            <asp:ListItem>27</asp:ListItem>
                                                            <asp:ListItem>28</asp:ListItem>
                                                            <asp:ListItem>29</asp:ListItem>
                                                            <asp:ListItem>30</asp:ListItem>
                                                            <asp:ListItem>31</asp:ListItem>
                                                            <asp:ListItem>32</asp:ListItem>
                                                            <asp:ListItem>33</asp:ListItem>
                                                            <asp:ListItem>34</asp:ListItem>
                                                            <asp:ListItem>35</asp:ListItem>
                                                            <asp:ListItem>36</asp:ListItem>
                                                            <asp:ListItem>37</asp:ListItem>
                                                            <asp:ListItem>38</asp:ListItem>
                                                            <asp:ListItem>39</asp:ListItem>
                                                            <asp:ListItem>40</asp:ListItem>
                                                            <asp:ListItem>41</asp:ListItem>
                                                            <asp:ListItem>42</asp:ListItem>
                                                            <asp:ListItem>43</asp:ListItem>
                                                            <asp:ListItem>44</asp:ListItem>
                                                            <asp:ListItem>45</asp:ListItem>
                                                            <asp:ListItem>46</asp:ListItem>
                                                            <asp:ListItem>47</asp:ListItem>
                                                            <asp:ListItem>48</asp:ListItem>
                                                            <asp:ListItem>49</asp:ListItem>
                                                            <asp:ListItem>50</asp:ListItem>
                                                            <asp:ListItem>51</asp:ListItem>
                                                            <asp:ListItem>52</asp:ListItem>
                                                            <asp:ListItem>53</asp:ListItem>
                                                            <asp:ListItem>54</asp:ListItem>
                                                            <asp:ListItem>55</asp:ListItem>
                                                            <asp:ListItem>56</asp:ListItem>
                                                            <asp:ListItem>57</asp:ListItem>
                                                            <asp:ListItem>58</asp:ListItem>
                                                            <asp:ListItem>59</asp:ListItem>
                                                        </asp:DropDownList></td>
                                                    </tr>
                                                    <tr>
                                                        <td class="ItemAlignLeft">
                                                            <asp:Label ID="Label492248" runat="server" Text="<%$ Resources:lang,XiuXiShiJianYi%>"></asp:Label></td>
                                                        <td class="ItemAlignLeft">
                                                            <asp:DropDownList ID="DL_RestStartTimeHour" runat="server">
                                                                <asp:ListItem>00</asp:ListItem>
                                                                <asp:ListItem>01</asp:ListItem>
                                                                <asp:ListItem>02</asp:ListItem>
                                                                <asp:ListItem>03</asp:ListItem>
                                                                <asp:ListItem>04</asp:ListItem>
                                                                <asp:ListItem>05</asp:ListItem>
                                                                <asp:ListItem>06</asp:ListItem>
                                                                <asp:ListItem>07</asp:ListItem>
                                                                <asp:ListItem>08</asp:ListItem>
                                                                <asp:ListItem>09</asp:ListItem>
                                                                <asp:ListItem>10</asp:ListItem>
                                                                <asp:ListItem>11</asp:ListItem>
                                                                <asp:ListItem>12</asp:ListItem>
                                                                <asp:ListItem>13</asp:ListItem>
                                                                <asp:ListItem>14</asp:ListItem>
                                                                <asp:ListItem>15</asp:ListItem>
                                                                <asp:ListItem>16</asp:ListItem>
                                                                <asp:ListItem>17</asp:ListItem>
                                                                <asp:ListItem>18</asp:ListItem>
                                                                <asp:ListItem>19</asp:ListItem>
                                                                <asp:ListItem>20</asp:ListItem>
                                                                <asp:ListItem>21</asp:ListItem>
                                                                <asp:ListItem>22</asp:ListItem>
                                                                <asp:ListItem>23</asp:ListItem>
                                                            </asp:DropDownList></td>
                                                        <td class="ItemAlignLeft">:<asp:DropDownList ID="DL_RestStartTimeMin" runat="server">
                                                            <asp:ListItem>00</asp:ListItem>
                                                            <asp:ListItem>01</asp:ListItem>
                                                            <asp:ListItem>02</asp:ListItem>
                                                            <asp:ListItem>03</asp:ListItem>
                                                            <asp:ListItem>04</asp:ListItem>
                                                            <asp:ListItem>05</asp:ListItem>
                                                            <asp:ListItem>06</asp:ListItem>
                                                            <asp:ListItem>07</asp:ListItem>
                                                            <asp:ListItem>08</asp:ListItem>
                                                            <asp:ListItem>09</asp:ListItem>
                                                            <asp:ListItem>10</asp:ListItem>
                                                            <asp:ListItem>11</asp:ListItem>
                                                            <asp:ListItem>12</asp:ListItem>
                                                            <asp:ListItem>13</asp:ListItem>
                                                            <asp:ListItem>14</asp:ListItem>
                                                            <asp:ListItem>15</asp:ListItem>
                                                            <asp:ListItem>16</asp:ListItem>
                                                            <asp:ListItem>17</asp:ListItem>
                                                            <asp:ListItem>18</asp:ListItem>
                                                            <asp:ListItem>19</asp:ListItem>
                                                            <asp:ListItem>20</asp:ListItem>
                                                            <asp:ListItem>21</asp:ListItem>
                                                            <asp:ListItem>22</asp:ListItem>
                                                            <asp:ListItem>23</asp:ListItem>
                                                            <asp:ListItem>24</asp:ListItem>
                                                            <asp:ListItem>25</asp:ListItem>
                                                            <asp:ListItem>26</asp:ListItem>
                                                            <asp:ListItem>27</asp:ListItem>
                                                            <asp:ListItem>28</asp:ListItem>
                                                            <asp:ListItem>29</asp:ListItem>
                                                            <asp:ListItem>30</asp:ListItem>
                                                            <asp:ListItem>31</asp:ListItem>
                                                            <asp:ListItem>32</asp:ListItem>
                                                            <asp:ListItem>33</asp:ListItem>
                                                            <asp:ListItem>34</asp:ListItem>
                                                            <asp:ListItem>35</asp:ListItem>
                                                            <asp:ListItem>36</asp:ListItem>
                                                            <asp:ListItem>37</asp:ListItem>
                                                            <asp:ListItem>38</asp:ListItem>
                                                            <asp:ListItem>39</asp:ListItem>
                                                            <asp:ListItem>40</asp:ListItem>
                                                            <asp:ListItem>41</asp:ListItem>
                                                            <asp:ListItem>42</asp:ListItem>
                                                            <asp:ListItem>43</asp:ListItem>
                                                            <asp:ListItem>44</asp:ListItem>
                                                            <asp:ListItem>45</asp:ListItem>
                                                            <asp:ListItem>46</asp:ListItem>
                                                            <asp:ListItem>47</asp:ListItem>
                                                            <asp:ListItem>48</asp:ListItem>
                                                            <asp:ListItem>49</asp:ListItem>
                                                            <asp:ListItem>50</asp:ListItem>
                                                            <asp:ListItem>51</asp:ListItem>
                                                            <asp:ListItem>52</asp:ListItem>
                                                            <asp:ListItem>53</asp:ListItem>
                                                            <asp:ListItem>54</asp:ListItem>
                                                            <asp:ListItem>55</asp:ListItem>
                                                            <asp:ListItem>56</asp:ListItem>
                                                            <asp:ListItem>57</asp:ListItem>
                                                            <asp:ListItem>58</asp:ListItem>
                                                            <asp:ListItem>59</asp:ListItem>
                                                        </asp:DropDownList></td>
                                                    </tr>
                                                    <tr>
                                                        <td class="ItemAlignLeft">
                                                            <asp:Label ID="Label492249" runat="server" Text="<%$ Resources:lang,XiuXiShiJianEr%>"></asp:Label></td>
                                                        <td class="ItemAlignLeft">
                                                            <asp:DropDownList ID="DL_RestEndTimeHour" runat="server">
                                                                <asp:ListItem>00</asp:ListItem>
                                                                <asp:ListItem>01</asp:ListItem>
                                                                <asp:ListItem>02</asp:ListItem>
                                                                <asp:ListItem>03</asp:ListItem>
                                                                <asp:ListItem>04</asp:ListItem>
                                                                <asp:ListItem>05</asp:ListItem>
                                                                <asp:ListItem>06</asp:ListItem>
                                                                <asp:ListItem>07</asp:ListItem>
                                                                <asp:ListItem>08</asp:ListItem>
                                                                <asp:ListItem>09</asp:ListItem>
                                                                <asp:ListItem>10</asp:ListItem>
                                                                <asp:ListItem>11</asp:ListItem>
                                                                <asp:ListItem>12</asp:ListItem>
                                                                <asp:ListItem>13</asp:ListItem>
                                                                <asp:ListItem>14</asp:ListItem>
                                                                <asp:ListItem>15</asp:ListItem>
                                                                <asp:ListItem>16</asp:ListItem>
                                                                <asp:ListItem>17</asp:ListItem>
                                                                <asp:ListItem>18</asp:ListItem>
                                                                <asp:ListItem>19</asp:ListItem>
                                                                <asp:ListItem>20</asp:ListItem>
                                                                <asp:ListItem>21</asp:ListItem>
                                                                <asp:ListItem>22</asp:ListItem>
                                                                <asp:ListItem>23</asp:ListItem>
                                                            </asp:DropDownList></td>
                                                        <td class="ItemAlignLeft">:<asp:DropDownList ID="DL_RestEndTimeMin" runat="server">
                                                            <asp:ListItem>00</asp:ListItem>
                                                            <asp:ListItem>01</asp:ListItem>
                                                            <asp:ListItem>02</asp:ListItem>
                                                            <asp:ListItem>03</asp:ListItem>
                                                            <asp:ListItem>04</asp:ListItem>
                                                            <asp:ListItem>05</asp:ListItem>
                                                            <asp:ListItem>06</asp:ListItem>
                                                            <asp:ListItem>07</asp:ListItem>
                                                            <asp:ListItem>08</asp:ListItem>
                                                            <asp:ListItem>09</asp:ListItem>
                                                            <asp:ListItem>10</asp:ListItem>
                                                            <asp:ListItem>11</asp:ListItem>
                                                            <asp:ListItem>12</asp:ListItem>
                                                            <asp:ListItem>13</asp:ListItem>
                                                            <asp:ListItem>14</asp:ListItem>
                                                            <asp:ListItem>15</asp:ListItem>
                                                            <asp:ListItem>16</asp:ListItem>
                                                            <asp:ListItem>17</asp:ListItem>
                                                            <asp:ListItem>18</asp:ListItem>
                                                            <asp:ListItem>19</asp:ListItem>
                                                            <asp:ListItem>20</asp:ListItem>
                                                            <asp:ListItem>21</asp:ListItem>
                                                            <asp:ListItem>22</asp:ListItem>
                                                            <asp:ListItem>23</asp:ListItem>
                                                            <asp:ListItem>24</asp:ListItem>
                                                            <asp:ListItem>25</asp:ListItem>
                                                            <asp:ListItem>26</asp:ListItem>
                                                            <asp:ListItem>27</asp:ListItem>
                                                            <asp:ListItem>28</asp:ListItem>
                                                            <asp:ListItem>29</asp:ListItem>
                                                            <asp:ListItem>30</asp:ListItem>
                                                            <asp:ListItem>31</asp:ListItem>
                                                            <asp:ListItem>32</asp:ListItem>
                                                            <asp:ListItem>33</asp:ListItem>
                                                            <asp:ListItem>34</asp:ListItem>
                                                            <asp:ListItem>35</asp:ListItem>
                                                            <asp:ListItem>36</asp:ListItem>
                                                            <asp:ListItem>37</asp:ListItem>
                                                            <asp:ListItem>38</asp:ListItem>
                                                            <asp:ListItem>39</asp:ListItem>
                                                            <asp:ListItem>40</asp:ListItem>
                                                            <asp:ListItem>41</asp:ListItem>
                                                            <asp:ListItem>42</asp:ListItem>
                                                            <asp:ListItem>43</asp:ListItem>
                                                            <asp:ListItem>44</asp:ListItem>
                                                            <asp:ListItem>45</asp:ListItem>
                                                            <asp:ListItem>46</asp:ListItem>
                                                            <asp:ListItem>47</asp:ListItem>
                                                            <asp:ListItem>48</asp:ListItem>
                                                            <asp:ListItem>49</asp:ListItem>
                                                            <asp:ListItem>50</asp:ListItem>
                                                            <asp:ListItem>51</asp:ListItem>
                                                            <asp:ListItem>52</asp:ListItem>
                                                            <asp:ListItem>53</asp:ListItem>
                                                            <asp:ListItem>54</asp:ListItem>
                                                            <asp:ListItem>55</asp:ListItem>
                                                            <asp:ListItem>56</asp:ListItem>
                                                            <asp:ListItem>57</asp:ListItem>
                                                            <asp:ListItem>58</asp:ListItem>
                                                            <asp:ListItem>59</asp:ListItem>
                                                        </asp:DropDownList></td>
                                                    </tr>
                                                </table>

                                                <br />
                                                <asp:Label ID="Label492250" runat="server" Text="<%$ Resources:lang,GongZuoShiJian%>"></asp:Label>
                                                <asp:TextBox ID="TB_HourNum" runat="server" Width="85px">8</asp:TextBox>
                                                <br />
                                                <br />
                                                <asp:Button ID="BT_DayHourNum" runat="server" CssClass="inpu" OnClick="BT_DayHourNum_Click" Text="<%$ Resources:lang,BaoCun%>" />
                                                <br />
                                                <asp:Label ID="lbl_DayHourNumID" runat="server" Visible="False"></asp:Label>


                                            </td>

                                            <td valign="top" rowspan="5" class="ItemAlignLeft">
                                                <table background="ImagesSkin/main_n_bj.jpg" border="0" cellpadding="0" cellspacing="0" width="98%">
                                                    <tr>
                                                        <td width="7">
                                                            <img src="ImagesSkin/main_n_l.jpg" width="7" height="26" />
                                                        </td>
                                                        <td>
                                                            <table border="0" cellpadding="0" cellspacing="0" width="100%">
                                                                <tr>
                                                                    <td class="ItemAlignLeft" width="60%"><strong>
                                                                        <asp:Label ID="Label111" runat="server" Text="<%$ Resources:lang,LeiXing%>"></asp:Label>
                                                                    </strong></td>
                                                                    <td class="ItemAlignLeft" width="40%"><strong>
                                                                        <asp:Label ID="Label112" runat="server" Text="<%$ Resources:lang,ShunXuHao%>"></asp:Label>
                                                                    </strong></td>
                                                                </tr>
                                                            </table>
                                                        </td>
                                                        <td align="right" width="6">
                                                            <img src="ImagesSkin/main_n_r.jpg" width="6" alt="" height="26" />
                                                        </td>
                                                    </tr>
                                                </table>
                                                <asp:DataGrid ID="DataGrid30" runat="server" AutoGenerateColumns="False" CellPadding="4" ForeColor="#333333" GridLines="None" OnItemCommand="DataGrid30_ItemCommand" ShowHeader="false" Width="98%">
                                                    <FooterStyle BackColor="#57CD1" Font-Bold="True" ForeColor="White" />
                                                    <EditItemStyle BackColor="#2461BF" />
                                                    <SelectedItemStyle BackColor="#D1DDF1" Font-Bold="True" ForeColor="#333333" />
                                                    <PagerStyle CssClass="notTab" HorizontalAlign="center" Mode="NumericPages" NextPageText="" PrevPageText="" />
                                                    <ItemStyle CssClass="itemStyle" />
                                                    <Columns>
                                                        <asp:TemplateColumn HeaderText="Name">
                                                            <ItemTemplate>
                                                                <asp:Button ID="BT_KPIType" runat="server" CssClass="inpu" Text='<%# DataBinder.Eval(Container.DataItem,"Type") %>' CommandName="Edit" />
                                                            </ItemTemplate>
                                                            <ItemStyle CssClass="itemBorder" HorizontalAlign="left" Width="60%" />
                                                        </asp:TemplateColumn>
                                                        <asp:BoundColumn DataField="SortNumber" HeaderText="顺序">
                                                            <ItemStyle CssClass="itemBorder" HorizontalAlign="left" Width="40%" />
                                                        </asp:BoundColumn>
                                                    </Columns>
                                                    <HeaderStyle BackColor="#57CD1" Font-Bold="True" ForeColor="White" />
                                                </asp:DataGrid>
                                            </td>
                                            <td valign="top" class="ItemAlignLeft">
                                                <table background="ImagesSkin/main_n_bj.jpg" border="0" cellpadding="0" cellspacing="0" width="98%">
                                                    <tr>
                                                        <td width="7">
                                                            <img src="ImagesSkin/main_n_l.jpg" width="7" height="26" />
                                                        </td>
                                                        <td class="ItemAlignLeft">&nbsp;</td>
                                                        <td align="right" width="6">
                                                            <img src="ImagesSkin/main_n_r.jpg" width="6" alt="" height="26" />
                                                        </td>
                                                    </tr>
                                                </table>
                                                <table>
                                                    <tr>
                                                        <td class="ItemAlignLeft">
                                                            <div style="width: 100px;">
                                                                <asp:Label ID="Label9" runat="server" Text="<%$ Resources:lang,ZiPingQuanZhong%>"></asp:Label>
                                                            </div>
                                                        </td>
                                                        <td class="ItemAlignLeft">
                                                            <NickLee:NumberBox ID="NB_KPISelfCheckWeight" runat="server" MaxAmount="10" MinAmount="0" Width="50px">.</NickLee:NumberBox>
                                                        </td>
                                                    </tr>
                                                    <tr>
                                                        <td class="ItemAlignLeft">
                                                            <asp:Label ID="Label22221" runat="server" Text="<%$ Resources:lang,LingDaoQuanPingZhong%>"></asp:Label>
                                                        </td>
                                                        <td class="ItemAlignLeft">
                                                            <NickLee:NumberBox ID="NB_KPILeaderCheckWeight" runat="server" MaxAmount="10" MinAmount="0" Width="50px">.</NickLee:NumberBox>
                                                        </td>
                                                    </tr>
                                                    <tr>
                                                        <td class="ItemAlignLeft">
                                                            <asp:Label ID="Label11" runat="server" Text="<%$ Resources:lang,DiSanFangPingQuanZhong%>"></asp:Label>
                                                        </td>
                                                        <td class="ItemAlignLeft">
                                                            <NickLee:NumberBox ID="NB_KPIThirdPartCheckWeight" runat="server" MaxAmount="10" MinAmount="0" Width="50px">.</NickLee:NumberBox>
                                                        </td>
                                                    </tr>
                                                    <tr>
                                                        <td class="ItemAlignLeft">
                                                            <asp:Label ID="Label12" runat="server" Text="<%$ Resources:lang,XiTongPingQuanZhong%>"></asp:Label>
                                                        </td>
                                                        <td class="ItemAlignLeft">
                                                            <NickLee:NumberBox ID="NB_KPISqlCheckWeight" runat="server" MaxAmount="10" MinAmount="0" Width="50px">.</NickLee:NumberBox>
                                                        </td>
                                                    </tr>
                                                    <tr>
                                                        <td class="ItemAlignLeft">
                                                            <asp:Label ID="Label13" runat="server" Text="<%$ Resources:lang,RenShiPingQuanZhong%>"></asp:Label>
                                                        </td>
                                                        <td class="ItemAlignLeft">
                                                            <NickLee:NumberBox ID="NB_KPIHRCheckWeight" runat="server" MaxAmount="10" MinAmount="0" Width="50px">.</NickLee:NumberBox>
                                                        </td>
                                                    </tr>
                                                </table>
                                                <br />
                                                <br />
                                                <asp:Button ID="BT_KPICheckWeight" runat="server" CssClass="inpu" OnClick="BT_KPICheckWeight_Click" Text="<%$ Resources:lang,BaoCun%>" />
                                            </td>
                                            <td rowspan="5" class="ItemAlignLeft">
                                                <table background="ImagesSkin/main_n_bj.jpg" cellpadding="0" cellspacing="0" width="100%">
                                                    <tr>
                                                        <td width="7">
                                                            <img src="ImagesSkin/main_n_l.jpg" width="7" height="26" />
                                                        </td>
                                                        <td>
                                                            <table border="0" cellpadding="0" cellspacing="0" width="100%">
                                                                <tr>
                                                                    <td class="ItemAlignLeft" width="20%"><strong>
                                                                        <asp:Label ID="Label431" runat="server" Text="<%$ Resources:lang,XuHao%>"></asp:Label>
                                                                    </strong></td>
                                                                    <td class="ItemAlignLeft" width="60%"><strong>
                                                                        <asp:Label ID="Label432" runat="server" Text="<%$ Resources:lang,ZhiCheng%>"></asp:Label>
                                                                    </strong></td>
                                                                    <td class="ItemAlignLeft" width="20%"><strong>
                                                                        <asp:Label ID="Label433" runat="server" Text="<%$ Resources:lang,ShunXuHao%>"></asp:Label>
                                                                    </strong></td>
                                                                </tr>
                                                            </table>
                                                        </td>
                                                        <td align="right" width="6">
                                                            <img src="ImagesSkin/main_n_r.jpg" width="6" alt="" height="26" />
                                                        </td>
                                                    </tr>
                                                </table>
                                                <asp:DataGrid ID="DataGrid40" runat="server" AutoGenerateColumns="False" GridLines="None" OnItemCommand="DataGrid40_ItemCommand" ShowHeader="False" Width="100%">
                                                    <FooterStyle BackColor="#57CD1" Font-Bold="True" ForeColor="White" />
                                                    <EditItemStyle BackColor="#2461BF" />
                                                    <SelectedItemStyle BackColor="#D1DDF1" Font-Bold="True" ForeColor="#333333" />
                                                    <PagerStyle CssClass="notTab" HorizontalAlign="center" Mode="NumericPages" NextPageText="" PrevPageText="" />
                                                    <ItemStyle CssClass="itemStyle" />
                                                    <Columns>
                                                        <asp:TemplateColumn HeaderText="SerialNumber">
                                                            <ItemTemplate>
                                                                <asp:Button ID="BT_PositionID" runat="server" CssClass="inpu" Text='<%# DataBinder.Eval(Container.DataItem,"ID") %>' CommandName="Edit" />
                                                            </ItemTemplate>
                                                            <ItemStyle CssClass="itemBorder" HorizontalAlign="left" Width="20%" />
                                                        </asp:TemplateColumn>
                                                        <asp:BoundColumn DataField="Position" HeaderText="ProfessionalTitle">
                                                            <ItemStyle CssClass="itemBorder" HorizontalAlign="left" Width="60%" />
                                                        </asp:BoundColumn>
                                                        <asp:BoundColumn DataField="SortNumber" HeaderText="顺序">
                                                            <ItemStyle CssClass="itemBorder" HorizontalAlign="left" Width="20%" />
                                                        </asp:BoundColumn>
                                                    </Columns>
                                                </asp:DataGrid>
                                            </td>
                                            <td class="ItemAlignLeft" rowspan="5">
                                                <table background="ImagesSkin/main_n_bj.jpg" cellpadding="0" cellspacing="0" width="100%">
                                                    <tr>
                                                        <td width="7">
                                                            <img src="ImagesSkin/main_n_l.jpg" width="7" height="26" />
                                                        </td>
                                                        <td>
                                                            <table border="0" cellpadding="0" cellspacing="0" width="100%">
                                                                <tr>
                                                                    <td class="ItemAlignLeft" width="60%"><strong>
                                                                        <asp:Label ID="Label437" runat="server" Text="<%$ Resources:lang,ZhiWu%>"></asp:Label>
                                                                    </strong></td>
                                                                    <td class="ItemAlignLeft" width="20%"><strong>
                                                                        <asp:Label ID="Label438" runat="server" Text="<%$ Resources:lang,GuanJianZi%>"></asp:Label>
                                                                    </strong></td>
                                                                    <td class="ItemAlignLeft" width="20%"><strong>
                                                                        <asp:Label ID="Label439" runat="server" Text="<%$ Resources:lang,ShunXuHao%>"></asp:Label>
                                                                    </strong></td>
                                                                </tr>
                                                            </table>
                                                        </td>
                                                        <td align="right" width="6">
                                                            <img src="ImagesSkin/main_n_r.jpg" width="6" alt="" height="26" />
                                                        </td>
                                                    </tr>
                                                </table>
                                                <asp:DataGrid ID="DataGrid1" runat="server" AutoGenerateColumns="False" GridLines="None" OnItemCommand="DataGrid1_ItemCommand" ShowHeader="False" Width="100%">
                                                    <FooterStyle BackColor="#57CD1" Font-Bold="True" ForeColor="White" />
                                                    <EditItemStyle BackColor="#2461BF" />
                                                    <SelectedItemStyle BackColor="#D1DDF1" Font-Bold="True" ForeColor="#333333" />
                                                    <PagerStyle CssClass="notTab" HorizontalAlign="center" Mode="NumericPages" NextPageText="" PrevPageText="" />
                                                    <ItemStyle CssClass="itemStyle" />
                                                    <Columns>
                                                        <asp:TemplateColumn HeaderText="职务">
                                                            <ItemTemplate>
                                                                <asp:Button ID="BT_Duty" runat="server" CssClass="inpu" Text='<%# DataBinder.Eval(Container.DataItem,"Duty") %>' CommandName="Edit" />
                                                            </ItemTemplate>
                                                            <ItemStyle CssClass="itemBorder" HorizontalAlign="left" Width="60%" />
                                                        </asp:TemplateColumn>
                                                        <asp:BoundColumn DataField="KeyWord" HeaderText="关键字">
                                                            <ItemStyle CssClass="itemBorder" HorizontalAlign="left" Width="20%" />
                                                        </asp:BoundColumn>
                                                        <asp:BoundColumn DataField="SortNumber" HeaderText="顺序">
                                                            <ItemStyle CssClass="itemBorder" HorizontalAlign="left" Width="20%" />
                                                        </asp:BoundColumn>
                                                    </Columns>
                                                </asp:DataGrid>
                                            </td>
                                            <td rowspan="5" class="ItemAlignLeft">
                                                <table background="ImagesSkin/main_n_bj.jpg" border="0" cellpadding="0" cellspacing="0" width="98%">
                                                    <tr>
                                                        <td>
                                                            <table border="0" cellpadding="0" cellspacing="0" width="100%">
                                                                <tr>
                                                                    <td class="ItemAlignLeft" width="60%"><strong>
                                                                        <asp:Label ID="Label426" runat="server" Text="<%$ Resources:lang,LeiXingMingCheng%>"></asp:Label>
                                                                    </strong></td>
                                                                    <td class="ItemAlignLeft" width="40%"><strong>
                                                                        <asp:Label ID="Label427" runat="server" Text="<%$ Resources:lang,PaiXu%>"></asp:Label>
                                                                    </strong></td>
                                                                </tr>
                                                            </table>
                                                        </td>
                                                    </tr>
                                                </table>
                                                <asp:DataGrid ID="DataGrid34" runat="server" AutoGenerateColumns="False" CellPadding="4" ForeColor="#333333" GridLines="None" OnItemCommand="DataGrid34_ItemCommand" ShowHeader="false" Width="98%">
                                                    <FooterStyle BackColor="#57CD1" Font-Bold="True" ForeColor="White" />
                                                    <EditItemStyle BackColor="#2461BF" />
                                                    <SelectedItemStyle BackColor="#D1DDF1" Font-Bold="True" ForeColor="#333333" />
                                                    <PagerStyle CssClass="notTab" HorizontalAlign="center" Mode="NumericPages" NextPageText="" PrevPageText="" />
                                                    <ItemStyle CssClass="itemStyle" />
                                                    <Columns>
                                                        <asp:TemplateColumn HeaderText="类型名称">
                                                            <ItemTemplate>
                                                                <asp:Button ID="BT_TypeName" runat="server" CssClass="inpu" Text='<%# DataBinder.Eval(Container.DataItem,"TypeName").ToString().Trim() %>' CommandName="Edit" />
                                                            </ItemTemplate>
                                                            <ItemStyle CssClass="itemBorder" HorizontalAlign="left" Width="60%" />
                                                        </asp:TemplateColumn>
                                                        <asp:BoundColumn DataField="SortNo" HeaderText="排序">
                                                            <ItemStyle CssClass="itemBorder" HorizontalAlign="left" Width="40%" />
                                                        </asp:BoundColumn>
                                                    </Columns>
                                                </asp:DataGrid>
                                            </td>
                                            <td rowspan="5" class="ItemAlignLeft">
                                                <table background="ImagesSkin/main_n_bj.jpg" border="0" cellpadding="0" cellspacing="0" width="98%">
                                                    <tr>
                                                        <td>
                                                            <table border="0" cellpadding="0" cellspacing="0" width="100%">
                                                                <tr>
                                                                    <td class="ItemAlignLeft" width="60%"><strong>
                                                                        <asp:Label ID="Label167" runat="server" Text="<%$ Resources:lang,MingCheng%>"></asp:Label>
                                                                    </strong></td>
                                                                    <td class="ItemAlignLeft" width="40%"><strong>
                                                                        <asp:Label ID="Label168" runat="server" Text="<%$ Resources:lang,ShunXuHao%>"></asp:Label>
                                                                    </strong></td>
                                                                </tr>
                                                            </table>
                                                        </td>
                                                    </tr>
                                                </table>
                                                <asp:DataGrid ID="DataGrid17" runat="server" AutoGenerateColumns="False" CellPadding="4" ForeColor="#333333" GridLines="None" OnItemCommand="DataGrid17_ItemCommand" ShowHeader="false" Width="98%">
                                                    <FooterStyle BackColor="#57CD1" Font-Bold="True" ForeColor="White" />
                                                    <EditItemStyle BackColor="#2461BF" />
                                                    <SelectedItemStyle BackColor="#D1DDF1" Font-Bold="True" ForeColor="#333333" />
                                                    <PagerStyle CssClass="notTab" HorizontalAlign="center" Mode="NumericPages" NextPageText="" PrevPageText="" />
                                                    <ItemStyle CssClass="itemStyle" />
                                                    <Columns>
                                                        <asp:TemplateColumn HeaderText="Name">
                                                            <ItemTemplate>
                                                                <asp:Button ID="BT_LeaveType" runat="server" CssClass="inpu" Text='<%# DataBinder.Eval(Container.DataItem,"Type") %>' CommandName="Edit" />
                                                            </ItemTemplate>
                                                            <ItemStyle CssClass="itemBorder" HorizontalAlign="left" Width="60%" />
                                                        </asp:TemplateColumn>
                                                        <asp:BoundColumn DataField="SortNumber" HeaderText="顺序">
                                                            <ItemStyle CssClass="itemBorder" HorizontalAlign="left" Width="40%" />
                                                        </asp:BoundColumn>
                                                    </Columns>
                                                    <HeaderStyle BackColor="#57CD1" Font-Bold="True" ForeColor="White" />
                                                </asp:DataGrid>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td class="ItemAlignLeft">&nbsp;</td>
                                        </tr>
                                        <tr>
                                            <td class="ItemAlignLeft">&nbsp;</td>
                                        </tr>
                                        <tr>
                                            <td class="ItemAlignLeft">&nbsp;</td>
                                        </tr>
                                        <tr>
                                            <td class="ItemAlignLeft">&nbsp;</td>
                                        </tr>

                                        <tr>
                                            <td colspan="8" style="background-color: beige; height: 20px; text-align: left;"><strong>&nbsp; </strong></td>
                                        </tr>
                                        <tr>
                                            <td style="height: 19px;"><strong>
                                                <asp:Label ID="Label21" runat="server" Text="<%$ Resources:lang,JiaBanLeiXing%>"></asp:Label>
                                                <span class="grid-add-icon" onclick="return handleAddClick('modalOvertimeType', event)">+</span>
                                            </strong></td>
                                            <td class="ItemAlignLeft">&nbsp;</td>
                                            <td class="ItemAlignLeft"><strong>
                                                <asp:Label ID="Label492291" runat="server" Text="<%$ Resources:lang,JieRiLeiXing%>"></asp:Label>
                                                <span class="grid-add-icon" onclick="return handleAddClick('modalFestivalsType', event)">+</span>
                                            </strong></td>
                                            <td class="ItemAlignLeft">&nbsp;</td>
                                            <td class="ItemAlignLeft" colspan="4">&nbsp;</td>
                                        </tr>
                                        <tr>
                                            <td class="ItemAlignLeft" valign="top">
                                                <table background="ImagesSkin/main_n_bj.jpg" border="0" cellpadding="0" cellspacing="0" width="98%">
                                                    <tr>
                                                        <td width="7">
                                                            <img src="ImagesSkin/main_n_l.jpg" width="7" height="26" />
                                                        </td>
                                                        <td>
                                                            <table border="0" cellpadding="0" cellspacing="0" width="100%">
                                                                <tr>
                                                                    <td class="ItemAlignLeft" width="60%"><strong>
                                                                        <asp:Label ID="Label108" runat="server" Text="<%$ Resources:lang,LeiXing%>"></asp:Label>
                                                                    </strong></td>
                                                                    <td class="ItemAlignLeft" width="40%"><strong>
                                                                        <asp:Label ID="Label109" runat="server" Text="<%$ Resources:lang,ShunXuHao%>"></asp:Label>
                                                                    </strong></td>
                                                                </tr>
                                                            </table>
                                                        </td>
                                                        <td align="right" width="6">
                                                            <img src="ImagesSkin/main_n_r.jpg" width="6" alt="" height="26" />
                                                        </td>
                                                    </tr>
                                                </table>
                                                <asp:DataGrid ID="DataGrid16" runat="server" AutoGenerateColumns="False" CellPadding="4" ForeColor="#333333" GridLines="None" OnItemCommand="DataGrid16_ItemCommand" ShowHeader="false" Width="98%">
                                                    <FooterStyle BackColor="#57CD1" Font-Bold="True" ForeColor="White" />
                                                    <EditItemStyle BackColor="#2461BF" />
                                                    <SelectedItemStyle BackColor="#D1DDF1" Font-Bold="True" ForeColor="#333333" />
                                                    <PagerStyle CssClass="notTab" HorizontalAlign="center" Mode="NumericPages" NextPageText="" PrevPageText="" />
                                                    <ItemStyle CssClass="itemStyle" />
                                                    <Columns>
                                                        <asp:TemplateColumn HeaderText="Name">
                                                            <ItemTemplate>
                                                                <asp:Button ID="BT_OvertimeType" runat="server" CssClass="inpu" Text='<%# DataBinder.Eval(Container.DataItem,"Type") %>' CommandName="Edit" />
                                                            </ItemTemplate>
                                                            <ItemStyle CssClass="itemBorder" HorizontalAlign="left" Width="60%" />
                                                        </asp:TemplateColumn>
                                                        <asp:BoundColumn DataField="SortNumber" HeaderText="顺序">
                                                            <ItemStyle CssClass="itemBorder" HorizontalAlign="left" Width="40%" />
                                                        </asp:BoundColumn>
                                                    </Columns>
                                                    <HeaderStyle BackColor="#57CD1" Font-Bold="True" ForeColor="White" />
                                                </asp:DataGrid>
                                            </td>
                                            <td class="ItemAlignLeft" valign="top">&nbsp;</td>
                                            <td class="ItemAlignLeft" valign="top">
                                                <table background="ImagesSkin/main_n_bj.jpg" border="0" cellpadding="0" cellspacing="0" width="98%">
                                                    <tr>
                                                        <td width="7">
                                                            <img src="ImagesSkin/main_n_l.jpg" width="7" height="26" />
                                                        </td>
                                                        <td>
                                                            <table border="0" cellpadding="0" cellspacing="0" width="100%">
                                                                <tr>
                                                                    <td class="ItemAlignLeft" width="60%"><strong>
                                                                        <asp:Label ID="Label492287" runat="server" Text="<%$ Resources:lang,LeiXing%>"></asp:Label>
                                                                    </strong></td>
                                                                    <td class="ItemAlignLeft" width="40%"><strong>
                                                                        <asp:Label ID="Label492288" runat="server" Text="<%$ Resources:lang,ShunXuHao%>"></asp:Label>
                                                                    </strong></td>
                                                                </tr>
                                                            </table>
                                                        </td>
                                                        <td align="right" width="6">
                                                            <img src="ImagesSkin/main_n_r.jpg" width="6" alt="" height="26" />
                                                        </td>
                                                    </tr>
                                                </table>
                                                <asp:DataGrid ID="DataGrid50" runat="server" AutoGenerateColumns="False" CellPadding="4" ForeColor="#333333" GridLines="None" OnItemCommand="DataGrid50_ItemCommand" ShowHeader="false" Width="98%">
                                                    <FooterStyle BackColor="#57CD1" Font-Bold="True" ForeColor="White" />
                                                    <EditItemStyle BackColor="#2461BF" />
                                                    <SelectedItemStyle BackColor="#D1DDF1" Font-Bold="True" ForeColor="#333333" />
                                                    <PagerStyle CssClass="notTab" HorizontalAlign="center" Mode="NumericPages" NextPageText="" PrevPageText="" />
                                                    <ItemStyle CssClass="itemStyle" />
                                                    <Columns>
                                                        <asp:TemplateColumn HeaderText="Name">
                                                            <ItemTemplate>
                                                                <asp:Button ID="BT_FestivalsType" runat="server" CssClass="inpu" Text='<%# DataBinder.Eval(Container.DataItem,"Type") %>' CommandName="Edit" />
                                                            </ItemTemplate>
                                                            <ItemStyle CssClass="itemBorder" HorizontalAlign="left" Width="60%" />
                                                        </asp:TemplateColumn>
                                                        <asp:BoundColumn DataField="SortNumber" HeaderText="顺序">
                                                            <ItemStyle CssClass="itemBorder" HorizontalAlign="left" Width="40%" />
                                                        </asp:BoundColumn>
                                                    </Columns>
                                                    <HeaderStyle BackColor="#57CD1" Font-Bold="True" ForeColor="White" />
                                                </asp:DataGrid>
                                            </td>
                                            <td class="ItemAlignLeft" valign="top">&nbsp;</td>
                                            <td class="ItemAlignLeft" colspan="4">&nbsp;</td>
                                        </tr>

                                        <tr>
                                            <td colspan="8"></td>
                                        </tr>
                                        <tr>
                                            <td colspan="8" style="text-align: left; background-color: beige; height: 20px;">

                                                <b>
                                                    <asp:Label ID="Label267" runat="server" Text="<%$ Resources:lang,KaoQinGuiZe%>">
                                                    </asp:Label>


                                                    <span class="grid-add-icon">
                                                        <asp:Button ID="BT_NewAttandanceRule" runat="server" CssClass="inpu" Text="+" OnClick="BT_NewAttendanceRule_Click" />
                                                    </span>

                                                </b>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td colspan="8" class="ItemAlignLeft">
                                                <table background="ImagesSkin/main_n_bj.jpg" border="0" cellpadding="0" cellspacing="0" width="100%">
                                                    <tr>
                                                        <td width="7">
                                                            <img src="ImagesSkin/main_n_l.jpg" width="7" height="26" />
                                                        </td>
                                                        <td>
                                                            <table border="0" cellpadding="0" cellspacing="0" width="100%">
                                                                <tr>
                                                                    <td class="ItemAlignLeft" width="4%"><strong>ID</strong> </td>
                                                                    <td class="ItemAlignLeft" width="4%"><strong>
                                                                        <asp:Label ID="Label268" runat="server" Text="<%$ Resources:lang,ZaoBanShangBanKaiShiShiJian%>"></asp:Label>
                                                                    </strong></td>
                                                                    <td class="ItemAlignLeft" width="4%"><strong>
                                                                        <asp:Label ID="Label269" runat="server" Text="<%$ Resources:lang,ZaoBanShangBanJieShuShiJian%>"></asp:Label>
                                                                    </strong></td>
                                                                    <td class="ItemAlignLeft" width="1%"><strong>
                                                                        <asp:Label ID="Label53" runat="server" Text="IsMust"></asp:Label>
                                                                    </strong></td>

                                                                    <td class="ItemAlignLeft" width="4%"><strong>
                                                                        <asp:Label ID="Label27" runat="server" Text="<%$ Resources:lang,ZaoBanXiaBanKaiShiShiJian%>"></asp:Label>
                                                                    </strong></td>
                                                                    <td class="ItemAlignLeft" width="4%"><strong>
                                                                        <asp:Label ID="Label271" runat="server" Text="<%$ Resources:lang,ZaoBanXiaBanJieShuShiJian%>"></asp:Label>
                                                                    </strong></td>
                                                                    <td class="ItemAlignLeft" width="1%"><strong>
                                                                        <asp:Label ID="Label41" runat="server" Text="IsMust"></asp:Label>
                                                                    </strong></td>

                                                                    <td class="ItemAlignLeft" width="4%"><strong>
                                                                        <asp:Label ID="Label272" runat="server" Text="<%$ Resources:lang,ZhongBanShangBanKaiShiShiJian%>"></asp:Label>
                                                                    </strong></td>
                                                                    <td class="ItemAlignLeft" width="4%"><strong>
                                                                        <asp:Label ID="Label273" runat="server" Text="<%$ Resources:lang,ZhongBanShangBanJieShuShiJian%>"></asp:Label>
                                                                    </strong></td>
                                                                    <td class="ItemAlignLeft" width="1%"><strong>
                                                                        <asp:Label ID="Label42" runat="server" Text="IsMust"></asp:Label>
                                                                    </strong></td>

                                                                    <td class="ItemAlignLeft" width="4%"><strong>
                                                                        <asp:Label ID="Label274" runat="server" Text="<%$ Resources:lang,ZhongBanXiaBanKaiShiShiJian%>"></asp:Label>
                                                                    </strong></td>
                                                                    <td class="ItemAlignLeft" width="4%"><strong>
                                                                        <asp:Label ID="Label275" runat="server" Text="<%$ Resources:lang,ZhongBanXiaBanJieShuShiJian%>"></asp:Label>
                                                                    </strong></td>
                                                                    <td class="ItemAlignLeft" width="1%"><strong>
                                                                        <asp:Label ID="Label46" runat="server" Text="IsMust"></asp:Label>
                                                                    </strong></td>

                                                                    <td class="ItemAlignLeft" width="4%"><strong>
                                                                        <asp:Label ID="Label276" runat="server" Text="<%$ Resources:lang,WanBanShangBanKaiShiShiJian%>"></asp:Label>
                                                                    </strong></td>
                                                                    <td class="ItemAlignLeft" width="4%"><strong>
                                                                        <asp:Label ID="Label277" runat="server" Text="<%$ Resources:lang,WanBanShangBanJieShuShiJian%>"></asp:Label>
                                                                    </strong></td>
                                                                    <td class="ItemAlignLeft" width="1%"><strong>
                                                                        <asp:Label ID="Label48" runat="server" Text="IsMust"></asp:Label>
                                                                    </strong></td>

                                                                    <td class="ItemAlignLeft" width="4%"><strong>
                                                                        <asp:Label ID="Label278" runat="server" Text="<%$ Resources:lang,WanBanXiaBanKaiShiShiJian%>"></asp:Label>
                                                                    </strong></td>
                                                                    <td class="ItemAlignLeft" width="4%"><strong>
                                                                        <asp:Label ID="Label279" runat="server" Text="<%$ Resources:lang,WanBanXiaBanJieShuShiJian%>"></asp:Label>
                                                                    </strong></td>
                                                                    <td class="ItemAlignLeft" width="1%"><strong>
                                                                        <asp:Label ID="Label49" runat="server" Text="IsMust"></asp:Label>
                                                                    </strong></td>

                                                                    <td class="ItemAlignLeft" width="4%"><strong>
                                                                        <asp:Label ID="Label2118" runat="server" Text="<%$ Resources:lang,JiaBanShangBanKaiShiShiJian%>"></asp:Label>
                                                                    </strong></td>
                                                                    <td class="ItemAlignLeft" width="4%"><strong>
                                                                        <asp:Label ID="Label281" runat="server" Text="<%$ Resources:lang,JiaBanShangBanJieShuShiJian%>"></asp:Label>
                                                                    </strong></td>
                                                                    <td class="ItemAlignLeft" width="1%"><strong>
                                                                        <asp:Label ID="Label50" runat="server" Text="IsMust"></asp:Label>
                                                                    </strong></td>

                                                                    <td class="ItemAlignLeft" width="4%"><strong>
                                                                        <asp:Label ID="Label282" runat="server" Text="<%$ Resources:lang,JiaBanXiaBanKaiShiShiJian%>"></asp:Label>
                                                                    </strong></td>
                                                                    <td class="ItemAlignLeft" width="4%"><strong>
                                                                        <asp:Label ID="Label283" runat="server" Text="<%$ Resources:lang,JiaBanXiaBanJieShuShiJian%>"></asp:Label>
                                                                    </strong></td>
                                                                    <td class="ItemAlignLeft" width="1%"><strong>
                                                                        <asp:Label ID="Label52" runat="server" Text="IsMust"></asp:Label>
                                                                    </strong></td>
                                                                    <td class="ItemAlignLeft" width="4%"><strong>
                                                                        <asp:Label ID="Label55" runat="server" Text="<%$ Resources:lang,YunXiZuiDaJuLi%>"></asp:Label>
                                                                    </strong>(<asp:Label ID="Label56" runat="server" Text="<%$ Resources:lang,Mi%>"></asp:Label>)</td>
                                                                </tr>
                                                            </table>
                                                        </td>
                                                        <td align="right" width="6">
                                                            <img src="ImagesSkin/main_n_r.jpg" width="6" alt="" height="26" />
                                                        </td>
                                                    </tr>
                                                </table>
                                                <asp:DataGrid ID="DataGrid24" runat="server" AutoGenerateColumns="False" CellPadding="4" ForeColor="#333333" GridLines="None" OnItemCommand="DataGrid24_ItemCommand" ShowHeader="false" Width="100%">
                                                    <FooterStyle BackColor="#57CD1" Font-Bold="True" ForeColor="White" />
                                                    <EditItemStyle BackColor="#2461BF" />
                                                    <SelectedItemStyle BackColor="#D1DDF1" Font-Bold="True" ForeColor="#333333" />
                                                    <PagerStyle CssClass="notTab" HorizontalAlign="center" Mode="NumericPages" NextPageText="" PrevPageText="" />
                                                    <ItemStyle CssClass="itemStyle" />
                                                    <Columns>
                                                        <asp:TemplateColumn HeaderText="ID">
                                                            <ItemTemplate>
                                                                <asp:Button ID="BT_ID" runat="server" CssClass="inpu" Text='<%# DataBinder.Eval(Container.DataItem,"ID") %>' CommandName="Edit" />
                                                            </ItemTemplate>
                                                            <ItemStyle CssClass="itemBorder" HorizontalAlign="left" Width="4%" />
                                                        </asp:TemplateColumn>
                                                        <asp:BoundColumn DataField="MCheckInStart" HeaderText="早班上班开始时间">
                                                            <ItemStyle CssClass="itemBorder" HorizontalAlign="left" Width="4%" />
                                                        </asp:BoundColumn>
                                                        <asp:BoundColumn DataField="MCheckInEnd" HeaderText="早班上班结束时间">
                                                            <ItemStyle CssClass="itemBorder" HorizontalAlign="left" Width="4%" />
                                                        </asp:BoundColumn>
                                                        <asp:BoundColumn DataField="MCheckInIsMust" HeaderText="早班上班必须">
                                                            <ItemStyle CssClass="itemBorder" HorizontalAlign="left" Width="1%" />
                                                        </asp:BoundColumn>

                                                        <asp:BoundColumn DataField="MCheckOutStart" HeaderText="早班下班开始时间">
                                                            <ItemStyle CssClass="itemBorder" HorizontalAlign="left" Width="4%" />
                                                        </asp:BoundColumn>
                                                        <asp:BoundColumn DataField="MCheckOutEnd" HeaderText="早班下班结束时间">
                                                            <ItemStyle CssClass="itemBorder" HorizontalAlign="left" Width="4%" />
                                                        </asp:BoundColumn>
                                                        <asp:BoundColumn DataField="MCheckOutIsMust" HeaderText="早班下班必须">
                                                            <ItemStyle CssClass="itemBorder" HorizontalAlign="left" Width="1%" />
                                                        </asp:BoundColumn>

                                                        <asp:BoundColumn DataField="ACheckInStart" HeaderText="中班上班开始时间">
                                                            <ItemStyle CssClass="itemBorder" HorizontalAlign="left" Width="4%" />
                                                        </asp:BoundColumn>
                                                        <asp:BoundColumn DataField="ACheckInEnd" HeaderText="中班上班结束时间">
                                                            <ItemStyle CssClass="itemBorder" HorizontalAlign="left" Width="4%" />
                                                        </asp:BoundColumn>
                                                        <asp:BoundColumn DataField="ACheckInIsMust" HeaderText="中上午上班必须">
                                                            <ItemStyle CssClass="itemBorder" HorizontalAlign="left" Width="1%" />
                                                        </asp:BoundColumn>

                                                        <asp:BoundColumn DataField="ACheckOutStart" HeaderText="中班下班开始时间">
                                                            <ItemStyle CssClass="itemBorder" HorizontalAlign="left" Width="4%" />
                                                        </asp:BoundColumn>
                                                        <asp:BoundColumn DataField="ACheckOutEnd" HeaderText="中班下班结束时间">
                                                            <ItemStyle CssClass="itemBorder" HorizontalAlign="left" Width="4%" />
                                                        </asp:BoundColumn>
                                                        <asp:BoundColumn DataField="ACheckOutIsMust" HeaderText="中午下班必须">
                                                            <ItemStyle CssClass="itemBorder" HorizontalAlign="left" Width="1%" />
                                                        </asp:BoundColumn>

                                                        <asp:BoundColumn DataField="NCheckInStart" HeaderText="晚班上班开始时间">
                                                            <ItemStyle CssClass="itemBorder" HorizontalAlign="left" Width="4%" />
                                                        </asp:BoundColumn>
                                                        <asp:BoundColumn DataField="NCheckInEnd" HeaderText="晚班上班结束时间">
                                                            <ItemStyle CssClass="itemBorder" HorizontalAlign="left" Width="4%" />
                                                        </asp:BoundColumn>
                                                        <asp:BoundColumn DataField="NCheckInIsMust" HeaderText="晚班上班必须">
                                                            <ItemStyle CssClass="itemBorder" HorizontalAlign="left" Width="1%" />
                                                        </asp:BoundColumn>

                                                        <asp:BoundColumn DataField="NCheckOutStart" HeaderText="晚班下班开始时间">
                                                            <ItemStyle CssClass="itemBorder" HorizontalAlign="left" Width="4%" />
                                                        </asp:BoundColumn>
                                                        <asp:BoundColumn DataField="NCheckOutEnd" HeaderText="晚班下班结束时间">
                                                            <ItemStyle CssClass="itemBorder" HorizontalAlign="left" Width="4%" />
                                                        </asp:BoundColumn>
                                                        <asp:BoundColumn DataField="NCheckOutIsMust" HeaderText="晚班下班必须">
                                                            <ItemStyle CssClass="itemBorder" HorizontalAlign="left" Width="1%" />
                                                        </asp:BoundColumn>

                                                        <asp:BoundColumn DataField="OCheckInStart" HeaderText="加班上班开始时间">
                                                            <ItemStyle CssClass="itemBorder" HorizontalAlign="left" Width="4%" />
                                                        </asp:BoundColumn>
                                                        <asp:BoundColumn DataField="OCheckInEnd" HeaderText="加班上班结束时间">
                                                            <ItemStyle CssClass="itemBorder" HorizontalAlign="left" Width="4%" />
                                                        </asp:BoundColumn>
                                                        <asp:BoundColumn DataField="OCheckInIsMust" HeaderText="加班上班必须">
                                                            <ItemStyle CssClass="itemBorder" HorizontalAlign="left" Width="1%" />
                                                        </asp:BoundColumn>

                                                        <asp:BoundColumn DataField="OCheckOutStart" HeaderText="加班下班开始时间">
                                                            <ItemStyle CssClass="itemBorder" HorizontalAlign="left" Width="4%" />
                                                        </asp:BoundColumn>
                                                        <asp:BoundColumn DataField="OCheckOutEnd" HeaderText="加班下班结束时间">
                                                            <ItemStyle CssClass="itemBorder" HorizontalAlign="left" Width="4%" />
                                                        </asp:BoundColumn>
                                                        <asp:BoundColumn DataField="OCheckOutIsMust" HeaderText="加班下班必须">
                                                            <ItemStyle CssClass="itemBorder" HorizontalAlign="left" Width="1%" />
                                                        </asp:BoundColumn>
                                                        <asp:BoundColumn DataField="LargestDistance" HeaderText="MaximumAllowedDistance">
                                                            <ItemStyle CssClass="itemBorder" HorizontalAlign="left" Width="4%" />
                                                        </asp:BoundColumn>
                                                    </Columns>
                                                </asp:DataGrid>
                                            </td>
                                        </tr>

                                    </table>
                                </td>
                            </tr>
                        </table>
                    </div>

                    <!-- 所有模态框定义 -->
                    <!-- KPI类型模态框 -->
                    <div id="modalKPIType" class="modal-overlay">
                        <div class="modal-content">
                            <div class="modal-header">
                                <h3>
                                    <asp:Label ID="LabelModalKPIType" runat="server" Text="<%$ Resources:lang,KPILeiXing%>"></asp:Label></h3>
                            </div>
                            <div class="modal-body">
                                <div class="form-group">
                                    <asp:Label ID="Label492216" runat="server" Text="<%$ Resources:lang,LeiXing%>"></asp:Label>
                                    <asp:TextBox ID="TB_KPIType" runat="server" Width="200px"></asp:TextBox>
                                </div>
                                <div class="form-group">
                                    <asp:Label ID="Label492217" runat="server" Text="<%$ Resources:lang,ShunXuHao%>"></asp:Label>
                                    <asp:TextBox ID="TB_KPITypeSort" runat="server" Width="200px"></asp:TextBox>
                                </div>
                            </div>
                            <div class="modal-footer">
                                <asp:Button ID="BT_AddKPIType" runat="server" CssClass="inpu" OnClick="BT_AddKPIType_Click" Text="<%$ Resources:lang,BaoCun%>" />
                                <asp:Button ID="BT_DeleteKPIType" runat="server" CssClass="inpu" OnClick="BT_DeleteKPIType_Click" OnClientClick="return confirmContinue(getDeleteMsgByLangCode(), this, event)" Text="<%$ Resources:lang,ShanChu%>" />
                                <button type="button" class="close-modal" onclick="hideModal('modalKPIType')">
                                    <asp:Label ID="LabelClose1" runat="server" Text="<%$ Resources:lang,GuanBi%>"></asp:Label>
                                </button>
                            </div>
                        </div>
                    </div>

                    <!-- 职称设置模态框 -->
                    <div id="modalPosition" class="modal-overlay">
                        <div class="modal-content">
                            <div class="modal-header">
                                <h3>
                                    <asp:Label ID="LabelModalPosition" runat="server" Text="<%$ Resources:lang,ZhiChengSheZhi%>"></asp:Label></h3>
                            </div>
                            <div class="modal-body">
                                <div class="form-group">
                                    <asp:Label ID="Label492220" runat="server" Text="<%$ Resources:lang,ZhiCheng%>"></asp:Label>
                                    <asp:TextBox ID="TB_Position" runat="server" Width="200px"></asp:TextBox>
                                </div>
                                <div class="form-group">
                                    <asp:Label ID="Label492221" runat="server" Text="<%$ Resources:lang,ShunXuHao%>"></asp:Label>
                                    <asp:TextBox ID="TB_DepartPositionSort" runat="server" Width="200px"></asp:TextBox>
                                </div>
                                <asp:Label ID="LB_PositionID" runat="server" Visible="false"></asp:Label>
                            </div>
                            <div class="modal-footer">
                                <asp:Button ID="BT_NewPosition" runat="server" CssClass="inpu" OnClick="BT_NewPosition_Click" Text="<%$ Resources:lang,BaoCun%>" />
                                <asp:Button ID="BT_DeletePosition" runat="server" CssClass="inpu" OnClick="BT_DeletePosition_Click" OnClientClick="return confirmContinue(getDeleteMsgByLangCode(), this, event)" Text="<%$ Resources:lang,ShanChu%>" />
                                <button type="button" class="close-modal" onclick="hideModal('modalPosition')">
                                    <asp:Label ID="LabelClose2" runat="server" Text="<%$ Resources:lang,GuanBi%>"></asp:Label>
                                </button>
                            </div>
                        </div>
                    </div>

                    <!-- 职务设置模态框 -->
                    <div id="modalDuty" class="modal-overlay">
                        <div class="modal-content">
                            <div class="modal-header">
                                <h3>
                                    <asp:Label ID="LabelModalDuty" runat="server" Text="<%$ Resources:lang,ZhiWuSheZhi%>"></asp:Label></h3>
                            </div>
                            <div class="modal-body">
                                <div class="form-group">
                                    <asp:Label ID="Label44" runat="server" Text="<%$ Resources:lang,ZhiWu%>"></asp:Label>
                                    <asp:TextBox ID="TB_Duty" runat="server" Width="200px"></asp:TextBox>
                                    <asp:Label ID="LB_Duty_Backup" runat="server" Visible="false"></asp:Label>
                                </div>
                                <div class="form-group">
                                    <asp:Label ID="Label441" runat="server" Text="<%$ Resources:lang,GuanJian%>"></asp:Label>
                                    <asp:TextBox ID="TB_DutyKeyWord" runat="server" Width="200px"></asp:TextBox>
                                    <asp:Label ID="LB_DutyKeyWord_Backup" runat="server" Visible="false"></asp:Label>
                                </div>
                                <div class="form-group">
                                    <asp:Label ID="Label442" runat="server" Text="<%$ Resources:lang,ShunXuHao%>"></asp:Label>
                                    <asp:TextBox ID="TB_DutySort" runat="server" Width="200px"></asp:TextBox>
                                </div>
                            </div>
                            <div class="modal-footer">
                                <asp:Button ID="BT_NewDuty" runat="server" CssClass="inpu" OnClick="BT_NewDuty_Click" Text="<%$ Resources:lang,BaoCun%>" />
                                <asp:Button ID="BT_DeleteDuty" runat="server" CssClass="inpu" OnClick="BT_DeleteDuty_Click" OnClientClick="return confirmContinue(getDeleteMsgByLangCode(), this, event)" Text="<%$ Resources:lang,ShanChu%>" />
                                <button type="button" class="close-modal" onclick="hideModal('modalDuty')">
                                    <asp:Label ID="LabelClose3" runat="server" Text="<%$ Resources:lang,GuanBi%>"></asp:Label>
                                </button>
                            </div>
                        </div>
                    </div>

                    <!-- 用工类型模态框 -->
                    <div id="modalWorkType" class="modal-overlay">
                        <div class="modal-content">
                            <div class="modal-header">
                                <h3>
                                    <asp:Label ID="LabelModalWorkType" runat="server" Text="<%$ Resources:lang,YongGongLeiXing%>"></asp:Label></h3>
                            </div>
                            <div class="modal-body">
                                <div class="form-group">
                                    <asp:Label ID="Label428" runat="server" Text="<%$ Resources:lang,LeiXing%>"></asp:Label>
                                    <asp:TextBox ID="TB_TypeName" runat="server" Width="200px"></asp:TextBox>
                                </div>
                                <div class="form-group">
                                    <asp:Label ID="Label429" runat="server" Text="<%$ Resources:lang,ShunXuHao%>"></asp:Label>
                                    <asp:TextBox ID="TB_TypeSortNo" runat="server" Width="200px"></asp:TextBox>
                                </div>
                            </div>
                            <div class="modal-footer">
                                <asp:Button ID="BT_AddBookReaderType" runat="server" CssClass="inpu" OnClick="BT_AddBookReaderType_Click" Text="<%$ Resources:lang,BaoCun%>" />
                                <asp:Button ID="BT_DeleteBookReaderType" runat="server" CssClass="inpu" OnClick="BT_DeleteBookReaderType_Click" OnClientClick="return confirmContinue(getDeleteMsgByLangCode(), this, event)" Text="<%$ Resources:lang,ShanChu%>" />
                                <button type="button" class="close-modal" onclick="hideModal('modalWorkType')">
                                    <asp:Label ID="LabelClose4" runat="server" Text="<%$ Resources:lang,GuanBi%>"></asp:Label>
                                </button>
                            </div>
                        </div>
                    </div>

                    <!-- 请假类型模态框 -->
                    <div id="modalLeaveType" class="modal-overlay">
                        <div class="modal-content">
                            <div class="modal-header">
                                <h3>
                                    <asp:Label ID="LabelModalLeaveType" runat="server" Text="<%$ Resources:lang,QingJiaLeiXing%>"></asp:Label></h3>
                            </div>
                            <div class="modal-body">
                                <div class="form-group">
                                    <asp:Label ID="Label172" runat="server" Text="<%$ Resources:lang,LeiXing%>"></asp:Label>
                                    <asp:TextBox ID="TB_LeaveType" runat="server" Width="200px"></asp:TextBox>
                                </div>
                                <div class="form-group">
                                    <asp:Label ID="Label177" runat="server" Text="<%$ Resources:lang,ShunXuHao%>"></asp:Label>
                                    <asp:TextBox ID="TB_LeaveSortNumber" runat="server" Width="200px">1</asp:TextBox>
                                </div>
                            </div>
                            <div class="modal-footer">
                                <asp:Button ID="BT_AddLeaveType" runat="server" CssClass="inpu" OnClick="BT_AddLeaveType_Click" Text="<%$ Resources:lang,BaoCun%>" />
                                <asp:Button ID="BT_DeleteLeaveType" runat="server" CssClass="inpu" OnClick="BT_DeleteLeaveType_Click" OnClientClick="return confirmContinue(getDeleteMsgByLangCode(), this, event)" Text="<%$ Resources:lang,ShanChu%>" />
                                <button type="button" class="close-modal" onclick="hideModal('modalLeaveType')">
                                    <asp:Label ID="LabelClose5" runat="server" Text="<%$ Resources:lang,GuanBi%>"></asp:Label>
                                </button>
                            </div>
                        </div>
                    </div>

                    <!-- 加班类型模态框 -->
                    <div id="modalOvertimeType" class="modal-overlay">
                        <div class="modal-content">
                            <div class="modal-header">
                                <h3>
                                    <asp:Label ID="LabelModalOvertimeType" runat="server" Text="<%$ Resources:lang,JiaBanLeiXing%>"></asp:Label></h3>
                            </div>
                            <div class="modal-body">
                                <div class="form-group">
                                    <asp:Label ID="Label110" runat="server" Text="<%$ Resources:lang,LeiXing%>"></asp:Label>
                                    <asp:TextBox ID="TB_OvertimeType" runat="server" Width="200px"></asp:TextBox>
                                </div>
                                <div class="form-group">
                                    <asp:Label ID="Label118" runat="server" Text="<%$ Resources:lang,ShunXuHao%>"></asp:Label>
                                    <asp:TextBox ID="TB_OvertimeTypeSort" runat="server" Width="200px"></asp:TextBox>
                                </div>
                            </div>
                            <div class="modal-footer">
                                <asp:Button ID="BT_OvertimeTypeNew" runat="server" CssClass="inpu" OnClick="BT_OvertimeTypeNew_Click" Text="<%$ Resources:lang,BaoCun%>" />
                                <asp:Button ID="BT_OvertimeTypeDelete" runat="server" CssClass="inpu" OnClick="BT_OvertimeTypeDelete_Click" OnClientClick="return confirmContinue(getDeleteMsgByLangCode(), this, event)" Text="<%$ Resources:lang,ShanChu%>" />
                                <button type="button" class="close-modal" onclick="hideModal('modalOvertimeType')">
                                    <asp:Label ID="LabelClose6" runat="server" Text="<%$ Resources:lang,GuanBi%>"></asp:Label>
                                </button>
                            </div>
                        </div>
                    </div>

                    <!-- 节假日类型模态框 -->
                    <div id="modalFestivalsType" class="modal-overlay">
                        <div class="modal-content">
                            <div class="modal-header">
                                <h3>
                                    <asp:Label ID="LabelModalFestivalsType" runat="server" Text="<%$ Resources:lang,JieRiLeiXing%>"></asp:Label></h3>
                            </div>
                            <div class="modal-body">
                                <div class="form-group">
                                    <asp:Label ID="Label492289" runat="server" Text="<%$ Resources:lang,LeiXing%>"></asp:Label>
                                    <asp:TextBox ID="TB_FestivalsType" runat="server" Width="200px"></asp:TextBox>
                                </div>
                                <div class="form-group">
                                    <asp:Label ID="Label492290" runat="server" Text="<%$ Resources:lang,ShunXuHao%>"></asp:Label>
                                    <asp:TextBox ID="TB_FestivalsTypeSort" runat="server" Width="200px"></asp:TextBox>
                                </div>
                            </div>
                            <div class="modal-footer">
                                <asp:Button ID="BT_FestivalsTypeNew" runat="server" CssClass="inpu" OnClick="BT_FestivalsTypeNew_Click" Text="<%$ Resources:lang,BaoCun%>" />
                                <asp:Button ID="BT_FestivalsTypeDelete" runat="server" CssClass="inpu" OnClick="BT_FestivalsTypeDelete_Click" OnClientClick="return confirmContinue(getDeleteMsgByLangCode(), this, event)" Text="<%$ Resources:lang,ShanChu%>" />
                                <button type="button" class="close-modal" onclick="hideModal('modalFestivalsType')">
                                    <asp:Label ID="LabelClose7" runat="server" Text="<%$ Resources:lang,GuanBi%>"></asp:Label>
                                </button>
                            </div>
                        </div>
                    </div>

                    <!-- 考勤规则模态框 -->
                    <div id="modalAttendanceRule" class="modal-overlay">
                        <div class="modal-content">
                            <div class="modal-header">
                                <h3>
                                    <asp:Label ID="LabelModalAttendanceRule" runat="server" Text="<%$ Resources:lang,KaoQinGuiZe%>"></asp:Label></h3>
                            </div>
                            <table>
                                <tr>
                                    <td class="ItemAlignLeft">
                                        <asp:Label ID="Label284" runat="server" Text="<%$ Resources:lang,BianHao%>"></asp:Label>
                                        <asp:Label ID="LB_AttendanceRuleID" runat="server"></asp:Label>
                                    </td>
                                    <td class="ItemAlignLeft" colspan="7"><span style="color: #CC;">(<asp:Label ID="Label31" runat="server" Text="<%$ Resources:lang,GeShiShiLiZhuYiFenZhongGeShiHeFanWei%>"></asp:Label>
                                        --&gt;<asp:Label ID="Label32" runat="server" Text="<%$ Resources:lang,XSGSHFW%>"></asp:Label>
                                        &gt;<asp:Label ID="Label33" runat="server" Text="<%$ Resources:lang,FZHXSDBNWFS%>"></asp:Label>
                                    </span></td>
                                </tr>
                                <tr>
                                    <td class="ItemAlignLeft" colspan="8">
                                        <asp:Label ID="Label285" runat="server" Text="<%$ Resources:lang,ZaoBanShangBanKaiShiShiJian%>"></asp:Label>
                                        <asp:TextBox ID="TB_MCheckInStart" runat="server" Width="50px"></asp:TextBox>
                                        &nbsp;<asp:Label ID="Label286" runat="server" Text="<%$ Resources:lang,ZaoBanShangBanJieShuShiJian%>"></asp:Label>
                                        <asp:TextBox ID="TB_MCheckInEnd" runat="server" Width="50px"></asp:TextBox>
                                        &nbsp;<asp:Label ID="Label37" runat="server" Text="IsMust"></asp:Label>
                                        <asp:DropDownList ID="DDL_MCheckInIsMust" runat="server">
                                            <asp:ListItem Value="NO"></asp:ListItem>
                                            <asp:ListItem Value="YES"></asp:ListItem>
                                        </asp:DropDownList>

                                        &nbsp;<asp:Label ID="Label287" runat="server" Text="<%$ Resources:lang,ZaoBanXiaBanKaiShiShiJian%>"></asp:Label>
                                        <asp:TextBox ID="TB_MCheckOutStart" runat="server" Width="50px"></asp:TextBox>
                                        &nbsp;<asp:Label ID="Label288" runat="server" Text="<%$ Resources:lang,ZaoBanXiaBanJieShuShiJian%>"></asp:Label>
                                        <asp:TextBox ID="TB_MCheckOutEnd" runat="server" Width="50px"></asp:TextBox>
                                        &nbsp;<asp:Label ID="Label40" runat="server" Text="IsMust"></asp:Label>
                                        <asp:DropDownList ID="DDL_MCheckOutIsMust" runat="server">
                                            <asp:ListItem Value="NO"></asp:ListItem>
                                            <asp:ListItem Value="YES"></asp:ListItem>
                                        </asp:DropDownList>
                                    </td>
                                </tr>
                                <tr>
                                    <td class="ItemAlignLeft" colspan="8" class="ItemAlignLeft">
                                        <asp:Label ID="Label289" runat="server" Text="<%$ Resources:lang,ZhongBanShangBanKaiShiShiJian%>"></asp:Label>
                                        <asp:TextBox ID="TB_ACheckInStart" runat="server" Width="50px"></asp:TextBox>
                                        &nbsp;<asp:Label ID="Label29" runat="server" Text="<%$ Resources:lang,ZhongBanShangBanJieShuShiJian%>"></asp:Label>
                                        <asp:TextBox ID="TB_ACheckInEnd" runat="server" Width="50px"></asp:TextBox>
                                        &nbsp;<asp:Label ID="Label20" runat="server" Text="IsMust"></asp:Label>
                                        <asp:DropDownList ID="DDL_ACheckInIsMust" runat="server">
                                            <asp:ListItem Value="NO"></asp:ListItem>
                                            <asp:ListItem Value="YES"></asp:ListItem>
                                        </asp:DropDownList>
                                        &nbsp;<asp:Label ID="Label291" runat="server" Text="<%$ Resources:lang,ZhongBanXiaBanKaiShiShiJian%>"></asp:Label>
                                        <asp:TextBox ID="TB_ACheckOutStart" runat="server" Width="50px"></asp:TextBox>
                                        &nbsp;<asp:Label ID="Label292" runat="server" Text="<%$ Resources:lang,ZhongBanXiaBanJieShuShiJian%>"></asp:Label>
                                        <asp:TextBox ID="TB_AChectOutEnd" runat="server" Width="50px"></asp:TextBox>
                                        &nbsp;<asp:Label ID="Label22" runat="server" Text="IsMust"></asp:Label>
                                        <asp:DropDownList ID="DDL_ACheckOutIsMust" runat="server">
                                            <asp:ListItem Value="NO"></asp:ListItem>
                                            <asp:ListItem Value="YES"></asp:ListItem>
                                        </asp:DropDownList>
                                    </td>
                                </tr>
                                <tr>
                                    <td class="ItemAlignLeft" colspan="8" class="ItemAlignLeft">
                                        <asp:Label ID="Label293" runat="server" Text="<%$ Resources:lang,WanBanShangBanKaiShiShiJian%>"></asp:Label>
                                        <asp:TextBox ID="TB_NCheckInStart" runat="server" Width="50px"></asp:TextBox>
                                        &nbsp;<asp:Label ID="Label294" runat="server" Text="<%$ Resources:lang,WanBanShangBanJieShuShiJian%>"></asp:Label>
                                        <asp:TextBox ID="TB_NCheckInEnd" runat="server" Width="50px"></asp:TextBox>
                                        &nbsp;<asp:Label ID="Label25" runat="server" Text="IsMust"></asp:Label>
                                        <asp:DropDownList ID="DDL_NCheckInIsMust" runat="server">
                                            <asp:ListItem Value="NO"></asp:ListItem>
                                            <asp:ListItem Value="YES"></asp:ListItem>
                                        </asp:DropDownList>
                                        &nbsp;<asp:Label ID="Label295" runat="server" Text="<%$ Resources:lang,WanBanXiaBanKaiShiShiJian%>"></asp:Label>
                                        <asp:TextBox ID="TB_NCheckOutStart" runat="server" Width="50px"></asp:TextBox>
                                        &nbsp;<asp:Label ID="Label296" runat="server" Text="<%$ Resources:lang,WanBanXiaBanJieShuShiJian%>"></asp:Label>
                                        <asp:TextBox ID="TB_NCheckOutEnd" runat="server" Width="50px"></asp:TextBox>
                                        &nbsp;<asp:Label ID="Label26" runat="server" Text="IsMust"></asp:Label>
                                        <asp:DropDownList ID="DDL_NCheckOutIsMust" runat="server">
                                            <asp:ListItem Value="NO"></asp:ListItem>
                                            <asp:ListItem Value="YES"></asp:ListItem>
                                        </asp:DropDownList>
                                    </td>
                                </tr>
                                <tr>
                                    <td class="ItemAlignLeft" colspan="8" class="ItemAlignLeft">
                                        <asp:Label ID="Label297" runat="server" Text="<%$ Resources:lang,JiaBanShangBanKaiShiShiJian%>"></asp:Label>
                                        <asp:TextBox ID="TB_OCheckInStart" runat="server" Width="50px"></asp:TextBox>
                                        &nbsp;<asp:Label ID="Label298" runat="server" Text="<%$ Resources:lang,JiaBanShangBanJieShuShiJian%>"></asp:Label>
                                        <asp:TextBox ID="TB_OCheckInEnd" runat="server" Width="50px"></asp:TextBox>
                                        &nbsp;<asp:Label ID="Label30" runat="server" Text="IsMust"></asp:Label>
                                        <asp:DropDownList ID="DDL_OCheckInIsMust" runat="server">
                                            <asp:ListItem Value="NO"></asp:ListItem>
                                            <asp:ListItem Value="YES"></asp:ListItem>
                                        </asp:DropDownList>
                                        &nbsp;<asp:Label ID="Label299" runat="server" Text="<%$ Resources:lang,JiaBanXiaBanKaiShiShiJian%>"></asp:Label>
                                        <asp:TextBox ID="TB_OCheckOutStart" runat="server" Width="50px"></asp:TextBox>
                                        &nbsp;<asp:Label ID="Label3" runat="server" Text="<%$ Resources:lang,JiaBanXiaBanJieShuShiJian%>"></asp:Label>
                                        <asp:TextBox ID="TB_OCheckOutEnd" runat="server" Width="50px"></asp:TextBox>
                                        &nbsp;<asp:Label ID="Label35" runat="server" Text="IsMust"></asp:Label>
                                        <asp:DropDownList ID="DDL_OCheckOutIsMust" runat="server">
                                            <asp:ListItem Value="NO"></asp:ListItem>
                                            <asp:ListItem Value="YES"></asp:ListItem>
                                        </asp:DropDownList>
                                    </td>
                                </tr>
                                <tr>
                                    <td class="ItemAlignLeft" colspan="8" class="ItemAlignLeft">
                                        <asp:Label ID="Label101" runat="server" Text="<%$ Resources:lang,Longitude%>"></asp:Label>
                                        <asp:TextBox ID="TB_Longitude" runat="server" Width="100px" Text="0"></asp:TextBox>
                                        <asp:Label ID="Label102" runat="server" Text="<%$ Resources:lang,Latitude%>"></asp:Label>
                                        <asp:TextBox ID="TB_Latitude" runat="server" Width="100px" Text="0"></asp:TextBox>
                                        <asp:Label ID="Label100" runat="server" Text="<%$ Resources:lang,DiZhi%>"></asp:Label>
                                        <asp:TextBox ID="TB_Address" runat="server" Width="300px"></asp:TextBox>
                                        <a class="titleSpan" onclick="popShowByURL('TTUserAttendanceRuleBaiDuMap.aspx','BaiDuMap', 600, 500)">
                                            <img src="ImagesSkin/GPS.jpg" alt="取经纬度" width="20" height="20" style="border: 0px;">
                                        </a>
                                        &nbsp;&nbsp;<asp:Label ID="Label2119" runat="server" Text="<%$ Resources:lang,YunXiZuiDaJuLi%>"></asp:Label>
                                        <NickLee:NumberBox ID="NB_LargestDistance" runat="server" MaxAmount="1000000000000" MinAmount="-1000000000000" Width="80px">0.00</NickLee:NumberBox>
                                        <asp:Label ID="Label492261" runat="server" Text="<%$ Resources:lang,Mi%>"></asp:Label>
                                    </td>
                                </tr>
                                <tr>
                                    <td colspan="5" class="ItemAlignLeft">
                                        <asp:Button ID="BT_AddAttendanceRule" runat="server" CssClass="inpu" OnClick="BT_AddAttendanceRule_Click" Text="<%$ Resources:lang,BaoCun%>" />
                                        &nbsp;
                                       
                                        <asp:Button ID="BT_DeleteAttendanceRule" runat="server" CssClass="inpu" OnClick="BT_DeleteAttendanceRule_Click" OnClientClick="return confirmContinue(getDeleteMsgByLangCode(), this, event)" Text="<%$ Resources:lang,ShanChu%>" />

                                        <button type="button" class="close-modal" onclick="hideModal('modalAttendanceRule')">
                                            <asp:Label ID="Label1" runat="server" Text="<%$ Resources:lang,GuanBi%>"></asp:Label>
                                        </button>
                                    </td>


                                    <td colspan="3">&nbsp; </td>
                                </tr>
                            </table>
                        </div>
                    </div>

                </ContentTemplate>
            </asp:UpdatePanel>
            <div style="position: absolute; left: 5%; top: 5%;">
                <asp:UpdateProgress ID="TakeTopUp" runat="server" AssociatedUpdatePanelID="UpdatePanel1">
                    <ProgressTemplate>
                        <img src="Images/Processing.gif" alt="Loading,please wait..." />
                    </ProgressTemplate>
                </asp:UpdateProgress>
            </div>
        </form>
    </center>
</body>
<script type="text/javascript" language="javascript">var cssDirectory = '<%=Session["CssDirectory"] %>'; var oLink = document.getElementById('mainCss'); oLink.href = 'css/' + cssDirectory + '/' + 'bluelightmain.css';</script>
</html>
