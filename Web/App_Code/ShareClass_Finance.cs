using LumiSoft.Net.Mail;
using LumiSoft.Net.MIME;
using LumiSoft.Net.POP3.Client;

using Microsoft.CSharp;

using MSXML2;

using net.sf.mpxj.primavera.schema;

using Npgsql;

using ProjectMgt.BLL;
using ProjectMgt.Model;

using RTXSAPILib;

using RTXServerApi;

using System;
using System.Activities.DurableInstancing;
using System.Activities.Statements;
using System.CodeDom;
using System.CodeDom.Compiler;
using System.Collections;
using System.Collections.Generic;
using System.Configuration;
using System.Data;
using System.Data.OleDb;
//using NPOI.SS.Formula.Functions;
//using Microsoft.Office.Interop.MSProject;
//using AjaxControlToolkit.HTMLEditor.ToolbarButton;
using System.Diagnostics;
using System.Drawing;
using System.IO;
using System.Linq;
using System.Net;
using System.Net.Mail;
using System.Text;
using System.Text.RegularExpressions;
using System.Threading;
using System.Web;
using System.Web.Caching;
using System.Web.Security;
using System.Web.Services.Description;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Xml;

using TakeTopCore;

using TakeTopGantt;

using TakeTopWF;

using ZXing;
using ZXing.QrCode;

/// <summary>
/// ShareClass partial - Finance
/// </summary>
public static partial class ShareClass
{
    
    #region 财务或物料操作函数

    //取得物料类型
    public static string GetItemType(string strItemCode)
    {
        string strHQL;

        strHQL = "Select Type From T_Item Where ItemCode = '" + strItemCode + "'";
        DataSet ds = ShareClass.GetDataSetFromSql(strHQL, "T_Item");

        if (ds.Tables[0].Rows.Count > 0)
        {
            return ds.Tables[0].Rows[0][0].ToString().Trim();
        }
        else
        {
            return "";
        }
    }

    public static decimal GetCurrencyTypeExchangeRate(string strCurrencyType)
    {
        decimal flag = 0;
        string strHQL = "Select ExchangeRate From T_CurrencyType where Type='" + strCurrencyType + "' ";
        DataTable dt = ShareClass.GetDataSetFromSql(strHQL, "T_CurrencyType").Tables[0];
        if (dt.Rows.Count > 0 && dt != null)
        {
            flag = decimal.Parse(dt.Rows[0]["ExchangeRate"].ToString());
        }
        else
        {
            flag = 0;
        }
        return flag;
    }

    //物料入库操作
    public static void addOrUpdateGoods(string strCountMethod, string strGoodsID, string strCIOID, string strGoodsCode, string strGoodsName, string strSN, decimal deNumber, string strUnitName,
       string strOwnerCode, string strType, string strSpec, string strModelNumber, string strPosition, string strWHPosition, decimal dePrice, string strIsTaxPrice, string strCurrencyType, DateTime dtBuyTime, int intWarrantyPeriod,
       string strManufacturer, string strMemo, string strCheckInDetailID, string strPhotoURL, decimal deOldCheckInNumber, decimal deOldCheckInPrice,
       string strBatchNumber, DateTime dtProductDate,
       DateTime dtExpiryDate, string strProductionEquipmentNumber, string strMaterialFormNumber)
    {
        string strHQL;

        GoodsBLL goodsBLL = new GoodsBLL();
        Goods goods = new Goods();

        if (strCountMethod == "FIFO")
        {
            strHQL = "Delete From T_Goods Where ID =" + strGoodsID;
            ShareClass.RunSqlCommand(strHQL);

            goods.GoodsCode = strGoodsCode;
            goods.GoodsName = strGoodsName;
            goods.SN = strSN;
            goods.Number = deNumber;
            goods.CheckInNumber = deNumber;
            goods.UnitName = strUnitName;
            goods.OwnerCode = strOwnerCode;
            try
            {
                goods.OwnerName = ShareClass.GetUserName(strOwnerCode);
            }
            catch
            {
                //ScriptManager.RegisterStartupScript(this.UpdatePanel1, this.GetType(), "click", "showAlertAtMouse('" + LanguageHandle.GetWord("ZZBGRDMCCCWCRJC").ToString().Trim() + "')", true);
                return;
            }
            goods.Type = strType;
            goods.Spec = strSpec;
            goods.ModelNumber = strModelNumber;
            goods.Position = strPosition;
            goods.WHPosition = strWHPosition;

            goods.Price = dePrice;
            goods.IsTaxPrice = strIsTaxPrice;
            goods.CurrencyType = strCurrencyType;
            goods.BuyTime = dtBuyTime;
            goods.Manufacturer = strManufacturer;
            goods.Memo = strMemo;
            goods.WarrantyPeriod = intWarrantyPeriod;
            goods.Status = "InUse";

            goods.PhotoURL = strPhotoURL;

            goods.BatchNumber = strBatchNumber;
            goods.ProductDate = dtProductDate;
            goods.ExpiryDate = dtExpiryDate;
            goods.ProductionEquipmentNumber = strProductionEquipmentNumber;
            goods.MaterialFormNumber = strMaterialFormNumber;

            try
            {
                goodsBLL.AddGoods(goods);

                strGoodsID = ShareClass.GetMyCreatedMaxGoodsID().ToString();

                //记录入库物料存入的ID号
                try
                {
                    strHQL = "Update T_GoodsCheckInOrderDetail Set ToGoodsID = " + strGoodsID;
                    strHQL += " Where ID = " + strCheckInDetailID;
                    ShareClass.RunSqlCommand(strHQL);
                }
                catch (Exception err)
                {
                    //Label27.Text = err.Message.ToString();
                }
            }
            catch (Exception err)
            {
                //Label27.Text = err.Message.ToString();

                return;
            }
        }

        if (strCountMethod == "MWAM")
        {
            if (strGoodsID != "0")
            {
                ShareClass.CountGoodsStockByMWAM(strGoodsID, deNumber, dePrice, deOldCheckInNumber, deOldCheckInPrice);
            }
            else
            {
                strGoodsID = ShareClass.CheckSameGoodsExistInStock(strGoodsCode, strType, strModelNumber, strSpec, strManufacturer, strPosition, strWHPosition);
                if (strGoodsID == "")
                {
                    goods.GoodsCode = strGoodsCode;
                    goods.GoodsName = strGoodsName;
                    goods.SN = strSN;
                    goods.Number = deNumber;
                    goods.CheckInNumber = deNumber;
                    goods.UnitName = strUnitName;
                    goods.OwnerCode = strOwnerCode;
                    try
                    {
                        goods.OwnerName = ShareClass.GetUserName(strOwnerCode);
                    }
                    catch
                    {
                        //ScriptManager.RegisterStartupScript(this.UpdatePanel1, this.GetType(), "click", "showAlertAtMouse('" + LanguageHandle.GetWord("ZZBGRDMCCCWCRJC").ToString().Trim() + "')", true);
                        return;
                    }
                    goods.Type = strType;
                    goods.Spec = strSpec;
                    goods.ModelNumber = strModelNumber;
                    goods.Position = strPosition;
                    goods.WHPosition = strWHPosition;

                    goods.Price = dePrice;
                    goods.IsTaxPrice = strIsTaxPrice;
                    goods.CurrencyType = strCurrencyType;
                    goods.BuyTime = dtBuyTime;
                    goods.Manufacturer = strManufacturer;
                    goods.Memo = strMemo;
                    goods.WarrantyPeriod = intWarrantyPeriod;
                    goods.Status = "InUse";

                    goods.PhotoURL = strPhotoURL;


                    goods.BatchNumber = strBatchNumber;
                    goods.ProductDate = dtProductDate;
                    goods.ExpiryDate = dtExpiryDate;
                    goods.ProductionEquipmentNumber = strProductionEquipmentNumber;
                    goods.MaterialFormNumber = strMaterialFormNumber;

                    try
                    {
                        goodsBLL.AddGoods(goods);

                        strGoodsID = ShareClass.GetMyCreatedMaxGoodsID().ToString();
                    }
                    catch (Exception err)
                    {
                        return;
                    }
                }
                else
                {
                    ShareClass.CountGoodsStockByMWAM(strGoodsID, deNumber, dePrice, deOldCheckInNumber, deOldCheckInPrice);
                }

                //记录入库物料存入的ID号
                try
                {
                    strHQL = "Update T_GoodsCheckInOrderDetail Set ToGoodsID = " + strGoodsID;
                    strHQL += " Where ID = " + strCheckInDetailID;
                    ShareClass.RunSqlCommand(strHQL);
                }
                catch (Exception err)
                {
                }
            }

            return;
        }

        return;
    }


