using System;
using System.Collections;
using System.Collections.Generic;
using System.Data;
using System.IO;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class TTPersonalSpaceModuleFlowView : System.Web.UI.Page
{
    private static readonly Dictionary<string, DataSet> _flowCache = new Dictionary<string, DataSet>();
    private static readonly object _flowCacheLock = new object();
    private const int FLOW_CACHE_MINUTES = 10;

    protected void Page_Load(object sender, EventArgs e)
    {
        if (Page.IsPostBack == false)
        {
            litIframeModuleFlowHTML.Visible = false;

            string strUserCode = Session["UserCode"].ToString();
            string strUserType = Session["UserType"].ToString();
            string strLangCode = Session["LangCode"].ToString();
            string cacheKey = strUserCode + "_" + strUserType + "_" + strLangCode;

            DataSet dsModuleFlow = null;
            lock (_flowCacheLock)
            {
                if (_flowCache.TryGetValue(cacheKey, out dsModuleFlow))
                {
                }
            }

            if (dsModuleFlow == null)
            {
                dsModuleFlow = ShareClass.GetSystemModuleFlowDataSet("OperateNavigation", strUserCode, strUserType, strLangCode);
                lock (_flowCacheLock)
                {
                    _flowCache[cacheKey] = dsModuleFlow;
                }
            }

            RP_iframeModuleFlow.DataSource = dsModuleFlow;
            RP_iframeModuleFlow.DataBind();
        }

    }

}