    //判断是否存在相同的物料库存
    public static string CheckSameGoodsExistInStock(string strGoodsCode, string strType, string strModelNumber, string strSpecification, string strManufacture, string strWareHouse, string strWHPosition)
    {
        string strHQL;

        strHQL = "Select ID From T_Goods Where GoodsCode = '" + strGoodsCode + "' and Type = '" + strType + "' and Spec = '" + strSpecification + "' and ModelNumber = '" + strModelNumber + "' and manufacturer = '" + strManufacture + "' and Position = '" + strWareHouse + "' and WHPosition = '" + strWHPosition + "'";

        DataSet ds = ShareClass.GetDataSetFromSql(strHQL, "T_Goods");

        if (ds.Tables[0].Rows.Count > 0)
        {
            return ds.Tables[0].Rows[0][0].ToString().Trim();
        }
        else
        {
            return "";
        }
    }


    //依相关类型，更改相关业务表单的数量
    public static void UpdateGoodsRelatedBusinessNubmer(string strRelatedType, string strRelatedID, string strGoodsCode, string strSourceType, string strSourceID, DataGrid DataGrid1)
    {
        string strHQL;

        decimal deCheckinNumber;

        if (strSourceType == "GoodsPORecord")
        {
            strHQL = "Select COALESCE(Sum(Number),0) From T_GoodsCheckInOrderDetail Where SourceType= 'GoodsPORecord' and SourceID =" + strSourceID;
            DataSet ds = ShareClass.GetDataSetFromSql(strHQL, "T_GoodsPurRecord");

            if (ds.Tables[0].Rows.Count > 0)
            {
                deCheckinNumber = decimal.Parse(ds.Tables[0].Rows[0][0].ToString());
            }
            else
            {
                deCheckinNumber = 0;
            }

            strHQL = "Update T_GoodsPurRecord Set CheckInNumber = " + deCheckinNumber.ToString();
            strHQL += " Where ID = " + strSourceID;
            ShareClass.RunSqlCommand(strHQL);
        }

        if (strSourceType == "GoodsPDRecord")
        {
            strHQL = "Select COALESCE(Sum(Number),0) From T_GoodsCheckInOrderDetail Where SourceType= 'GoodsPDRecord' and SourceID =" + strSourceID;
            DataSet ds = ShareClass.GetDataSetFromSql(strHQL, "T_GoodsPurRecord");

            try
            {
                deCheckinNumber = decimal.Parse(ds.Tables[0].Rows[0][0].ToString());
            }
            catch
            {
                deCheckinNumber = 0;
            }

            strHQL = "Update T_GoodsProductionOrderDetail Set CheckInNumber = " + deCheckinNumber.ToString();
            strHQL += " Where ID = " + strSourceID;
            ShareClass.RunSqlCommand(strHQL);
        }


        if (strSourceType == "GoodsSURecord")
        {
            strHQL = "Select COALESCE(Sum(Number),0) From T_GoodsCheckInOrderDetail Where SourceType= 'GoodsSURecord' and SourceID =" + strSourceID;
            DataSet ds = ShareClass.GetDataSetFromSql(strHQL, "T_GoodsPurRecord");

            try
            {
                deCheckinNumber = decimal.Parse(ds.Tables[0].Rows[0][0].ToString());
            }
            catch
            {
                deCheckinNumber = 0;
            }

            strHQL = "Select SourceType,SourceID From T_GoodsSupplyOrderDetail Where ID = " + strSourceID;
            ds = ShareClass.GetDataSetFromSql(strHQL, "T_GoodsSupplyOrderDetail");

            strSourceType = ds.Tables[0].Rows[0][0].ToString().Trim();
            strSourceID = ds.Tables[0].Rows[0][1].ToString();

            if (strSourceType == "GoodsPORecord")
            {
                strHQL = "Update T_GoodsPurRecord Set CheckInNumber = " + deCheckinNumber.ToString();
                strHQL += " Where ID in (Select SourceID From T_GoodsSupplyOrderDetail Where SourceType = 'GoodsPORecord' and SourceID = " + strSourceID + ")";
                ShareClass.RunSqlCommand(strHQL);
            }
        }

        if (strSourceType == "GoodsCSRecord")
        {
            strHQL = "Select COALESCE(Sum(Number),0) From T_GoodsCheckInOrderDetail Where SourceType= 'GoodsCSRecord' and SourceID =" + strSourceID;
            DataSet ds = ShareClass.GetDataSetFromSql(strHQL, "T_GoodsPurRecord");

            try
            {
                deCheckinNumber = decimal.Parse(ds.Tables[0].Rows[0][0].ToString());
            }
            catch
            {
                deCheckinNumber = 0;
            }

            strHQL = "Update T_ConstractRelatedGoods Set PurchaseOrderNumber = " + deCheckinNumber.ToString();
            strHQL += " Where ID = " + strSourceID;
            ShareClass.RunSqlCommand(strHQL);
        }

        //更改项目关联物资下单量
        if (strSourceType == "GoodsPJRecord")
        {
            UpdatProjectRelatedItemNumber(strSourceType, strSourceID);
        }

        //依单据主体关联类型更新项目物资预算的物料代码的预算使用量
        if (strRelatedType == "Project")
        {
            UpdateProjectRelatedItemNumberByBudgetBusinessType("CHECKIN", strRelatedType, strRelatedID, strGoodsCode);
            RefreshProjectRelatedItemNumber(strRelatedID, DataGrid1);
        }
    }


    //依单据主体关联类型更新项目物资预算的物料代码的预算使用量
    public static void UpdateProjectRelatedItemNumberByBudgetBusinessType(string strBusinessType, string strRelatedType, string strRelatedID, string strGoodsCode)
    {
        string strHQL;
        decimal deSumNumber;

        if (strBusinessType == "PURCHASE")
        {
            strHQL = "Select COALESCE(Sum(Number),0) From T_GoodsPurRecord Where POID in (Select POID From T_GoodsPurchaseOrder Where RelatedType = '" + strRelatedType + "' And RelatedID=" + strRelatedID + ")";
            strHQL += " and GoodsCode = '" + strGoodsCode + "'";
            DataSet ds = ShareClass.GetDataSetFromSql(strHQL, "T_GoodsCheckInOrderDetail");
            try
            {
                deSumNumber = decimal.Parse(ds.Tables[0].Rows[0][0].ToString());
            }
            catch
            {
                deSumNumber = 0;
            }

            strHQL = "Update T_ProjectRelatedItem Set AleadyPurchased = " + deSumNumber.ToString() + " Where ProjectID = " + strRelatedID + " and ItemCode = '" + strGoodsCode + "'";
            ShareClass.RunSqlCommand(strHQL);
        }

        if (strBusinessType == "CHECKIN")
        {
            strHQL = "Select COALESCE(Sum(Number),0) From T_GoodsCheckInOrderDetail Where CheckInID in (Select CheckInID From T_GoodsCheckInOrder Where RelatedType = '" + strRelatedType + "' And RelatedID=" + strRelatedID + ")";
            strHQL += " and GoodsCode = '" + strGoodsCode + "'";
            DataSet ds = ShareClass.GetDataSetFromSql(strHQL, "T_GoodsCheckInOrderDetail");
            try
            {
                deSumNumber = decimal.Parse(ds.Tables[0].Rows[0][0].ToString());
            }
            catch
            {
                deSumNumber = 0;
            }

            strHQL = "Update T_ProjectRelatedItem Set AleadyCheckIn = " + deSumNumber.ToString() + " Where ProjectID = " + strRelatedID + " and ItemCode = '" + strGoodsCode + "'";
            ShareClass.RunSqlCommand(strHQL);
        }

        if (strBusinessType == "PICK")
        {
            strHQL = "Select COALESCE(Sum(Number),0) From T_GoodsApplicationDetail Where AAID in (Select AAID From T_GoodsApplication Where RelatedType = '" + strRelatedType + "' And RelatedID=" + strRelatedID + ")";
            strHQL += " and GoodsCode = '" + strGoodsCode + "'";
            DataSet ds = ShareClass.GetDataSetFromSql(strHQL, "T_GoodsApplicationDetail");
            try
            {
                deSumNumber = decimal.Parse(ds.Tables[0].Rows[0][0].ToString());
            }
            catch
            {
                deSumNumber = 0;
            }

            strHQL = "Update T_ProjectRelatedItem Set AleadyPick = " + deSumNumber.ToString() + " Where ProjectID = " + strRelatedID + " and ItemCode = '" + strGoodsCode + "'";
            ShareClass.RunSqlCommand(strHQL);
        }

        if (strBusinessType == "CHECKOUT")
        {
            strHQL = "Select COALESCE(Sum(Number),0) From T_GoodsShipmentDetail Where ShipmentNO in (Select ShipmentNO From T_GoodsShipmentOrder Where RelatedType = '" + strRelatedType + "' And RelatedID=" + strRelatedID + ")";
            strHQL += " and GoodsCode = '" + strGoodsCode + "'";
            DataSet ds = ShareClass.GetDataSetFromSql(strHQL, "T_GoodsCheckInOrderDetail");
            try
            {
                deSumNumber = decimal.Parse(ds.Tables[0].Rows[0][0].ToString());
            }
            catch
            {
                deSumNumber = 0;
            }

            strHQL = "Update T_ProjectRelatedItem Set AleadyCheckOut = " + deSumNumber.ToString() + " Where ProjectID = " + strRelatedID + " and ItemCode = '" + strGoodsCode + "'";
            ShareClass.RunSqlCommand(strHQL);
        }

        if (strBusinessType == "PRODUCTION")
        {
            strHQL = "Select COALESCE(Sum(Number),0) From T_GoodsProductionOrderDetail Where PDID in (Select PDID From T_GoodsProductionOrder Where RelatedType = '" + strRelatedType + "' And RelatedID=" + strRelatedID + ")";
            strHQL += " and GoodsCode = '" + strGoodsCode + "'";
            DataSet ds = ShareClass.GetDataSetFromSql(strHQL, "T_GoodsCheckInOrderDetail");
            try
            {
                deSumNumber = decimal.Parse(ds.Tables[0].Rows[0][0].ToString());
            }
            catch
            {
                deSumNumber = 0;
            }

            strHQL = "Update T_ProjectRelatedItem Set AleadyProduction = " + deSumNumber.ToString() + " Where ProjectID = " + strRelatedID + " and ItemCode = '" + strGoodsCode + "'";
            ShareClass.RunSqlCommand(strHQL);
        }
    }

    public static void UpdatProjectRelatedItemNumber(string strSourceType, string strSourceID)
    {
        string strHQL;
        decimal deSumNumber;

        if (strSourceType == "GoodsPJRecord")
        {
            strHQL = "Select COALESCE(Sum(Number),0) From T_GoodsCheckInOrderDetail Where SourceType = 'GoodsPJRecord' And SourceID=" + strSourceID;
            DataSet ds = ShareClass.GetDataSetFromSql(strHQL, "T_GoodsPurRecord");

            try
            {
                deSumNumber = decimal.Parse(ds.Tables[0].Rows[0][0].ToString());
            }
            catch
            {
                deSumNumber = 0;
            }

            strHQL = "Update T_ProjectRelatedItem Set AleadyCheckIn = " + deSumNumber.ToString() + " Where ID = " + strSourceID;
            ShareClass.RunSqlCommand(strHQL);
        }
    }

    //判断需求量是否大于预算量，适用于项目物资预算
    public static bool checkRequireNumberIsMoreHaveNumberForProjectRelatedItemNumber(string strProjectRelatedItemID, string strAleadyNumberColumnName, decimal deNumber)
    {
        string strHQL;
        decimal deRequireNumber, deFinishedNumber;

        strHQL = "Select Number, " + strAleadyNumberColumnName + " From T_ProjectRelatedItem Where ID = " + strProjectRelatedItemID;
        DataSet ds = ShareClass.GetDataSetFromSql(strHQL, "T_ProjectRelatedItem");
        if (ds.Tables[0].Rows.Count > 0)
        {
            deRequireNumber = decimal.Parse(ds.Tables[0].Rows[0]["Number"].ToString());
            deFinishedNumber = decimal.Parse(ds.Tables[0].Rows[0][strAleadyNumberColumnName].ToString());
        }
        else
        {
            deRequireNumber = 0;
            deFinishedNumber = 0;
        }

        if (deNumber > (deRequireNumber - deFinishedNumber))
        {
            return false;
        }
        else
        {
            return true;
        }
    }

    public static void RefreshProjectRelatedItemNumber(string strProjectID, DataGrid DataGrid1)
    {
        string strHQL;
        IList lst;

        strHQL = "From ProjectRelatedItem as projectRelatedItem where projectRelatedItem.ProjectID = " + strProjectID + " Order by projectRelatedItem.ID ASC";
        ProjectRelatedItemBLL projectRelatedItemBLL = new ProjectRelatedItemBLL();
        lst = projectRelatedItemBLL.GetAllProjectRelatedItems(strHQL);

        DataGrid1.DataSource = lst;
        DataGrid1.DataBind();
    }

    //加权平均法计算库存
    public static void CountGoodsStockByMWAM(string strGoodsID, decimal deCheckInNumber, decimal deCheckInPrice, decimal deOldCheckInNumber, decimal deOldCheckInPrice)
    {
        string strHQL;

        if (deOldCheckInNumber == 0)
        {
            strHQL = "Update T_Goods Set Number = " + "Number + " + deCheckInNumber.ToString() + ",Price = " + " (Number * Price + " + (deCheckInNumber * deCheckInPrice).ToString() + ")/(" + "Number + " + deCheckInNumber.ToString() + ") From T_Goods";
            strHQL += " Where ID =" + strGoodsID;
        }
        else if (deOldCheckInNumber > 0)
        {
            strHQL = "Update T_Goods Set Number = " + "Number - " + deOldCheckInNumber.ToString() + "+ " + deCheckInNumber.ToString() + ",Price = " + " (Number * Price - " + (deOldCheckInNumber * deOldCheckInPrice).ToString() + "+" + (deCheckInNumber * deCheckInPrice).ToString() + ")/(" + "Number - " + deOldCheckInNumber + "+ " + deCheckInNumber.ToString() + ") From T_Goods";
            strHQL += " Where ID =" + strGoodsID;
        }
        else
        {
            strHQL = "";
        }

        try
        {
            //Label27.Text = strHQL;

            ShareClass.RunSqlCommand(strHQL);
        }
        catch
        {
        }
    }

    //取得物料库存出入算法
    public static string GetGoodsStockCountMethod(string strWHName)
    {
        string strHQL;

        strHQL = "Select CapitalMethod From T_WareHouse Where WHName = '" + strWHName + "'";
        DataSet ds = ShareClass.GetDataSetFromSql(strHQL, "T_WareHouse ");

        if (ds.Tables[0].Rows.Count > 0)
        {
            return ds.Tables[0].Rows[0][0].ToString().Trim();
        }
        else
        {
            return "FIFO";
        }
    }

    public static void UpdateGoodsNumberForAdd(string strFromGoodsID, decimal deNumber)
    {
        string strHQL;

        strHQL = "Update T_Goods Set Number = Number - " + deNumber.ToString() + " Where ID = " + strFromGoodsID;
        ShareClass.RunSqlCommand(strHQL);
    }

    public static void UpdateGoodsNumberForUpdate(string strFromGoodsID, decimal deNumber, decimal deOldNumber)
    {
        string strHQL;

        strHQL = "Update T_Goods Set Number = Number - " + (deNumber - deOldNumber).ToString() + " Where ID = " + strFromGoodsID;
        ShareClass.RunSqlCommand(strHQL);
    }

    public static void UpdateGoodsNumberForDelete(string strFromGoodsID, decimal deNumber)
    {
        string strHQL;

        strHQL = "Update T_Goods Set Number = Number + " + deNumber.ToString() + " Where ID = " + strFromGoodsID;
        ShareClass.RunSqlCommand(strHQL);
    }

    /// <summary>
    /// Liujp 2013-07-17 更新物料登记入库表时，更新物料表中仓库字段
    /// </summary>
    /// <param name="goodsCheckInOrderId"></param>
    /// <param name="strPosition"></param>
    public static void UpdateGoodsPositionByGoodsCheckInOrder(string strGoodsCheckInOrderId, string strPosition)
    {
        string strHQL;

        strHQL = "Update T_Goods Set Position = '" + strPosition + "' Where ID in (Select ToGoodsID From T_GoodsCheckInOrderDetail Where CheckInID = " + strGoodsCheckInOrderId + ")";

        ShareClass.RunSqlCommand(strHQL);
    }

    //获取本币名称
    public static string GetHomeCurrencyType()
    {
        string strHQL;

        strHQL = "Select Type From T_CurrencyType Where IsHome = 'YES'";
        DataSet ds = ShareClass.GetDataSetFromSql(strHQL, "T_CurrencyType");

        if (ds.Tables[0].Rows.Count > 0)
        {
            return ds.Tables[0].Rows[0][0].ToString();
        }
        else
        {
            return LanguageHandle.GetWord("RenMinBi").ToString().Trim();
        }
    }

    /// <summary>
    /// 判断是否已设置标准金额
    /// </summary>
    /// <param name="strID"></param>
    /// <param name="strDepartCode"></param>
    /// <param name="strAccountName"></param>
    /// <param name="strYearNum"></param>
    /// <param name="strMonthNum"></param>
    /// <returns></returns>
    public static bool IsBMBaseDataExits(string strID, string strDepartCode, string strAccountName, int strYearNum, int strMonthNum, string strusercode)
    {
        bool flag = true;
        string strHQL;
        if (string.IsNullOrEmpty(strID))
        {
            strHQL = "From BDBaseData as bDBaseData where bDBaseData.DepartCode = '" + strDepartCode + "' and bDBaseData.AccountName='" + strAccountName + "' and " +
                "bDBaseData.YearNum='" + strYearNum.ToString() + "' and bDBaseData.MonthNum = '" + strMonthNum.ToString() + "' and bDBaseData.EnterCode='" + strusercode + "' and bDBaseData.Type='Base' ";
        }
        else
        {
            strHQL = "From BDBaseData as bDBaseData where bDBaseData.DepartCode = '" + strDepartCode + "' and bDBaseData.AccountName='" + strAccountName + "' and " +
                "bDBaseData.YearNum='" + strYearNum.ToString() + "' and bDBaseData.MonthNum = '" + strMonthNum.ToString() + "' and bDBaseData.EnterCode='" + strusercode + "' and bDBaseData.Type='Base' and bDBaseData.ID<>'" + strID + "' ";
        }
        BDBaseDataBLL bdBaseDataRecordBLL = new BDBaseDataBLL();
        IList lst = bdBaseDataRecordBLL.GetAllBDBaseDatas(strHQL);
        if (lst.Count > 0 && lst != null)
            flag = true;
        else
            flag = false;

        return flag;
    }

    /// <summary>
    /// 取得预算余额
    /// </summary>
    /// <param name="strID"></param>
    /// <param name="strDepartCode"></param>
    /// <param name="strAccountName"></param>
    /// <param name="strYearNum"></param>
    /// <param name="strMonthNum"></param>
    /// <returns></returns>
    public static decimal GetBMBaseDataMoneyNum(string strDepartCode, string strAccountName, int strYearNum, int strMonthNum, string strType)
    {
        decimal deBalance = 0;
        decimal deMoneyBase = 0;
        decimal deMoneyUsed = 0;
        string strHQL = "From BDBaseData as bDBaseData where bDBaseData.DepartCode = '" + strDepartCode + "' and bDBaseData.AccountName='" + strAccountName + "' and " +
                "bDBaseData.YearNum='" + strYearNum.ToString() + "' and bDBaseData.MonthNum = '" + strMonthNum.ToString() + "' and bDBaseData.Type='" + strType + "' ";
        BDBaseDataBLL bdBaseDataBLL = new BDBaseDataBLL();
        IList lst = bdBaseDataBLL.GetAllBDBaseDatas(strHQL);
        if (lst.Count > 0 && lst != null)
        {
            for (int i = 0; i < lst.Count; i++)
            {
                BDBaseData bdBaseData = (BDBaseData)lst[i];
                deMoneyBase += bdBaseData.MoneyNum;
            }
        }

        BDBaseDataRecordBLL bdBaseDataRecordBLL = new BDBaseDataRecordBLL();
        strHQL = "From BDBaseDataRecord as bdBaseDataRecord where bdBaseDataRecord.DepartCode = '" + strDepartCode + "' and bdBaseDataRecord.AccountName='" + strAccountName + "' and " +
                "bdBaseDataRecord.YearNum='" + strYearNum.ToString() + "' and bdBaseDataRecord.MonthNum = '" + strMonthNum.ToString() + "' and bdBaseDataRecord.Type='Operation' ";
        lst = bdBaseDataRecordBLL.GetAllBDBaseDataRecords(strHQL);
        if (lst.Count > 0 && lst != null)
        {
            for (int j = 0; j < lst.Count; j++)
            {
                BDBaseDataRecord bdBaseDataRecord = (BDBaseDataRecord)lst[j];
                deMoneyUsed += bdBaseDataRecord.MoneyNum;
            }
        }

        deBalance = deMoneyBase - deMoneyUsed;

        return deBalance;
    }

    //取得部门预算记录ID
    public static int GetBMBaseDataID(string strDepartCode, string strAccountCode, string strAccountName, int strYearNum, int strMonthNum, string strType)
    {
        string strHQL = "From BDBaseData as bDBaseData where bDBaseData.DepartCode = '" + strDepartCode + "' and bDBaseData.AccountCode = '" + strAccountCode + "' and bDBaseData.AccountName='" + strAccountName + "' and " +
                "bDBaseData.YearNum='" + strYearNum.ToString() + "' and bDBaseData.MonthNum = '" + strMonthNum.ToString() + "' and bDBaseData.Type='" + strType + "' ";
        BDBaseDataBLL bdBaseDataBLL = new BDBaseDataBLL();
        IList lst = bdBaseDataBLL.GetAllBDBaseDatas(strHQL);
        if (lst.Count > 0 && lst != null)
        {
            BDBaseData bdBaseData = (BDBaseData)lst[0];

            return bdBaseData.ID;
        }
        else
        {
            return 0;
        }
    }

    //把报销费用列入预算费用
    public static void AddClaimExpenseToBudget(string strAccountCode, string strAccountName, int intBDBaseDataID, string strUserCode, decimal deAmount, int intYear, int intMonth)
    {
        string strDepartCode, strDepartName;
        int intBMBaseDataID = 0;

        strDepartCode = ShareClass.GetDepartCodeFromUserCode(strUserCode);
        strDepartName = ShareClass.GetDepartName(strDepartCode);

        intBMBaseDataID = ShareClass.GetBMBaseDataID(strDepartCode, strAccountCode, strAccountName, intYear, intMonth, "Base");
        if (intBMBaseDataID <= 0)
        {
            return;
        }

        BDBaseDataRecordBLL bdBaseDataRecordBLL = new BDBaseDataRecordBLL();
        BDBaseDataRecord bdBaseDataRecord = new BDBaseDataRecord();

        bdBaseDataRecord.AccountCode = strAccountCode;
        bdBaseDataRecord.AccountName = strAccountName;
        bdBaseDataRecord.BDBaseDataID = intBDBaseDataID;
        bdBaseDataRecord.DepartCode = strDepartCode;
        bdBaseDataRecord.DepartName = strDepartName;
        bdBaseDataRecord.EnterCode = strUserCode.Trim();
        bdBaseDataRecord.MoneyNum = deAmount;
        bdBaseDataRecord.YearNum = intYear;
        bdBaseDataRecord.MonthNum = intMonth;
        bdBaseDataRecord.Type = "Operation";

        try
        {
            bdBaseDataRecordBLL.AddBDBaseDataRecord(bdBaseDataRecord);
        }
        catch
        {
        }
    }

    //按类型取代码规则的状态
    public static string GetCodeRuleStatusByType(string strCodeType)
    {
        string strHQL;

        strHQL = "Select IsStartup From T_CodeRule  Where CodeType = " + "'" + strCodeType + "'";
        DataSet ds = ShareClass.GetDataSetFromSql(strHQL, "T_CodeRule");
        if (ds.Tables[0].Rows.Count > 0)
        {
            return ds.Tables[0].Rows[0][0].ToString().Trim();
        }
        else
        {
            return "NO";
        }
    }

    //按代码规则取得相关代码
    public static string GetCodeByRule(string strCodeType, string strObjectType, string strID)
    {
        string strHQL;

        string strHeadchar, strFieldName, strIsStartup, strKeyWord;
        int intFlowIDWidth, intLength;
        string strFlowID, strFlowCode, strCode;

        strFlowID = "";
        strKeyWord = "";

        DataSet ds;

        if (strCodeType == "ProjectCode")
        {
            strHQL = "Select KeyWord From T_ProjectType Where Type = " + "'" + strObjectType + "'";
            ds = ShareClass.GetDataSetFromSql(strHQL, "T_ProjectType");
            if (ds.Tables[0].Rows.Count > 0)
            {
                strKeyWord = ds.Tables[0].Rows[0][0].ToString().Trim();
            }
            else
            {
                strKeyWord = "";
            }
        }

        if (strCodeType == "ConstractCode")
        {
            strHQL = "Select KeyWord From T_ConstractType Where Type = " + "'" + strObjectType + "'";
            ds = ShareClass.GetDataSetFromSql(strHQL, "T_ConstractType");

            if (ds.Tables[0].Rows.Count > 0)
            {
                strKeyWord = ds.Tables[0].Rows[0][0].ToString().Trim();
            }
            else
            {
                strKeyWord = "";
            }
        }

        strHQL = "Select HeadChar,FieldName,FlowIDWidth,IsStartup From T_CodeRule  Where CodeType = " + "'" + strCodeType + "'";
        strHQL += " And IsStartup = 'YES'";
        ds = ShareClass.GetDataSetFromSql(strHQL, "T_CodeRule");

        if (ds.Tables[0].Rows.Count > 0)
        {
            strHeadchar = ds.Tables[0].Rows[0][0].ToString().Trim();
            strFieldName = ds.Tables[0].Rows[0][1].ToString().Trim();

            intFlowIDWidth = int.Parse(ds.Tables[0].Rows[0][2].ToString().Trim());
            strIsStartup = ds.Tables[0].Rows[0][3].ToString().Trim();

            intLength = intFlowIDWidth - strID.Length;
            if (intLength > 0)
            {
                for (int i = 1; i <= intLength; i++)
                {
                    strFlowID += "0";
                }

                strFlowCode = strFlowID + strID;
            }
            else
            {
                strFlowCode = strID;
            }

            if (strFieldName == "[TAKETOPYEARMONTHDAY]")
            {
                strCode = strHeadchar + strKeyWord + DateTime.Now.ToString("yyyyMMdd") + strFlowCode;
            }
            else
            {
                if (strFieldName == "[TAKETOPYEARMONTH]")
                {
                    strCode = strHeadchar + strKeyWord + DateTime.Now.ToString("yyyyMM") + strFlowCode;
                }
                else
                {
                    strCode = strHeadchar + strKeyWord + strFlowID;
                }
            }

            return strCode;
        }
        else
        {
            return "";
        }
    }

    //生成仓库树（根据权限和部门资产管理员）
    public static void InitialWarehouseTreeByAuthorityAsset(TreeView TreeView, String strUserCode, string strDepartString)
    {
        string strHQL, strWareHouse;
        IList lst;

        //添加根节点
        TreeView.Nodes.Clear();

        TreeNode node1 = new TreeNode();
        TreeNode node3 = new TreeNode();

        node1.Text = "<B>" + LanguageHandle.GetWord("CangKu") + "</B>";
        node1.Target = "1";
        node1.Expanded = true;
        TreeView.Nodes.Add(node1);

        // 部门过滤：strDepartString 为空时显示所有仓库
        if (!string.IsNullOrEmpty(strDepartString) && strDepartString != "()" && strDepartString != "('')")
        {
            strHQL = "from WareHouse as wareHouse where wareHouse.BelongDepartCode in " + strDepartString;
        }
        else
        {
            strHQL = "from WareHouse as wareHouse where 1=1";
        }
        strHQL += " and (wareHouse.ParentWH = '1' Or COALESCE(wareHouse.ParentWH,'') = '')";
        strHQL += " order by wareHouse.SortNumber ASC";
        WareHouseBLL WareHouseBLL = new WareHouseBLL();
        WareHouse WareHouse = new WareHouse();

        lst = WareHouseBLL.GetAllWareHouses(strHQL);

        for (int i = 0; i < lst.Count; i++)
        {
            WareHouse = (WareHouse)lst[i];

            strWareHouse = WareHouse.WHName.Trim();

            node3 = new TreeNode();

            node3.Text = strWareHouse;
            node3.Target = strWareHouse;
            node3.Expanded = true;

            node1.ChildNodes.Add(node3);
            WareHouseTreeShowByAuthority(strWareHouse, node3);
            TreeView.DataBind();
        }
    }

    public static void WareHouseTreeShowByAuthority(string strParentWH, TreeNode treeNode)
    {
        string strHQL, strWareHouse;
        IList lst1, lst2;

        WareHouseBLL WareHouseBLL = new WareHouseBLL();
        WareHouse WareHouse = new WareHouse();

        strHQL = "from WareHouse as wareHouse where wareHouse.ParentWH = '" + strParentWH + "'";
        strHQL += " order by wareHouse.SortNumber ASC";
        lst1 = WareHouseBLL.GetAllWareHouses(strHQL);

        for (int i = 0; i < lst1.Count; i++)
        {
            WareHouse = (WareHouse)lst1[i];

            strWareHouse = WareHouse.WHName.Trim();

            TreeNode node = new TreeNode();

            node.Target = strWareHouse;
            node.Text = strWareHouse;
            treeNode.ChildNodes.Add(node);
            node.Expanded = true;

            strHQL = "from WareHouse as wareHouse where wareHouse.ParentWH = '" + strWareHouse + "'";
            strHQL += " Order by wareHouse.SortNumber ASC";
            lst2 = WareHouseBLL.GetAllWareHouses(strHQL);

            if (lst2.Count > 0)
            {
                WareHouseTreeShowByAuthority(strWareHouse, node);
            }
        }
    }

    //取得权限内仓库列表
    public static void LoadWareHouseListByAuthorityForDropDownList(string strUserCode, DropDownList DL_WareHouse)
    {
        string strHQL;
        string strDepartCode, strDepartString;

        strDepartCode = GetDepartCodeFromUserCode(strUserCode);
        strDepartString = CoreShareClass.InitialDepartmentStringByAuthorityAsset(strUserCode);

        strHQL = " Select WHName From T_WareHouse Where ";
        strHQL += " BelongDepartCode in " + strDepartString;
        strHQL += " Order By SortNumber DESC";

        DataSet ds = ShareClass.GetDataSetFromSql(strHQL, "T_WareHouse");

        DL_WareHouse.DataSource = ds;
        DL_WareHouse.DataBind();

        DL_WareHouse.Items.Insert(0, new ListItem("--Select--", ""));
    }

    //取得仓库仓位列表
    public static void LoadWareHousePositions(string strWHName, DropDownList DL_WHPosition)
    {
        string strHQL;

        strHQL = "Select * From T_WareHousePositions Where WHName = " + "'" + strWHName + "'";
        DataSet ds = ShareClass.GetDataSetFromSql(strHQL, "T_WareHousePositions");

        DL_WHPosition.DataSource = ds;
        DL_WHPosition.DataBind();

        DL_WHPosition.Items.Insert(0, new ListItem("--Select--", ""));
    }

    public static string GetAccountName(string strAccountCode)
    {
        string flag = "";
        string strHQL = "Select AccountName From T_Account where AccountCode='" + strAccountCode + "' ";
        DataTable dt = ShareClass.GetDataSetFromSql(strHQL, "T_Account").Tables[0];
        if (dt.Rows.Count > 0 && dt != null)
        {
            flag = dt.Rows[0]["AccountName"].ToString();
        }
        else
        {
            flag = "";
        }
        return flag;
    }

    public static string GetAccountCode(string strAccountName)
    {
        string flag = "";
        string strHQL = "Select AccountCode From T_Account where AccountName='" + strAccountName + "' ";
        DataTable dt = ShareClass.GetDataSetFromSql(strHQL, "T_Account").Tables[0];
        if (dt.Rows.Count > 0 && dt != null)
        {
            flag = dt.Rows[0]["AccountCode"].ToString();
        }
        else
        {
            flag = "";
        }
        return flag;
    }

    //取得费用类科目列表
    public static void LoadCostAccountForDDL(DropDownList DL_Account)
    {
        DataTable dt = GetCostAccountList(string.Empty);
        if (dt != null && dt.Rows.Count > 0)
        {
            DL_Account.Items.Clear();
            DL_Account.Items.Insert(0, new ListItem("--Select--", ""));
            SetIntervalCost(DL_Account, "0", " ");
        }
        else
        {
            DL_Account.Items.Clear();
            DL_Account.Items.Insert(0, new ListItem("--Select--", ""));
        }
    }

    //取得费用类科目列表
    public static DataTable GetCostAccountList(string strParentID)
    {
        string strHQL = "Select * From T_Account Where accounttype = 'Cost'  ";
        if (!string.IsNullOrEmpty(strParentID))
        {
            strHQL += " and ParentID=" + strParentID.Trim() + " ";
        }
        strHQL += " Order By SortNumber ";
        DataSet ds = ShareClass.GetDataSetFromSql(strHQL, "T_Account");
        return ds.Tables[0];
    }

    public static void SetIntervalCost(DropDownList DDL, string strParentID, string interval)
    {
        interval += "|-";

        DataTable list = GetCostAccountList(strParentID);
        if (list.Rows.Count > 0 && list != null)
        {
            for (int i = 0; i < list.Rows.Count; i++)
            {
                DDL.Items.Add(new ListItem(string.Format("{0}{1}", interval, list.Rows[i]["AccountType"].ToString().Trim() + "-" + list.Rows[i]["AccountName"].ToString().Trim()), list.Rows[i]["AccountCode"].ToString().Trim()));

                ///递归
                SetInterval(DDL, list.Rows[i]["ID"].ToString().Trim(), interval);
            }
        }
    }



    //取得所有类科目列表
    public static void LoadAccountForDDL(DropDownList DL_Account)
    {
        DataTable dt = GetAccountList(string.Empty);
        if (dt != null && dt.Rows.Count > 0)
        {
            DL_Account.Items.Clear();
            DL_Account.Items.Insert(0, new ListItem("--Select--", ""));
            SetInterval(DL_Account, "0", " ");
        }
        else
        {
            DL_Account.Items.Clear();
            DL_Account.Items.Insert(0, new ListItem("--Select--", ""));
        }
    }

    public static DataTable GetAccountList(string strParentID)
    {
        string strHQL = "Select * From T_Account ";
        if (!string.IsNullOrEmpty(strParentID))
        {
            strHQL += " Where ParentID=" + strParentID.Trim() + " ";
        }
        strHQL += " Order By SortNumber ";
        DataSet ds = ShareClass.GetDataSetFromSql(strHQL, "T_Account");
        return ds.Tables[0];
    }

    public static void SetInterval(DropDownList DDL, string strParentID, string interval)
    {
        interval += "|-";

        DataTable list = GetAccountList(strParentID);
        if (list.Rows.Count > 0 && list != null)
        {
            for (int i = 0; i < list.Rows.Count; i++)
            {
                DDL.Items.Add(new ListItem(string.Format("{0}{1}", interval, list.Rows[i]["AccountType"].ToString().Trim() + "-" + list.Rows[i]["AccountName"].ToString().Trim()), list.Rows[i]["AccountCode"].ToString().Trim()));

                ///递归
                SetInterval(DDL, list.Rows[i]["ID"].ToString().Trim(), interval);
            }
        }
    }

    public static void LoadCurrencyType(DropDownList DL_CurrencyType)
    {
        string strHQL;
        IList lst;

        strHQL = "From CurrencyType as currencyType Order By currencyType.SortNo ASC";
        CurrencyTypeBLL currencyTypeBLL = new CurrencyTypeBLL();
        lst = currencyTypeBLL.GetAllCurrencyTypes(strHQL);

        DL_CurrencyType.DataSource = lst;
        DL_CurrencyType.DataBind();
    }

    public static string GetCustomerNameFromGoodsSaleOrder(string strSOID)
    {
        string strHQL;
        string strCustomerName;
        strHQL = "Select CustomerName From T_GoodsSaleOrder Where SOID = " + strSOID;
        DataSet ds = ShareClass.GetDataSetFromSql(strHQL, "T_GoodsSaleOrder");
        if (ds.Tables[0].Rows.Count > 0)
        {
            strCustomerName = ds.Tables[0].Rows[0][0].ToString();
        }
        else
        {
            strCustomerName = "";
        }

        return strCustomerName;
    }

    public static string GetCustomerNameFromCustomerCode(string strCustomerCode)
    {
        string strHQL;
        string strCustomerName;
        strHQL = "Select CustomerName From T_Customer Where CustomerCode = " + "'" + strCustomerCode + "'";
        DataSet ds = ShareClass.GetDataSetFromSql(strHQL, "T_Customer");
        if (ds.Tables[0].Rows.Count > 0)
        {
            strCustomerName = ds.Tables[0].Rows[0][0].ToString();
        }
        else
        {
            strCustomerName = "";
        }

        return strCustomerName;
    }

    public static string GetApplicantNameFromGoodsApplicaitonOrder(string strAOID)
    {
        string strHQL;
        string strApplicantName;
        strHQL = "Select ApplicantName From T_GoodsApplication Where AAID = " + strAOID;
        DataSet ds = ShareClass.GetDataSetFromSql(strHQL, "T_GoodsApplication");
        if (ds.Tables[0].Rows.Count > 0)
        {
            strApplicantName = ds.Tables[0].Rows[0][0].ToString();
        }
        else
        {
            strApplicantName = "";
        }

        return strApplicantName;
    }

    public static bool IsBusinessFormRelatedConstract(string strRelatedType, string strRelatedID)
    {
        string strHQL;
        DataSet ds = new DataSet();

        if (strRelatedType == "GoodsSO")
        {
            strHQL = "Select ConstractCode From T_ConstractRelatedGoodsSaleOrder Where SOID =" + strRelatedID;
            ds = GetDataSetFromSql(strHQL, "T_ConstractRelated");
        }

        if (strRelatedType == "GoodsPO")
        {
            strHQL = "Select ConstractCode From T_ConstractRelatedGoodsPurchaseOrder Where POID = " + strRelatedID;
            ds = GetDataSetFromSql(strHQL, "T_ConstractRelated");
        }

        if (strRelatedType == "AssetPO")
        {
            strHQL = "Select ConstractCode From T_ConstractRelatedAssetPurchaseOrder Where  Where POID = " + strRelatedID;
            ds = GetDataSetFromSql(strHQL, "T_ConstractRelated");
        }

        try
        {
            if (ds.Tables[0].Rows.Count > 0)
            {
                return true;
            }
            else
            {
                return false;
            }
        }
        catch
        {
            return false;
        }
    }

    public static int InsertReceivablesOrPayable(string strFormCode, string strRelatedType, string strRelatedID, string strRelatedRecordID, Decimal deAmount, string strCurrencyType, string strReOrPayer, string strOperatorCode, int intRelatedProjectID)
    {
        string strHQL;
        IList lst;

        string strReOrPay, strRelatedAccount, strRelatedAccountCode, strReceivableID, strPayableID;

        //如果业务单关联了合同，就不作应付或应收
        if (IsBusinessFormRelatedConstract(strRelatedType, strRelatedID))
        {
            return 0;
        }

        strHQL = "From BusinessFormReAndPay as businessFormReAndPay Where FormCode = " + "'" + strFormCode + "'";
        BusinessFormReAndPayBLL businessFormReAndPayBLL = new BusinessFormReAndPayBLL();
        lst = businessFormReAndPayBLL.GetAllBusinessFormReAndPays(strHQL);
        if (lst.Count > 0)
        {
            BusinessFormReAndPay businessFormReAndPay = (BusinessFormReAndPay)lst[0];

            strReOrPay = businessFormReAndPay.ReceiveOrPay.Trim();

            if (strReOrPay == "Receivables")
            {
                strRelatedAccountCode = businessFormReAndPay.RelatedAccountCode.Trim();
                strRelatedAccount = businessFormReAndPay.RelatedAccount.Trim();

                ConstractReceivablesBLL constractReceivablesBLL = new ConstractReceivablesBLL();
                ConstractReceivables constractReceivables = new ConstractReceivables();

                constractReceivables.ConstractCode = "";
                constractReceivables.BillCode = "";

                constractReceivables.ReceivablesAccount = deAmount;
                constractReceivables.ReceivablesTime = DateTime.Now;

                constractReceivables.AccountCode = strRelatedAccountCode;
                constractReceivables.Account = strRelatedAccount;

                constractReceivables.ReceiverAccount = 0;
                constractReceivables.ReceiverTime = DateTime.Now;

                constractReceivables.InvoiceAccount = 0;
                constractReceivables.UNReceiveAmount = deAmount;
                constractReceivables.CurrencyType = strCurrencyType;

                constractReceivables.Payer = strReOrPayer;

                constractReceivables.OperatorCode = strOperatorCode;
                constractReceivables.OperatorName = GetUserName(strOperatorCode);
                constractReceivables.OperateTime = DateTime.Now;
                constractReceivables.PreDays = 5;
                constractReceivables.Status = "Plan";
                constractReceivables.Comment = "";

                constractReceivables.RelatedType = strRelatedType;
                constractReceivables.RelatedID = int.Parse(strRelatedID);
                constractReceivables.RelatedRecordID = int.Parse(strRelatedRecordID);

                constractReceivables.RelatedProjectID = intRelatedProjectID;

                try
                {
                    constractReceivablesBLL.AddConstractReceivables(constractReceivables);

                    strReceivableID = ShareClass.GetMyCreatedMaxConstractReceivableID("");

                    return int.Parse(strReceivableID);
                }
                catch
                {
                    return 0;
                }
            }
            else
            {
                if (strReOrPay == "Payables")
                {
                    strRelatedAccountCode = businessFormReAndPay.RelatedAccountCode.Trim();
                    strRelatedAccount = businessFormReAndPay.RelatedAccount.Trim();

                    ConstractPayableBLL constractPayableBLL = new ConstractPayableBLL();
                    ConstractPayable constractPayable = new ConstractPayable();

                    constractPayable.ConstractCode = "";
                    constractPayable.BillCode = "";

                    constractPayable.PayableAccount = deAmount;
                    constractPayable.PayableTime = DateTime.Now;

                    constractPayable.AccountCode = strRelatedAccountCode;
                    constractPayable.Account = strRelatedAccount;

                    constractPayable.OutOfPocketAccount = 0;
                    constractPayable.OutOfPocketTime = DateTime.Now;

                    constractPayable.InvoiceAccount = 0;
                    constractPayable.UNPayAmount = deAmount;
                    constractPayable.CurrencyType = strCurrencyType;

                    constractPayable.Receiver = strReOrPayer;

                    constractPayable.OperatorCode = strOperatorCode;
                    constractPayable.OperatorName = GetUserName(strOperatorCode);
                    constractPayable.OperateTime = DateTime.Now;
                    constractPayable.PreDays = 5;
                    constractPayable.Status = "Plan";
                    constractPayable.Comment = "";

                    constractPayable.RelatedType = strRelatedType;
                    constractPayable.RelatedID = int.Parse(strRelatedID);
                    constractPayable.RelatedRecordID = int.Parse(strRelatedRecordID);

                    constractPayable.RelatedProjectID = intRelatedProjectID;

                    try
                    {
                        constractPayableBLL.AddConstractPayable(constractPayable);

                        strPayableID = ShareClass.GetMyCreatedMaxConstractPayableID("");

                        return int.Parse(strPayableID);
                    }
                    catch
                    {
                        return 0;
                    }
                }
                else
                {
                    return 0;
                }
            }
        }
        else
        {
            return 0;
        }
    }

    public static void UpdateReceivablesOrPayable(string strFormCode, string strRelatedType, string strRelatedID, string strRelatedRecordID, Decimal deAmount, string strCurrencyType, string strReOrPayer, string strOperatorCode)
    {
        string strHQL;
        IList lst;

        string strReOrPay, strRelatedAccount, strRelatedAccountCode;
        int intID;

        strHQL = "From BusinessFormReAndPay as businessFormReAndPay Where FormCode = " + "'" + strFormCode + "'";

        BusinessFormReAndPayBLL businessFormReAndPayBLL = new BusinessFormReAndPayBLL();
        lst = businessFormReAndPayBLL.GetAllBusinessFormReAndPays(strHQL);
        if (lst.Count > 0)
        {
            BusinessFormReAndPay businessFormReAndPay = (BusinessFormReAndPay)lst[0];

            strReOrPay = businessFormReAndPay.ReceiveOrPay.Trim();

            if (strReOrPay == "Receivables")
            {
                strRelatedAccountCode = businessFormReAndPay.RelatedAccountCode.Trim();
                strRelatedAccount = businessFormReAndPay.RelatedAccount.Trim();

                strHQL = "From ConstractReceivables as constractReceivables Where constractReceivables.RelatedType = " + "'" + strFormCode + "'" + " and constractReceivables.RelatedRecordID = " + strRelatedRecordID;
                ConstractReceivablesBLL constractReceivablesBLL = new ConstractReceivablesBLL();
                lst = constractReceivablesBLL.GetAllConstractReceivabless(strHQL);

                if (lst.Count > 0)
                {
                    ConstractReceivables constractReceivables = (ConstractReceivables)lst[0];

                    intID = constractReceivables.ID;

                    constractReceivables.ConstractCode = "";
                    constractReceivables.BillCode = "";

                    constractReceivables.ReceivablesAccount = deAmount;
                    constractReceivables.ReceivablesTime = DateTime.Now;
                    constractReceivables.AccountCode = strRelatedAccountCode;
                    constractReceivables.Account = strRelatedAccount;
                    constractReceivables.UNReceiveAmount = deAmount - constractReceivables.ReceiverAccount;

                    constractReceivables.CurrencyType = strCurrencyType;

                    constractReceivables.Payer = strReOrPayer;

                    constractReceivables.OperatorCode = strOperatorCode;
                    constractReceivables.OperatorName = GetUserName(strOperatorCode);
                    constractReceivables.OperateTime = DateTime.Now;
                    constractReceivables.PreDays = 5;

                    constractReceivables.RelatedRecordID = int.Parse(strRelatedRecordID);

                    try
                    {
                        constractReceivablesBLL.UpdateConstractReceivables(constractReceivables, intID);
                    }
                    catch
                    {
                    }
                }
            }

            if (strReOrPay == "Payables")
            {
                strRelatedAccountCode = businessFormReAndPay.RelatedAccountCode.Trim();
                strRelatedAccount = businessFormReAndPay.RelatedAccount.Trim();

                strHQL = "From ConstractPayable as constractPayable Where constractPayable.RelatedType = " + "'" + strFormCode + "'" + " and constractPayable.RelatedRecordID = " + strRelatedRecordID;
                ConstractPayableBLL constractPayableBLL = new ConstractPayableBLL();
                lst = constractPayableBLL.GetAllConstractPayables(strHQL);

                if (lst.Count > 0)
                {
                    ConstractPayable constractPayable = (ConstractPayable)lst[0];

                    intID = constractPayable.ID;
                    constractPayable.ConstractCode = "";
                    constractPayable.BillCode = "";

                    constractPayable.PayableAccount = deAmount;
                    constractPayable.PayableTime = DateTime.Now;
                    constractPayable.AccountCode = strRelatedAccountCode;
                    constractPayable.Account = strRelatedAccount;
                    constractPayable.UNPayAmount = deAmount - constractPayable.OutOfPocketAccount;

                    constractPayable.CurrencyType = strCurrencyType;

                    constractPayable.Receiver = strReOrPayer;

                    constractPayable.OperatorCode = strOperatorCode;
                    constractPayable.OperatorName = GetUserName(strOperatorCode);
                    constractPayable.OperateTime = DateTime.Now;

                    constractPayable.RelatedRecordID = int.Parse(strRelatedRecordID);

                    try
                    {
                        constractPayableBLL.UpdateConstractPayable(constractPayable, intID);
                    }
                    catch
                    {
                    }
                }
            }
        }
    }

    public static void DeleteReceivablesOrPayable(string strFormCode, string strRelatedType, string strRelatedRecordID)
    {
        string strHQL;
        IList lst;

        string strReOrPay;

        strHQL = "From BusinessFormReAndPay as businessFormReAndPay Where businessFormReAndPay.FormCode = " + "'" + strFormCode + "'";
        BusinessFormReAndPayBLL businessFormReAndPayBLL = new BusinessFormReAndPayBLL();
        lst = businessFormReAndPayBLL.GetAllBusinessFormReAndPays(strHQL);
        if (lst.Count > 0)
        {
            BusinessFormReAndPay businessFormReAndPay = (BusinessFormReAndPay)lst[0];

            strReOrPay = businessFormReAndPay.ReceiveOrPay.Trim();

            if (strReOrPay == "Receivables")
            {
                strHQL = "Delete From T_ConstractReceivables Where RelatedType = " + "'" + strRelatedType + "'" + " and RelatedRecordID = " + strRelatedRecordID;
                ShareClass.RunSqlCommand(strHQL);
            }

            if (strReOrPay == "Payables")
            {
                strHQL = "Delete From T_ConstractPayable Where RelatedType = " + "'" + strRelatedType + "'" + " and RelatedRecordID = " + strRelatedRecordID;
                ShareClass.RunSqlCommand(strHQL);
            }
        }
    }

    public static int InsertReceivablesOrPayableByAccount(string strReOrPay, string strFormCode, string strRelatedType, string strRelatedID, string strRelatedRecordID, string strAccountCode, string strAccount, Decimal deAmount, string strCurrencyType, string strReOrPayer, string strOperatorCode, int intRelatedProjectID)
    {
        string strReceivableID, strPayableID;

        if (strReOrPay == "Receivables")
        {
            ConstractReceivablesBLL constractReceivablesBLL = new ConstractReceivablesBLL();
            ConstractReceivables constractReceivables = new ConstractReceivables();

            constractReceivables.ConstractCode = "";
            constractReceivables.BillCode = "";

            constractReceivables.ReceivablesAccount = deAmount;
            constractReceivables.ReceivablesTime = DateTime.Now;

            constractReceivables.AccountCode = strAccountCode;
            constractReceivables.Account = strAccount;

            constractReceivables.ReceiverAccount = 0;
            constractReceivables.ReceiverTime = DateTime.Now;

            constractReceivables.InvoiceAccount = 0;
            constractReceivables.UNReceiveAmount = deAmount;
            constractReceivables.CurrencyType = strCurrencyType;

            constractReceivables.Payer = strReOrPayer;

            constractReceivables.OperatorCode = strOperatorCode;
            constractReceivables.OperatorName = GetUserName(strOperatorCode);
            constractReceivables.OperateTime = DateTime.Now;
            constractReceivables.PreDays = 5;
            constractReceivables.Status = "Completed";
            constractReceivables.Comment = "";

            constractReceivables.RelatedType = strRelatedType;
            constractReceivables.RelatedID = int.Parse(strRelatedID);
            constractReceivables.RelatedRecordID = int.Parse(strRelatedRecordID);

            constractReceivables.RelatedProjectID = intRelatedProjectID;

            try
            {
                constractReceivablesBLL.AddConstractReceivables(constractReceivables);

                strReceivableID = ShareClass.GetMyCreatedMaxConstractReceivableID("");

                return int.Parse(strReceivableID);
            }
            catch
            {
                return 0;
            }
        }
        else
        {
            if (strReOrPay == "Payables")
            {
                ConstractPayableBLL constractPayableBLL = new ConstractPayableBLL();
                ConstractPayable constractPayable = new ConstractPayable();

                constractPayable.ConstractCode = "";
                constractPayable.BillCode = "";

                constractPayable.PayableAccount = deAmount;
                constractPayable.PayableTime = DateTime.Now;

                constractPayable.AccountCode = strAccountCode;
                constractPayable.Account = strAccount;

                constractPayable.OutOfPocketAccount = 0;
                constractPayable.OutOfPocketTime = DateTime.Now;

                constractPayable.InvoiceAccount = 0;
                constractPayable.UNPayAmount = deAmount;
                constractPayable.CurrencyType = strCurrencyType;

                constractPayable.Receiver = strReOrPayer;

                constractPayable.OperatorCode = strOperatorCode;
                constractPayable.OperatorName = GetUserName(strOperatorCode);
                constractPayable.OperateTime = DateTime.Now;
                constractPayable.PreDays = 5;
                constractPayable.Status = "Completed";
                constractPayable.Comment = "";

                constractPayable.RelatedType = strRelatedType;
                constractPayable.RelatedID = int.Parse(strRelatedID);
                constractPayable.RelatedRecordID = int.Parse(strRelatedRecordID);

                constractPayable.RelatedProjectID = intRelatedProjectID;

                try
                {
                    constractPayableBLL.AddConstractPayable(constractPayable);

                    strPayableID = ShareClass.GetMyCreatedMaxConstractPayableID("");

                    return int.Parse(strPayableID);
                }
                catch
                {
                    return 0;
                }
            }
            else
            {
                return 0;
            }
        }
    }

    //插入收付款记录
    public static void InsertReceivablesOrPayableRecord(string strReOrPay, int intRelatedID, Decimal deAmount, string strCurrencyType, string strReOrPayerType, string strReOrPayer, string strOperatorCode, int intRelatedProjectID)
    {
        if (strReOrPay == "Receivables")
        {
            ConstractReceivablesRecordBLL constractReceivablesRecordBLL = new ConstractReceivablesRecordBLL();
            ConstractReceivablesRecord constractReceivablesRecord = new ConstractReceivablesRecord();

            constractReceivablesRecord.ReceivablesID = intRelatedID;
            constractReceivablesRecord.ConstractCode = "";

            constractReceivablesRecord.ReAndPayType = strReOrPayerType;
            constractReceivablesRecord.Currency = strCurrencyType; ;
            constractReceivablesRecord.Bank = "";
            constractReceivablesRecord.ExchangeRate = GetExchangeRateByCurrencyType(strCurrencyType);

            constractReceivablesRecord.ReceiverAccount = deAmount;
            constractReceivablesRecord.ReceiverTime = DateTime.Now;
            constractReceivablesRecord.InvoiceAccount = deAmount;

            constractReceivablesRecord.Payer = strReOrPayer;
            constractReceivablesRecord.OperatorCode = strOperatorCode;
            constractReceivablesRecord.OperatorName = ShareClass.GetUserName(strOperatorCode);
            constractReceivablesRecord.OperateTime = DateTime.Now;
            constractReceivablesRecord.Comment = "";

            constractReceivablesRecord.RelatedProjectID = intRelatedProjectID;

            try
            {
                constractReceivablesRecordBLL.AddConstractReceivablesRecord(constractReceivablesRecord);
            }
            catch
            {
            }
        }

        if (strReOrPay == "Payables")
        {
            decimal deExchangRate = GetExchangeRateByCurrencyType(strCurrencyType);

            ConstractPayableRecordBLL constractPayableRecordBLL = new ConstractPayableRecordBLL();
            ConstractPayableRecord constractPayableRecord = new ConstractPayableRecord();

            constractPayableRecord.PayableID = intRelatedID;
            constractPayableRecord.ConstractCode = "";

            constractPayableRecord.ReAndPayType = strReOrPayerType;
            constractPayableRecord.Currency = strCurrencyType;
            constractPayableRecord.Bank = "";
            constractPayableRecord.ExchangeRate = deExchangRate;

            constractPayableRecord.OutOfPocketAccount = deAmount;
            constractPayableRecord.OutOfPocketTime = DateTime.Now;
            constractPayableRecord.InvoiceAccount = deAmount;
            constractPayableRecord.HomeCurrencyAmount = deAmount * deExchangRate;

            constractPayableRecord.Receiver = strReOrPayer;
            constractPayableRecord.OperatorCode = strOperatorCode;
            constractPayableRecord.OperatorName = ShareClass.GetUserName(strOperatorCode);
            constractPayableRecord.OperateTime = DateTime.Now;
            constractPayableRecord.Comment = "";

            constractPayableRecord.RelatedProjectID = intRelatedProjectID;

            try
            {
                constractPayableRecordBLL.AddConstractPayableRecord(constractPayableRecord);
            }
            catch
            {
            }
        }
    }

    //取得汇率
    public static decimal GetExchangeRateByCurrencyType(string strCurrencyType)
    {
        string strHQL;

        strHQL = "Select ExchangeRate From T_CurrencyType Where Type = " + "'" + strCurrencyType + "'";
        DataSet ds = ShareClass.GetDataSetFromSql(strHQL, "T_CurrencyType");

        if (ds.Tables[0].Rows.Count > 0)
        {
            return decimal.Parse(ds.Tables[0].Rows[0][0].ToString());
        }
        else
        {
            return 1;
        }
    }

    #endregion 财务或物料操作函数

}
